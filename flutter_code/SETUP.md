# إعداد مِشوارَك

التطبيق يعمل **بدون أي مفاتيح** ببيانات وهمية. اتبع هذا الدليل لربط الخدمات الحقيقية.

---

## 1) Supabase

### أ. تجهيز قاعدة البيانات

في لوحة Supabase → **SQL Editor** → **New query**:

1. الصق محتوى [`supabase/schema.sql`](supabase/schema.sql) كاملاً ثم **Run**
   (الجداول + RLS + المحفّزات + Realtime)
2. الصق محتوى [`supabase/seed.sql`](supabase/seed.sql) ثم **Run**
   (أنواع المركبات + كوبون + سائقون تجريبيون)

للتحقق: **Table Editor** يجب أن تظهر 11 جدولاً، و `vehicle_types` فيه 4 صفوف.

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

### إضافة أندرويد / iOS

المنصّتان غير مُنشأتين بعد. لإضافتهما:

```bash
flutter create --platforms=android,ios .
```

ثم:
- **أندرويد** — في `android/app/src/main/AndroidManifest.xml` داخل `<application>`:
  ```xml
  <meta-data android:name="com.google.android.geo.API_KEY"
             android:value="مفتاحك"/>
  ```
- **iOS** — في `ios/Runner/AppDelegate.swift`:
  ```swift
  GMSServices.provideAPIKey("مفتاحك")
  ```

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
- ملفات `firebase.json` و `firestore.*` بقايا من إعداد سابق ولا يستخدمها
  التطبيق؛ يمكن حذفها.
