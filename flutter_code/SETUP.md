# إعداد مِشوارَك

التطبيق يعمل **بدون أي مفاتيح** ببيانات وهمية. اتبع هذا الدليل لربط الخدمات الحقيقية.

---

## 1) Supabase

### أ. تجهيز قاعدة البيانات

في لوحة Supabase → **SQL Editor** → **New query**:

1. الصق محتوى [`supabase/schema.sql`](supabase/schema.sql) كاملاً ثم **Run**
   (الجداول + RLS + المحفّزات + Realtime + الصلاحيات)
2. الصق محتوى [`supabase/seed.sql`](supabase/seed.sql) ثم **Run**
   (أنواع المركبات + كوبونات + سائقون تجريبيون)

للتحقق: **Table Editor** يجب أن تظهر 12 جدولاً، و `vehicle_types` فيه 4 صفوف.

> ⚠️ **الخطوة 2 ليست اختيارية.**
> عمود `rides.vehicle_type_id` مرتبط بمفتاح أجنبي إلى `vehicle_types`.
> إن بقي الجدول فارغاً، يرفض الخادم كل طلب رحلة برسالة انتهاك مفتاح
> أجنبي — ولا يظهر للراكب إلا "تعذّر الطلب" بلا سبب واضح.
> وبلا صفوف في `drivers` لن يجد المُوزِّع سائقاً أبداً، فتبقى شاشة
> البحث تدور حتى تنتهي المهلة.

### ب. ربط التطبيق

من **Project Settings → API** انسخ:

| الحقل في Supabase | ضعه في `env.json` |
|---|---|
| Project URL | `SUPABASE_URL` |
| `anon` `public` | `SUPABASE_ANON_KEY` |

```jsonc
// env.json  (مُستثنى من Git — لا يُرفع)
{
  "SUPABASE_URL": "https://abcdefgh.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "GOOGLE_MAPS_API_KEY": ""
}
```

> ⚠️ **لا تستخدم `service_role` أبداً في التطبيق.** هو يتجاوز كل سياسات RLS،
> ومن يحصل عليه يقرأ ويعدّل بيانات كل المستخدمين. مكانه الخادم فقط.

مفتاح `anon` آمن للتطبيق — الحماية الفعلية تأتي من سياسات RLS في `schema.sql`.

### ج. تفعيل تسجيل الدخول بالهاتف

**Authentication → Providers → Phone** → فعّله واربط مزوّد SMS
(Twilio أو MessageBird). بدونه لن يصل رمز التحقق.

---

## 2) Google Maps

### الحصول على المفتاح

1. [Google Cloud Console](https://console.cloud.google.com) → أنشئ مشروعاً
2. فعّل الفوترة (مطلوبة حتى مع الحصة المجانية)
3. **APIs & Services → Library** → فعّل:
   - **Maps JavaScript API** (للويب)
   - **Maps SDK for Android** / **Maps SDK for iOS** (عند إضافة المنصّتين)
   - **Places API** و **Directions API** (للبحث ورسم المسار)
4. **Credentials → Create credentials → API key**
5. **قيّد المفتاح فوراً**: HTTP referrers لنطاقك، وحدّد الـ APIs المسموحة

### تفعيله على الويب

في [`web/index.html`](web/index.html) أزل التعليق عن وسم `<script>` وضع مفتاحك،
ثم ضع نفس المفتاح في `env.json` تحت `GOOGLE_MAPS_API_KEY`.

كلاهما مطلوب: الوسم يحمّل مكتبة الخرائط، و`env.json` يخبر التطبيق أن يعرضها
بدل الخريطة البديلة.

### أندرويد و iOS

المنصّتان مُنشأتان ومهيّأتان بالأذونات ونصوص طلب الموقع بالعربية.
لا تكتب المفتاح في أي ملف داخل `android/app/src/main/` أو
`ios/Runner/` — كلاهما متتبَّع في Git. المكان الصحيح:

**أندرويد** — أضف السطر إلى `android/local.properties` (مُستثنى من Git):

```properties
MAPS_API_KEY=AIza...
```

يقرأه `app/build.gradle.kts` ويحقنه في `AndroidManifest.xml` عبر
`manifestPlaceholders` وقت البناء.

**iOS** — انسخ ملف المثال ثم ضع مفتاحك فيه:

```bash
cp ios/Flutter/Secrets.xcconfig.example ios/Flutter/Secrets.xcconfig
```

يقرأه `Info.plist` عبر `$(MAPS_API_KEY)`، ويأخذه `AppDelegate` من
الحزمة عند الإقلاع. النسخة الحقيقية مُستثناة من Git.

> البناء ينجح بلا مفتاح على المنصّتين — تظهر الخريطة البديلة بدل أن
> يفشل البناء على جهاز لم يُعدّ بعد.

**قيود المفتاح** (مهمة — المفتاح غير المقيَّد يُستنزف من أي جهة):

| المنصّة | نوع التقييد | القيمة |
|---|---|---|
| أندرويد | Android apps | `com.mishwarak.mishwarak` + بصمة SHA-1 |
| iOS | iOS apps | `com.mishwarak.mishwarak` |
| الويب | HTTP referrers | نطاق موقعك |

استخدم **مفتاحاً منفصلاً لكل منصّة**؛ لا يمكن تقييد مفتاح واحد
بثلاثة أنواع في آن.

---

## 3) التشغيل

```bash
flutter run -d chrome --dart-define-from-file=env.json
```

عند الإقلاع يطبع التطبيق حالته:

```
[مِشوارَك] Supabase: متصل · Maps: مفعّلة
```

- `Supabase: وهمي` → المفاتيح فارغة أو الاتصال فشل
- `Maps: بديلة` → لا مفتاح خرائط، أو المنصّة غير مدعومة (Windows)

## ملاحظات

- **Windows desktop لا يدعم خرائط Google** — استخدم Chrome أو أندرويد/iOS.
- **البحث الجغرافي** (تحويل نص الوجهة إلى إحداثيات) يعمل على أندرويد
  و iOS فقط. على الويب تُستخدم العناوين المحفوظة والأخيرة، وتُعرض
  الأجرة كتقدير حين لا تتوفّر إحداثيات الوجهة.
