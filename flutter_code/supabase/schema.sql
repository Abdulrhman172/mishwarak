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
create or replace view public.wallet_balances as
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
-- الراكب يرى السائقين المتاحين، أو سائق رحلته
drop policy if exists "قراءة السائقين المتاحين" on public.drivers;
create policy "قراءة السائقين المتاحين" on public.drivers
  for select using (
    is_online = true
    or exists (
      select 1 from public.rides r
      where r.driver_id = drivers.id and r.passenger_id = auth.uid()
    )
  );

-- ─────────── rides ───────────
drop policy if exists "قراءة رحلاتي" on public.rides;
create policy "قراءة رحلاتي" on public.rides
  for select using (auth.uid() = passenger_id);

drop policy if exists "إنشاء رحلة" on public.rides;
create policy "إنشاء رحلة" on public.rides
  for insert with check (auth.uid() = passenger_id);

-- التعديل مسموح فقط ما دامت الرحلة لم تُغلق (مثلاً الإلغاء)
drop policy if exists "تعديل رحلتي الجارية" on public.rides;
create policy "تعديل رحلتي الجارية" on public.rides
  for update using (
    auth.uid() = passenger_id
    and status not in ('completed', 'cancelled')
  );

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
