// ═══════════════════════════════════════════════════════════════
// generate_icon.dart - يولّد أيقونة التطبيق (PNG)
// ═══════════════════════════════════════════════════════════════
// التشغيل:  dart run tool/generate_icon.dart
// ثم:       dart run flutter_launcher_icons
//
// نرسم الأيقونة برمجياً بدل حفظ PNG جاهز، حتى يبقى المصدر قابلاً
// للتعديل ومراجعته في Git (الصور الثنائية لا يظهر فرقها).
// ═══════════════════════════════════════════════════════════════
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart';

// ألوان مطابقة لـ MishwarakColors
const _primaryLight = (r: 0x00, g: 0xC8, b: 0x53);
const _primaryDark = (r: 0x00, g: 0x7A, b: 0x3C);
const _accent = (r: 0xFF, g: 0xC3, b: 0x00);

const _size = 1024;

void main() {
  final img = Image(width: _size, height: _size, numChannels: 4);

  _paintGradient(img);
  _paintRoute(img);
  _paintPickupDot(img);
  _paintDestinationPin(img);

  final out = File('assets/icon/icon.png');
  out.parent.createSync(recursive: true);
  out.writeAsBytesSync(encodePng(img));

  // نسخة مربّعة للويب/الأيقونة التكيّفية على أندرويد
  stdout.writeln('✓ ${out.path} (${_size}×$_size)');
}

/// خلفية متدرّجة قطرياً من الأخضر الفاتح إلى الغامق.
void _paintGradient(Image img) {
  for (var y = 0; y < _size; y++) {
    for (var x = 0; x < _size; x++) {
      // القطر يعطي عمقاً أوضح من التدرّج الرأسي عند الأحجام الصغيرة.
      final t = (x + y) / (2 * _size);
      img.setPixelRgba(
        x,
        y,
        _lerp(_primaryLight.r, _primaryDark.r, t),
        _lerp(_primaryLight.g, _primaryDark.g, t),
        _lerp(_primaryLight.b, _primaryDark.b, t),
        255,
      );
    }
  }
}

/// مسار منقّط من نقطة الانطلاق إلى الوجهة — يوحي بالرحلة.
void _paintRoute(Image img) {
  const start = (x: 300.0, y: 720.0);
  const end = (x: 724.0, y: 330.0);
  const control = (x: 300.0, y: 400.0); // ينحني يساراً ثم يصعد

  const dots = 9;
  for (var i = 1; i < dots; i++) {
    final t = i / dots;
    // منحنى بيزييه تربيعي
    final mt = 1 - t;
    final x = mt * mt * start.x + 2 * mt * t * control.x + t * t * end.x;
    final y = mt * mt * start.y + 2 * mt * t * control.y + t * t * end.y;

    fillCircle(
      img,
      x: x.round(),
      y: y.round(),
      radius: 20,
      color: ColorRgba8(255, 255, 255, 235),
    );
  }
}

/// نقطة الانطلاق: حلقة بيضاء مصمتة.
void _paintPickupDot(Image img) {
  fillCircle(img, x: 300, y: 720, radius: 66, color: ColorRgba8(255, 255, 255, 255));
  fillCircle(
    img,
    x: 300,
    y: 720,
    radius: 28,
    color: ColorRgba8(_primaryDark.r, _primaryDark.g, _primaryDark.b, 255),
  );
}

/// الوجهة: دبّوس ذهبي (دائرة + مثلث سفلي) مع ثقب أبيض.
void _paintDestinationPin(Image img) {
  const cx = 724;
  const cy = 310;
  const r = 104;
  final gold = ColorRgba8(_accent.r, _accent.g, _accent.b, 255);

  fillCircle(img, x: cx, y: cy, radius: r, color: gold);

  // طرف الدبّوس: مثلث يضيق نحو الأسفل
  const tipY = 486;
  for (var y = cy; y <= tipY; y++) {
    final t = (y - cy) / (tipY - cy);
    // نصف العرض يتناقص كجيب التمام ليتصل بالدائرة بنعومة
    final halfWidth = (r * math.cos(t * math.pi / 2)).round();
    for (var x = cx - halfWidth; x <= cx + halfWidth; x++) {
      if (x >= 0 && x < _size && y >= 0 && y < _size) {
        img.setPixelRgba(x, y, _accent.r, _accent.g, _accent.b, 255);
      }
    }
  }

  fillCircle(img, x: cx, y: cy, radius: 42, color: ColorRgba8(255, 255, 255, 255));
}

int _lerp(int a, int b, double t) => (a + (b - a) * t).round().clamp(0, 255);
