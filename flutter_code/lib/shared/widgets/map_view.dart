// ═══════════════════════════════════════════════════════════════
// map_view.dart - خريطة Google مع بديل آمن
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/config/app_config.dart';
import 'map_placeholder.dart';

/// إحداثيات مركز عدن — نقطة البداية الافتراضية.
const kAdenCenter = LatLng(12.7794, 45.0367);

/// خريطة التطبيق.
///
/// تعرض خريطة Google حقيقية عند توفّر مفتاح API ودعم المنصّة،
/// وإلا تعرض [MapPlaceholder] حتى يبقى التطبيق قابلاً للتشغيل.
class MapView extends StatefulWidget {
  /// أيقونة البديل عند غياب الخريطة.
  final IconData placeholderIcon;

  /// مركز الكاميرا.
  final LatLng center;

  final double zoom;

  /// مساحة سفلية لا تغطيها عناصر التحكم (ارتفاع الـ bottom sheet).
  final double bottomPadding;

  final Set<Marker> markers;
  final Set<Polyline> polylines;

  /// يُستدعى عند جهوزية الخريطة — لتحريك الكاميرا لاحقاً.
  final void Function(GoogleMapController)? onMapCreated;

  const MapView({
    super.key,
    this.placeholderIcon = Icons.map_outlined,
    this.center = kAdenCenter,
    this.zoom = 13,
    this.bottomPadding = 0,
    this.markers = const {},
    this.polylines = const {},
    this.onMapCreated,
  });

  /// هل تدعم المنصّة الحالية خرائط Google؟
  ///
  /// الحزمة تدعم أندرويد و iOS والويب فقط — لا Windows/Linux/macOS.
  static bool get isPlatformSupported {
    if (kIsWeb) return true;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// هل ستُعرض خريطة حقيقية؟
  static bool get isAvailable => AppConfig.hasMapsKey && isPlatformSupported;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _controller;

  @override
  void didUpdateWidget(MapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // `initialCameraPosition` تُقرأ مرة واحدة فقط، فبدون هذا لا تتحرّك
    // الكاميرا خلف السائق أثناء الرحلة.
    if (widget.center != oldWidget.center) {
      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(widget.center, widget.zoom),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!MapView.isAvailable) {
      return MapPlaceholder(icon: widget.placeholderIcon);
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.center,
        zoom: widget.zoom,
      ),
      onMapCreated: (c) {
        _controller = c;
        widget.onMapCreated?.call(c);
      },
      markers: widget.markers,
      polylines: widget.polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
    );
  }
}
