-- ═══════════════════════════════════════════════════════════════
-- مِشوارَك · مخطط قاعدة بيانات Supabase
-- ═══════════════════════════════════════════════════════════════
-- طريقة التشغيل:
--   1. افتح مشروعك على supabase.com → SQL Editor
--   2. الصق هذا الملف كاملاً ثم Run
--   3. شغّل بعده seed.sql لتعبئة أنواع المركبات
--
-- المخطط مبني على شاشات التطبيق الفعلية:
--   الملف الشخصي · العناوين المحفوظة · جهات الطوارئ · المحفظة
--   سجل الرحلات · التقييمات · الإشعارات · أنواع المركبات · السائقون
-- ═══════════════════════════════════════════════════════════════

-- ─────────── الامتدادات ───────────
create extension if not exists "uuid-ossp";

-- ═══════════════════════════════════════════════════════════════
-- 1) الأنواع المعدودة (Enums)
-- ═══════════════════════════════════════════════════════════════

do $$ begin
  create type vehicle_category as enum ('economy', 'comfort', 'xl', 'women', 'vip');
exception when duplicate_object then null; end $$;

do $$ begin
  create type ride_status as enum (
    'requested',        -- بحث عن سائق
    'driver_assigned',  -- تم تعيين سائق
    'arriving',         -- السائق في الطريق
    'arrived',          -- السائق وصل
    'on_trip',          -- الرحلة جارية
    'completed',        -- انتهت
    'cancelled'         -- ملغاة
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type payment_method as enum ('wallet', 'cash', 'card');
exception when duplicate_object then null; end $$;

do $$ begin
  create type transaction_type as enum ('credit', 'debit');
exception when duplicate_object then null; end $$;

do $$ begin
  create type place_label as enum ('home', 'work', 'other');
exception when duplicate_object then null; end $$;

-- ═══════════════════════════════════════════════════════════════
-- 2) الملفات الشخصية — تمتد من auth.users
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  full_name     text,
  email         text,
  phone         text unique,
  avatar_url    text,
  rating        numeric(3,2) default 5.00 check (rating between 0 and 5),
  points        integer      default 0 check (points >= 0),
  is_female     boolean      default false,
  locale        text         default 'ar',
  created_at    timestamptz  default now(),
  updated_at    timestamptz  default now()
);

comment on table public.profiles is 'بيانات الراكب — مرتبطة بحساب المصادقة';

-- إنشاء ملف شخصي تلقائياً عند تسجيل مستخدم جديد
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, phone, email, full_name)
  values (
    new.id,
    new.phone,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', '')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ═══════════════════════════════════════════════════════════════
-- 3) العناوين المحفوظة (المنزل / العمل / مخصّص)
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.saved_places (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  label       place_label not null default 'other',
  name        text not null,          -- "المنزل"
  address     text not null,          -- "كريتر"
  lat         double precision not null,
  lng         double precision not null,
  created_at  timestamptz default now()
);

create index if not exists saved_places_user_idx on public.saved_places(user_id);

-- ═══════════════════════════════════════════════════════════════
-- 4) جهات الطوارئ (زر SOS)
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.emergency_contacts (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  name        text not null,
  phone       text not null,
  created_at  timestamptz default now()
);

create index if not exists emergency_contacts_user_idx
  on public.emergency_contacts(user_id);

-- ═══════════════════════════════════════════════════════════════
-- 5) أنواع المركبات — بيانات مرجعية عامة
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.vehicle_types (
  id              text primary key,           -- 'eco', 'comfort', ...
  category        vehicle_category not null,
  name_ar         text not null,
  name_en         text not null,
  description_ar  text,
  description_en  text,
  seats           smallint not null default 4,
  base_price      integer  not null,          -- بالريال اليمني
  price_per_km    integer  not null default 0,
  eta_minutes     smallint not null default 5,
  badge_ar        text,
  badge_en        text,
  image_url       text,
  sort_order      smallint default 0,
  is_active       boolean  default true
);

comment on column public.vehicle_types.base_price is 'السعر الأساسي بالريال اليمني';

-- ═══════════════════════════════════════════════════════════════
-- 6) السائقون
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.drivers (
  id                uuid primary key default uuid_generate_v4(),
  user_id           uuid unique references auth.users(id) on delete set null,
  full_name         text not null,
  phone             text not null,
  photo_url         text,
  rating            numeric(3,2) default 5.00 check (rating between 0 and 5),
  completed_trips   integer default 0,
  car_model         text not null,            -- "تويوتا هايلوكس"
  car_color         text not null,            -- "أبيض"
  plate_number      text not null unique,     -- "ADN 4287"
  vehicle_type_id   text references public.vehicle_types(id),
  is_female         boolean default false,
  is_online         boolean default false,
  current_lat       double precision,
  current_lng       double precision,
  location_updated_at timestamptz,
  created_at        timestamptz default now()
);

-- للبحث عن أقرب سائق متاح
create index if not exists drivers_online_idx
  on public.drivers(is_online, vehicle_type_id) where is_online = true;

-- ═══════════════════════════════════════════════════════════════
-- 7) الرحلات
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.rides (
  id                uuid primary key default uuid_generate_v4(),
  passenger_id      uuid not null references public.profiles(id) on delete cascade,
  driver_id         uuid references public.drivers(id) on delete set null,
  vehicle_type_id   text references public.vehicle_types(id),
  status            ride_status not null default 'requested',

  pickup_address    text not null,
  pickup_lat        double precision not null,
  pickup_lng        double precision not null,
  dest_address      text not null,
  dest_lat          double precision not null,
  dest_lng          double precision not null,

  fare              integer not null default 0,   -- الإجمالي المدفوع
  base_fare         integer not null default 0,
  distance_fare     integer not null default 0,
  discount          integer not null default 0,
  tip               integer not null default 0,
  distance_km       numeric(6,2) default 0,
  payment_method    payment_method not null default 'wallet',

  cancel_reason     text,
  requested_at      timestamptz default now(),
  started_at        timestamptz,
  completed_at      timestamptz,

  constraint fare_non_negative check (fare >= 0)
);

create index if not exists rides_passenger_idx
  on public.rides(passenger_id, requested_at desc);
create index if not exists rides_driver_idx  on public.rides(driver_id);
create index if not exists rides_status_idx  on public.rides(status);

-- ═══════════════════════════════════════════════════════════════
-- 8) تقييمات الرحلات
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.ride_ratings (
  id          uuid primary key default uuid_generate_v4(),
  ride_id     uuid not null unique references public.rides(id) on delete cascade,
  passenger_id uuid not null references public.profiles(id) on delete cascade,
  driver_id   uuid references public.drivers(id) on delete set null,
  rating      smallint not null check (rating between 1 and 5),
  tags        text[] default '{}',      -- ['قيادة آمنة', 'سيارة نظيفة']
  comment     text,
  tip         integer default 0,
  created_at  timestamptz default now()
);

create index if not exists ride_ratings_driver_idx on public.ride_ratings(driver_id);
create index if not exists ride_ratings_passenger_idx
  on public.ride_ratings(passenger_id);

-- يملأ `driver_id` من الرحلة نفسها.
--
-- التطبيق لا يرسله (ولا يجب أن يرسله: الراكب لا يقرأ جدول السائقين إلا
-- لسائق رحلته)، وبدونه يبقى العمود NULL فيتخطّاه `refresh_driver_rating`
-- بشرط `if new.driver_id is not null` — أي أن متوسط تقييم السائقين
-- كان يظل 5.00 مهما بلغ عدد التقييمات.
create or replace function public.fill_rating_driver()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if new.driver_id is null then
    select r.driver_id into new.driver_id
    from public.rides r where r.id = new.ride_id;
  end if;
  return new;
end;
$$;

drop trigger if exists on_rating_fill_driver on public.ride_ratings;
create trigger on_rating_fill_driver
  before insert on public.ride_ratings
  for each row execute function public.fill_rating_driver();

-- تحديث متوسط تقييم السائق تلقائياً
create or replace function public.refresh_driver_rating()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if new.driver_id is not null then
    update public.drivers d
    set rating = (
      select round(avg(r.rating)::numeric, 2)
      from public.ride_ratings r
      where r.driver_id = new.driver_id
    )
    where d.id = new.driver_id;
  end if;
  return new;
end;
$$;

drop trigger if exists on_rating_created on public.ride_ratings;
create trigger on_rating_created
  after insert or update on public.ride_ratings
  for each row execute function public.refresh_driver_rating();

-- ═══════════════════════════════════════════════════════════════
-- 9) المحفظة — الرصيد محسوب من المعاملات (مصدر حقيقة واحد)
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.wallet_transactions (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  ride_id     uuid references public.rides(id) on delete set null,
  type        transaction_type not null,
  amount      integer not null check (amount > 0),  -- دائماً موجب؛ النوع يحدد الاتجاه
  description text not null,
  created_at  timestamptz default now()
);

create index if not exists wallet_tx_user_idx
  on public.wallet_transactions(user_id, created_at desc);

-- الرصيد الحالي لكل مستخدم
--
-- ‼️ `security_invoker` ليست تحسيناً اختيارياً.
-- العروض في Postgres تُنفَّذ بصلاحية مالكها افتراضياً، ومالكها هنا
-- يتجاوز RLS. وPostgREST يكشف العرض على `/rest/v1/wallet_balances`،
-- فكان أي مستخدم — بل أي زائر — يقرأ أرصدة كل المستخدمين بطلب واحد.
-- مع هذا الخيار يُنفَّذ العرض بصلاحية السائل، فتنطبق سياسة
-- `wallet_transactions` ولا يرى كلٌّ إلا صفّه.
create or replace view public.wallet_balances
with (security_invoker = on)
as
select
  user_id,
  coalesce(sum(case when type = 'credit' then amount else -amount end), 0) as balance
from public.wallet_transactions
group by user_id;

-- دالة مساعدة: رصيدي
create or replace function public.my_wallet_balance()
returns integer
language sql
stable
security definer set search_path = public
as $$
  select coalesce(
    (select balance from public.wallet_balances where user_id = auth.uid()),
    0
  )::integer;
$$;

-- ═══════════════════════════════════════════════════════════════
-- 10) الإشعارات
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.notifications (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  type        text not null default 'general',  -- promo | ride | points | rating
  title       text not null,
  subtitle    text,
  is_read     boolean default false,
  created_at  timestamptz default now()
);

-- بيانات الإشعار منفصلة عن نصّه.
--
-- `title`/`subtitle` تُكتب بلغة واحدة وقت الإنشاء، فيراها مستخدم
-- الإنجليزية بالعربية. حين يعرف التطبيق `type` ومعه هذه البيانات
-- يبني النص بلغة المستخدم، ويرجع للنص المخزَّن إن كان النوع مجهولاً.
alter table public.notifications
  add column if not exists payload jsonb not null default '{}'::jsonb;

create index if not exists notifications_user_idx
  on public.notifications(user_id, created_at desc);
create index if not exists notifications_unread_idx
  on public.notifications(user_id) where is_read = false;

-- ═══════════════════════════════════════════════════════════════
-- 11) كوبونات الخصم
-- ═══════════════════════════════════════════════════════════════

create table if not exists public.promo_codes (
  code            text primary key,
  description_ar  text,
  discount_percent smallint check (discount_percent between 1 and 100),
  discount_amount  integer,
  max_discount     integer,
  valid_from      timestamptz default now(),
  valid_until     timestamptz,
  usage_limit     integer,
  used_count      integer default 0,
  is_active       boolean default true
);

create table if not exists public.promo_redemptions (
  id          uuid primary key default uuid_generate_v4(),
  code        text not null references public.promo_codes(code) on delete cascade,
  user_id     uuid not null references public.profiles(id) on delete cascade,
  ride_id     uuid references public.rides(id) on delete set null,
  redeemed_at timestamptz default now(),
  unique (code, user_id)   -- كوبون واحد لكل مستخدم
);

-- ═══════════════════════════════════════════════════════════════
-- 12) أمان مستوى الصف (RLS)
-- ═══════════════════════════════════════════════════════════════
-- القاعدة: كل مستخدم يرى بياناته فقط.
-- الجداول المرجعية (أنواع المركبات، الكوبونات) للقراءة العامة.
--
-- ‼️ السياسات المتعددة على الجدول الواحد تُجمع بـ OR، فبقاء سياسة
-- قديمة متساهلة يُبطل الجديدة تماماً. نسخة سابقة من هذا الملف كانت
-- تسمّي السياسات بالإنجليزية، والقواعد المُنشأة منها تحمل تلك
-- الأسماء — فلا تُطابقها عبارات `drop` العربية أدناه. نحذفها هنا
-- بالاسمين معاً حتى يبقى الملف صالحاً للتشغيل على أي قاعدة.

drop policy if exists "read my profile"              on public.profiles;
drop policy if exists "update my profile"            on public.profiles;
drop policy if exists "manage my places"             on public.saved_places;
drop policy if exists "manage my emergency contacts" on public.emergency_contacts;
drop policy if exists "read vehicle types"           on public.vehicle_types;
drop policy if exists "read available drivers"       on public.drivers;
drop policy if exists "read my rides"                on public.rides;
drop policy if exists "create ride"                  on public.rides;
drop policy if exists "update my active ride"        on public.rides;
drop policy if exists "read my ratings"              on public.ride_ratings;
drop policy if exists "rate my completed ride"       on public.ride_ratings;
drop policy if exists "read my transactions"         on public.wallet_transactions;
drop policy if exists "read my notifications"        on public.notifications;
drop policy if exists "mark notification read"       on public.notifications;
drop policy if exists "read active promo codes"      on public.promo_codes;
drop policy if exists "use promo codes"              on public.promo_redemptions;

alter table public.profiles            enable row level security;
alter table public.saved_places        enable row level security;
alter table public.emergency_contacts  enable row level security;
alter table public.vehicle_types       enable row level security;
alter table public.drivers             enable row level security;
alter table public.rides               enable row level security;
alter table public.ride_ratings        enable row level security;
alter table public.wallet_transactions enable row level security;
alter table public.notifications       enable row level security;
alter table public.promo_codes         enable row level security;
alter table public.promo_redemptions   enable row level security;

-- ─────────── profiles ───────────
drop policy if exists "قراءة ملفي" on public.profiles;
create policy "قراءة ملفي" on public.profiles
  for select using (auth.uid() = id);

drop policy if exists "تعديل ملفي" on public.profiles;
create policy "تعديل ملفي" on public.profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

-- ─────────── saved_places ───────────
drop policy if exists "إدارة عناويني" on public.saved_places;
create policy "إدارة عناويني" on public.saved_places
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ─────────── emergency_contacts ───────────
drop policy if exists "إدارة جهات طوارئي" on public.emergency_contacts;
create policy "إدارة جهات طوارئي" on public.emergency_contacts
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ─────────── vehicle_types (قراءة عامة) ───────────
drop policy if exists "قراءة أنواع المركبات" on public.vehicle_types;
create policy "قراءة أنواع المركبات" on public.vehicle_types
  for select using (is_active = true);

-- ─────────── drivers ───────────
-- الراكب يرى سائق رحلته فقط — لا كل السائقين المتّصلين.
--
-- السياسة السابقة كانت `is_online = true or ...`، وهي تكشف لأي حساب
-- مسجَّل: الاسم الكامل ورقم الجوال ورقم اللوحة والموقع الحيّ لكل سائق
-- في المدينة، ويمكن استخراجها كاملة باستعلام واحد. التوزيع لا يحتاجها
-- أصلاً لأن `assign_nearest_driver` يعمل بصلاحية `security definer`،
-- ولعرض السيارات على الخريطة توجد `nearby_drivers()` بلا هوية.
drop policy if exists "قراءة السائقين المتاحين" on public.drivers;
drop policy if exists "قراءة سائق رحلتي" on public.drivers;
create policy "قراءة سائق رحلتي" on public.drivers
  for select using (
    exists (
      select 1 from public.rides r
      where r.driver_id = drivers.id and r.passenger_id = auth.uid()
    )
  );

-- السائق يحدّث موقعه وحالته (عندما يُبنى تطبيق السائق على نفس القاعدة).
drop policy if exists "السائق يحدّث بياناته" on public.drivers;
create policy "السائق يحدّث بياناته" on public.drivers
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- سيارات متاحة قريبة، بلا أي بيانات تعريفية — لتحريك العلامات على الخريطة.
create or replace function public.nearby_drivers(
  center_lat double precision,
  center_lng double precision,
  radius_km  double precision default 5,
  max_rows   integer default 12
)
returns table (lat double precision, lng double precision, vehicle_type_id text)
language sql
stable
security definer set search_path = public
as $$
  select d.current_lat, d.current_lng, d.vehicle_type_id
  from public.drivers d
  where d.is_online = true
    and d.current_lat is not null
    and d.current_lng is not null
    -- تقريب رخيص: درجة العرض ≈ 111 كم، والطول يُصحَّح بجيب تمام العرض.
    and power((d.current_lat - center_lat) * 111.0, 2) +
        power((d.current_lng - center_lng) * 111.0 *
              cos(radians(center_lat)), 2) <= power(radius_km, 2)
  order by power(d.current_lat - center_lat, 2) +
           power(d.current_lng - center_lng, 2)
  limit least(greatest(max_rows, 1), 50);
$$;

-- ─────────── rides ───────────
drop policy if exists "قراءة رحلاتي" on public.rides;
create policy "قراءة رحلاتي" on public.rides
  for select using (auth.uid() = passenger_id);

drop policy if exists "إنشاء رحلة" on public.rides;
create policy "إنشاء رحلة" on public.rides
  for insert with check (auth.uid() = passenger_id);

-- الإلغاء هو التعديل الوحيد المسموح للراكب على رحلته.
--
-- ‼️ `with check` مذكورة صراحةً وليست سهواً: حين تُحذف، يستخدم Postgres
-- تعبير `using` نفسه للتحقق من الصف الجديد — فتُرفض كل محاولة إلغاء
-- لأن الصف الجديد حالته 'cancelled' وهي مستبعَدة في `using`.
-- أي أن السياسة "للإلغاء" كانت تمنع الإلغاء وحده.
drop policy if exists "تعديل رحلتي الجارية" on public.rides;
drop policy if exists "إلغاء رحلتي" on public.rides;
create policy "إلغاء رحلتي" on public.rides
  for update
  using (
    auth.uid() = passenger_id
    and status not in ('completed', 'cancelled')
  )
  with check (
    auth.uid() = passenger_id
    and status = 'cancelled'
  );

-- الأعمدة الحسّاسة (الأجرة، السائق، المسار) تُثبَّت على قيمها الأصلية:
-- سياسة RLS لا تستطيع مقارنة الصف القديم بالجديد، فيتكفّل المُشغِّل بذلك.
-- بدونه يستطيع الراكب إرسال `fare = 0` مع طلب الإلغاء.
create or replace function public.protect_ride_columns()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  -- التعديلات القادمة من الخادم (service_role) تمرّ كما هي.
  if auth.uid() is null then return new; end if;

  -- الدوال الموثوقة (`redeem_promo`) ترفع هذه الراية قبل تعديلها.
  -- ضرورية لأن `auth.uid()` يبقى معرّف المستخدم حتى داخل دالة
  -- `security definer`، فلا يكفي كتمييز بين العميل والخادم.
  if coalesce(current_setting('app.trusted_write', true), 'off') = 'on' then
    return new;
  end if;

  new.passenger_id    := old.passenger_id;
  new.driver_id       := old.driver_id;
  new.vehicle_type_id := old.vehicle_type_id;
  new.fare            := old.fare;
  new.base_fare       := old.base_fare;
  new.distance_fare   := old.distance_fare;
  new.discount        := old.discount;
  new.tip             := old.tip;
  new.distance_km     := old.distance_km;
  new.pickup_address  := old.pickup_address;
  new.pickup_lat      := old.pickup_lat;
  new.pickup_lng      := old.pickup_lng;
  new.dest_address    := old.dest_address;
  new.dest_lat        := old.dest_lat;
  new.dest_lng        := old.dest_lng;
  new.requested_at    := old.requested_at;
  return new;
end;
$$;

drop trigger if exists on_ride_passenger_update on public.rides;
create trigger on_ride_passenger_update
  before update on public.rides
  for each row execute function public.protect_ride_columns();

-- ─────────── ride_ratings ───────────
drop policy if exists "قراءة تقييماتي" on public.ride_ratings;
create policy "قراءة تقييماتي" on public.ride_ratings
  for select using (auth.uid() = passenger_id);

-- لا يُقيَّم إلا رحلة مكتملة تخصّني
drop policy if exists "تقييم رحلتي المكتملة" on public.ride_ratings;
create policy "تقييم رحلتي المكتملة" on public.ride_ratings
  for insert with check (
    auth.uid() = passenger_id
    and exists (
      select 1 from public.rides r
      where r.id = ride_id
        and r.passenger_id = auth.uid()
        and r.status = 'completed'
    )
  );

-- ─────────── wallet_transactions ───────────
-- القراءة فقط؛ الإضافة تتم من الخادم (service_role) لمنع التلاعب بالرصيد
drop policy if exists "قراءة معاملاتي" on public.wallet_transactions;
create policy "قراءة معاملاتي" on public.wallet_transactions
  for select using (auth.uid() = user_id);

-- ─────────── notifications ───────────
drop policy if exists "قراءة إشعاراتي" on public.notifications;
create policy "قراءة إشعاراتي" on public.notifications
  for select using (auth.uid() = user_id);

drop policy if exists "تحديد الإشعار مقروءاً" on public.notifications;
create policy "تحديد الإشعار مقروءاً" on public.notifications
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ─────────── promo_codes (قراءة عامة للفعّال) ───────────
drop policy if exists "قراءة الكوبونات الفعّالة" on public.promo_codes;
create policy "قراءة الكوبونات الفعّالة" on public.promo_codes
  for select using (
    is_active = true
    and (valid_until is null or valid_until > now())
  );

-- ─────────── promo_redemptions ───────────
drop policy if exists "استخدام الكوبونات" on public.promo_redemptions;
create policy "استخدام الكوبونات" on public.promo_redemptions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ═══════════════════════════════════════════════════════════════
-- 13) التتبّع الحيّ (Realtime)
-- ═══════════════════════════════════════════════════════════════
-- يتيح للتطبيق الاشتراك في تغيّر حالة الرحلة وموقع السائق.

do $$ begin
  alter publication supabase_realtime add table public.rides;
exception when duplicate_object then null; end $$;

do $$ begin
  alter publication supabase_realtime add table public.drivers;
exception when duplicate_object then null; end $$;

do $$ begin
  alter publication supabase_realtime add table public.notifications;
exception when duplicate_object then null; end $$;

-- بدون REPLICA IDENTITY FULL لا تصل أحداث UPDATE للعملاء عبر RLS،
-- فتتجمّد شاشة الرحلة على حالتها الأولى.
alter table public.rides   replica identity full;
alter table public.drivers replica identity full;

-- ═══════════════════════════════════════════════════════════════
-- 14) التوزيع (Dispatch) — تعيين أقرب سائق متاح
-- ═══════════════════════════════════════════════════════════════
-- يُنفَّذ على الخادم لا في التطبيق، حتى لا يستطيع الراكب اختيار سائقه
-- أو تعيين سائق مشغول.

create or replace function public.assign_nearest_driver()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  chosen uuid;
begin
  select d.id into chosen
  from public.drivers d
  where d.is_online = true
    and d.vehicle_type_id = new.vehicle_type_id
    -- السائق المرتبط برحلة لم تُغلق بعد غير متاح
    and not exists (
      select 1 from public.rides r
      where r.driver_id = d.id
        and r.status not in ('completed', 'cancelled')
    )
  -- ترتيب بمربّع المسافة: كافٍ للمقارنة وأرخص من PostGIS
  order by (
    power(coalesce(d.current_lat, 0) - new.pickup_lat, 2) +
    power(coalesce(d.current_lng, 0) - new.pickup_lng, 2)
  )
  limit 1;

  -- لا سائق متاح: تبقى الرحلة `requested` والتطبيق يعرض ذلك للراكب.
  if chosen is not null then
    new.driver_id := chosen;
    new.status := 'driver_assigned';
  end if;

  return new;
end;
$$;

drop trigger if exists on_ride_requested on public.rides;
create trigger on_ride_requested
  before insert on public.rides
  for each row execute function public.assign_nearest_driver();

-- ═══════════════════════════════════════════════════════════════
-- 15) دورة حياة الرحلة — الطوابع الزمنية والعدّادات
-- ═══════════════════════════════════════════════════════════════
-- كانت هذه الحقول تُكتب من التطبيق (`completed_at` مثلاً يُرسل مع
-- الإلغاء)، وهو ما يجعلها قابلة للتزوير ويتركها فارغة إن غيّر الحالةَ
-- طرفٌ آخر (تطبيق السائق، لوحة التحكم). مكانها الطبيعي هنا.

create or replace function public.stamp_ride_lifecycle()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if new.status is distinct from old.status then
    if new.status = 'on_trip' and new.started_at is null then
      new.started_at := now();
    end if;

    if new.status in ('completed', 'cancelled') and new.completed_at is null then
      new.completed_at := now();
    end if;
  end if;

  -- ملاحظة: عدّاد رحلات السائق يزيد في `settle_completed_ride` (AFTER)
  -- لا هنا. المُشغِّل BEFORE يسبق تقييم `with check` في RLS، فتعديل
  -- جدول آخر منه يقع قبل أن يُعرف إن كان التعديل مسموحاً أصلاً.
  return new;
end;
$$;

drop trigger if exists on_ride_lifecycle on public.rides;
create trigger on_ride_lifecycle
  before update on public.rides
  for each row execute function public.stamp_ride_lifecycle();

-- ═══════════════════════════════════════════════════════════════
-- 16) تسوية المحفظة والنقاط عند اكتمال الرحلة
-- ═══════════════════════════════════════════════════════════════
-- الخصم يتم هنا لا في التطبيق: جدول `wallet_transactions` بلا سياسة
-- INSERT عمداً، فلا يستطيع أي عميل إضافة رصيد لنفسه. المُشغِّل يعمل
-- بـ `security definer` فيتجاوز RLS بأمان.

create or replace function public.settle_completed_ride()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  payable integer;
begin
  if new.status <> 'completed' or old.status = 'completed' then
    return new;
  end if;

  payable := greatest(coalesce(new.fare, 0) - coalesce(new.discount, 0), 0)
             + coalesce(new.tip, 0);

  -- عدّاد رحلات السائق — مرة واحدة، بعد تأكّد الاكتمال.
  if new.driver_id is not null then
    update public.drivers
    set completed_trips = completed_trips + 1
    where id = new.driver_id;
  end if;

  -- النقد يُدفع للسائق مباشرة، فلا يمسّ المحفظة.
  if new.payment_method = 'wallet' and payable > 0 then
    insert into public.wallet_transactions
      (user_id, ride_id, type, amount, description)
    values (new.passenger_id, new.id, 'debit', payable, 'رحلة');
  end if;

  -- نقطة ولاء لكل 100 ريال من قيمة الرحلة.
  update public.profiles
  set points = points + greatest(payable / 100, 0),
      updated_at = now()
  where id = new.passenger_id;

  insert into public.notifications (user_id, type, title, subtitle, payload)
  values (
    new.passenger_id,
    'ride_completed',
    'اكتملت رحلتك',
    new.pickup_address || ' ← ' || new.dest_address,
    jsonb_build_object(
      'ride_id', new.id,
      'from',    new.pickup_address,
      'to',      new.dest_address,
      'fare',    payable
    )
  );

  return new;
end;
$$;

drop trigger if exists on_ride_settled on public.rides;
create trigger on_ride_settled
  after update on public.rides
  for each row execute function public.settle_completed_ride();

-- ═══════════════════════════════════════════════════════════════
-- 17) الكوبونات — التحقّق والاستخدام
-- ═══════════════════════════════════════════════════════════════

alter table public.promo_codes
  add column if not exists description_en text;

create index if not exists promo_redemptions_user_idx
  on public.promo_redemptions(user_id);

-- جدول `promo_redemptions` كان مفتوحاً للكتابة المباشرة (`for all`)،
-- فيستطيع المستخدم تسجيل استخدام كوبون منتهٍ أو تجاوز حدّ الاستخدام
-- أو منح نفسه خصماً بلا سقف. نُبقي القراءة له، ونحصر الكتابة في
-- الدالتين أدناه لأنهما تتحقّقان أولاً.
drop policy if exists "استخدام الكوبونات" on public.promo_redemptions;
drop policy if exists "قراءة كوبوناتي المستخدمة" on public.promo_redemptions;
create policy "قراءة كوبوناتي المستخدمة" on public.promo_redemptions
  for select using (auth.uid() = user_id);

-- يتحقق من الكوبون ويعيد قيمة الخصم بالريال دون تسجيله — للمعاينة
-- في شاشة اختيار المركبة قبل تأكيد الطلب.
create or replace function public.preview_promo(
  promo_code text,
  ride_fare  integer
)
returns table (valid boolean, reason text, discount integer)
language plpgsql
stable
security definer set search_path = public
as $$
declare
  c public.promo_codes%rowtype;
  amount integer;
begin
  select * into c from public.promo_codes
  where code = upper(trim(promo_code));

  if not found then
    return query select false, 'not_found', 0; return;
  end if;
  if not c.is_active
     or (c.valid_until is not null and c.valid_until <= now()) then
    return query select false, 'expired', 0; return;
  end if;
  if c.valid_from is not null and c.valid_from > now() then
    return query select false, 'not_started', 0; return;
  end if;
  if c.usage_limit is not null and c.used_count >= c.usage_limit then
    return query select false, 'exhausted', 0; return;
  end if;
  if exists (
    select 1 from public.promo_redemptions r
    where r.code = c.code and r.user_id = auth.uid()
  ) then
    return query select false, 'already_used', 0; return;
  end if;

  amount := coalesce(c.discount_amount, 0);
  if c.discount_percent is not null then
    amount := greatest(amount, (ride_fare * c.discount_percent) / 100);
  end if;
  if c.max_discount is not null then
    amount := least(amount, c.max_discount);
  end if;

  return query select true, 'ok', least(amount, ride_fare);
end;
$$;

-- يسجّل استخدام الكوبون على رحلة ويطبّق الخصم — عملية واحدة ذرّية.
create or replace function public.redeem_promo(
  promo_code  text,
  target_ride uuid
)
returns integer
language plpgsql
security definer set search_path = public
as $$
declare
  r public.rides%rowtype;
  verdict record;
begin
  select * into r from public.rides
  where id = target_ride and passenger_id = auth.uid();
  if not found then
    raise exception 'ride_not_found';
  end if;
  if r.status in ('completed', 'cancelled') then
    raise exception 'ride_closed';
  end if;

  select * into verdict from public.preview_promo(promo_code, r.fare);
  if not verdict.valid then
    raise exception '%', verdict.reason;
  end if;

  insert into public.promo_redemptions (code, user_id, ride_id)
  values (upper(trim(promo_code)), auth.uid(), target_ride);

  update public.promo_codes
  set used_count = used_count + 1
  where code = upper(trim(promo_code));

  -- `protect_ride_columns` يُعيد `discount` لقيمته القديمة لأي تعديل
  -- يحمل هوية مستخدم، وهذه الدالة تحملها رغم أنها موثوقة — نرفع
  -- الراية لهذه المعاملة وحدها (المعامل الثالث `true` = محلية).
  perform set_config('app.trusted_write', 'on', true);

  update public.rides
  set discount = verdict.discount
  where id = target_ride;

  perform set_config('app.trusted_write', 'off', true);

  return verdict.discount;
end;
$$;

-- ═══════════════════════════════════════════════════════════════
-- 18) طرق الدفع المحفوظة
-- ═══════════════════════════════════════════════════════════════
-- شاشة المحفظة كانت تعرض بطاقة ثابتة في الكود (`•••• 4287`) لا وجود
-- لها في القاعدة. الجدول يجعلها بيانات حقيقية يملكها المستخدم.
--
-- ⚠️ لا تُخزَّن أرقام البطاقات هنا إطلاقاً — فقط رمز المزوّد (token)
-- وآخر أربعة أرقام، وهو ما يسمح بعرضه معيار PCI-DSS.

create table if not exists public.payment_methods (
  id             uuid primary key default uuid_generate_v4(),
  user_id        uuid not null references public.profiles(id) on delete cascade,
  kind           payment_method not null default 'card',
  label          text,
  last4          text check (last4 is null or last4 ~ '^[0-9]{4}$'),
  brand          text,
  provider_token text,
  is_default     boolean default false,
  created_at     timestamptz default now()
);

create index if not exists payment_methods_user_idx
  on public.payment_methods(user_id);

-- طريقة دفع افتراضية واحدة لكل مستخدم.
create unique index if not exists payment_methods_one_default_idx
  on public.payment_methods(user_id) where is_default = true;

alter table public.payment_methods enable row level security;

drop policy if exists "إدارة طرق دفعي" on public.payment_methods;
create policy "إدارة طرق دفعي" on public.payment_methods
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ═══════════════════════════════════════════════════════════════
-- 19) إنشاء الملف الشخصي من التطبيق (احتياط)
-- ═══════════════════════════════════════════════════════════════
-- `handle_new_user` يغطّي الحالة الطبيعية، لكن الحسابات التي أُنشئت
-- قبل تركيب المُشغِّل تبقى بلا صف في `profiles`، فتعرض شاشة الملف
-- الشخصي فراغاً دائماً. هذه السياسة تتيح للتطبيق إصلاح ذلك بنفسه.

drop policy if exists "إنشاء ملفي" on public.profiles;
create policy "إنشاء ملفي" on public.profiles
  for insert with check (auth.uid() = id);

-- ═══════════════════════════════════════════════════════════════
-- 20) ضبط صلاحيات تنفيذ الدوال
-- ═══════════════════════════════════════════════════════════════
-- PostgREST يكشف كل دالة في `public` على `/rest/v1/rpc/<name>`،
-- ودوال المُشغِّلات ليست استثناءً. مُدقِّق Supabase يرصدها كتحذير
-- (0028/0029): دالة `security definer` يستطيع أي زائر استدعاءها.
--
-- ‼️ الحذف يجب أن يستهدف `public` لا `anon, authenticated`.
-- Postgres يمنح EXECUTE إلى PUBLIC تلقائياً عند إنشاء أي دالة،
-- و PUBLIC يشمل الدورين معاً — فحذف المنحة منهما لا يغيّر شيئاً
-- لأنها موروثة (تظهر في `proacl` بالصيغة `=X/postgres`).
-- للتحقّق:
--   select proname, proacl from pg_proc p
--   join pg_namespace n on n.oid = p.pronamespace
--   where n.nspname = 'public';

revoke all on function public.handle_new_user()        from public;
revoke all on function public.assign_nearest_driver()  from public;
revoke all on function public.refresh_driver_rating()  from public;
revoke all on function public.fill_rating_driver()     from public;
revoke all on function public.protect_ride_columns()   from public;
revoke all on function public.stamp_ride_lifecycle()   from public;
revoke all on function public.settle_completed_ride()  from public;

-- الدوال التي يستدعيها التطبيق فعلاً: للمستخدم المسجَّل وحده.
-- الزائر لا يملك رصيداً ولا رحلة ولا كوبوناً يخصّه.
revoke all on function public.my_wallet_balance()          from public;
revoke all on function public.preview_promo(text, integer) from public;
revoke all on function public.redeem_promo(text, uuid)     from public;
revoke all on function public.nearby_drivers(
  double precision, double precision, double precision, integer
) from public;

-- تبقى هذه الأربع مرصودة كتحذير 0029 (يستطيع المسجَّل استدعاءها)،
-- وهو المقصود: كلٌّ منها `security definer` عمداً لتقرأ ما لا تصله
-- سياسات RLS، وكلٌّ منها تحصر نتيجتها في `auth.uid()` داخلياً.
grant execute on function public.my_wallet_balance()          to authenticated;
grant execute on function public.preview_promo(text, integer) to authenticated;
grant execute on function public.redeem_promo(text, uuid)     to authenticated;
grant execute on function public.nearby_drivers(
  double precision, double precision, double precision, integer
) to authenticated;
