-- ═══════════════════════════════════════════════════════════════
-- مِشوارَك · بيانات أولية
-- ═══════════════════════════════════════════════════════════════
-- شغّله بعد schema.sql. آمن للتكرار (upsert).
-- ═══════════════════════════════════════════════════════════════

-- ─────────── أنواع المركبات ───────────
-- الأسعار بالريال اليمني، مطابقة لـ VehicleTypesRepository في التطبيق.
insert into public.vehicle_types
  (id, category, name_ar, name_en, description_ar, description_en,
   seats, base_price, price_per_km, eta_minutes, badge_ar, badge_en, sort_order)
values
  ('eco',     'economy', 'اقتصادي',       'Economy',    '4 ركاب',      '4 seats',
   4, 2500, 120, 3, null, null, 1),
  ('comfort', 'comfort', 'مريح',          'Comfort',    'سيارة أحدث',  'Newer car',
   4, 3800, 180, 5, null, null, 2),
  ('xl',      'xl',      'عائلي XL',      'XL',         '6 ركاب',      '6 seats',
   6, 5200, 240, 7, null, null, 3),
  ('women',   'women',   'سائقة للنساء',  'Women only', 'سائقة خبيرة', 'Female driver',
   4, 3200, 160, 9, 'حصري', 'Exclusive', 4)
on conflict (id) do update set
  name_ar        = excluded.name_ar,
  name_en        = excluded.name_en,
  description_ar = excluded.description_ar,
  description_en = excluded.description_en,
  seats          = excluded.seats,
  base_price     = excluded.base_price,
  price_per_km   = excluded.price_per_km,
  eta_minutes    = excluded.eta_minutes,
  badge_ar       = excluded.badge_ar,
  badge_en       = excluded.badge_en,
  sort_order     = excluded.sort_order;

-- ─────────── كوبونات تجريبية ───────────
insert into public.promo_codes
  (code, description_ar, description_en, discount_percent, discount_amount,
   max_discount, valid_until, usage_limit)
values
  ('MISHWAR30', 'خصم 30% على رحلتك القادمة', '30% off your next ride',
   30, null, 1500, now() + interval '30 days', 1000),
  ('WELCOME',   'خصم 1000 ريال لأول رحلة',   'YER 1,000 off your first ride',
   null, 1000, 1000, now() + interval '90 days', 5000)
on conflict (code) do update set
  description_ar   = excluded.description_ar,
  description_en   = excluded.description_en,
  discount_percent = excluded.discount_percent,
  discount_amount  = excluded.discount_amount,
  max_discount     = excluded.max_discount,
  valid_until      = excluded.valid_until,
  usage_limit      = excluded.usage_limit;

-- ─────────── سائقون تجريبيون (عدن) ───────────
-- احذف هذا القسم قبل الإنتاج.
insert into public.drivers
  (full_name, phone, rating, completed_trips, car_model, car_color,
   plate_number, vehicle_type_id, is_female, is_online, current_lat, current_lng)
values
  ('محمد صالح',  '+967771234567', 4.92, 1247, 'تويوتا هايلوكس', 'أبيض',
   'ADN 4287', 'comfort', false, true, 12.7794, 45.0367),
  ('علي ناصر',   '+967772345678', 4.85,  892, 'هيونداي أكسنت',  'فضي',
   'ADN 1043', 'eco',     false, true, 12.7850, 45.0290),
  ('سمية أحمد',  '+967773456789', 4.97,  654, 'كيا سيراتو',     'أزرق',
   'ADN 7712', 'women',   true,  true, 12.7720, 45.0410),
  -- بدون سائق من فئة XL يبقى طلب "عائلي XL" بلا مطابقة إلى الأبد،
  -- فتصل الشاشة لمهلة "لا يوجد سائق" في كل مرة.
  ('فهد عبدالله', '+967774567890', 4.78,  431, 'تويوتا هايس',    'أبيض',
   'ADN 5530', 'xl',      false, true, 12.7880, 45.0455)
on conflict (plate_number) do nothing;
