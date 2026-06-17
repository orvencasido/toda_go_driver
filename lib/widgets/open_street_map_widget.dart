import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:toda_go_driver/core/widgets/tricycle_painter.dart';

class OpenStreetMapWidget extends StatefulWidget {
  final LatLng? pickupLocation;
  final LatLng? dropoffLocation;
  final LatLng? driverLocation;
  final List<LatLng>? routePoints;
  final MapController? mapController;
  final LatLng initialCenter;
  final double initialZoom;
  final bool showRoute;
  final bool interactive;

  const OpenStreetMapWidget({
    super.key,
    this.pickupLocation,
    this.dropoffLocation,
    this.driverLocation,
    this.routePoints,
    this.mapController,
    this.initialCenter = const LatLng(14.0256, 121.5831), // Tayabas City
    this.initialZoom = 14.0,
    this.showRoute = false,
    this.interactive = true,
  });

  @override
  State<OpenStreetMapWidget> createState() => _OpenStreetMapWidgetState();
}

class _OpenStreetMapWidgetState extends State<OpenStreetMapWidget> {
  late final MapController _mapController;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController ?? MapController();
  }

  @override
  void didUpdateWidget(covariant OpenStreetMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isMapReady &&
        (widget.pickupLocation != oldWidget.pickupLocation ||
            widget.dropoffLocation != oldWidget.dropoffLocation ||
            widget.driverLocation != oldWidget.driverLocation)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitMapBounds();
      });
    }
  }

  void _fitMapBounds() {
    if (!_isMapReady) return;

    if (widget.pickupLocation != null && widget.dropoffLocation != null) {
      final bounds = LatLngBounds.fromPoints([
        widget.pickupLocation!,
        widget.dropoffLocation!,
      ]);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(60.0),
        ),
      );
    } else if (widget.driverLocation != null) {
      _mapController.move(widget.driverLocation!, widget.initialZoom);
    } else if (widget.pickupLocation != null) {
      _mapController.move(widget.pickupLocation!, widget.initialZoom);
    } else if (widget.dropoffLocation != null) {
      _mapController.move(widget.dropoffLocation!, widget.initialZoom);
    }
  }

  Widget _buildPickupMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Color(0xFF22C55E),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildDropoffMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE53935).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
        const Icon(
          Icons.location_on_rounded,
          color: Color(0xFFE53935),
          size: 38,
        ),
        Positioned(
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF2563EB), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: const Center(
            child: TricycleLogo(
              size: 20,
              color: Color(0xFF2563EB),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate markers list dynamically
    final markers = <Marker>[];

    if (widget.pickupLocation != null) {
      markers.add(
        Marker(
          point: widget.pickupLocation!,
          width: 40,
          height: 40,
          child: _buildPickupMarker(),
        ),
      );
    }

    if (widget.dropoffLocation != null) {
      markers.add(
        Marker(
          point: widget.dropoffLocation!,
          width: 40,
          height: 40,
          child: _buildDropoffMarker(),
        ),
      );
    }

    if (widget.driverLocation != null) {
      markers.add(
        Marker(
          point: widget.driverLocation!,
          width: 50,
          height: 50,
          child: _buildDriverMarker(),
        ),
      );
    }

    // Polyline generation
    final polylines = <Polyline>[];
    if (widget.showRoute) {
      if (widget.routePoints != null && widget.routePoints!.isNotEmpty) {
        polylines.add(
          Polyline(
            points: widget.routePoints!,
            color: const Color(0xFF2563EB),
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
            borderColor: const Color(0xFF1D4ED8),
            borderStrokeWidth: 1,
          ),
        );
      } else if (widget.pickupLocation != null && widget.dropoffLocation != null) {
        // Fallback straight or simplified road route path if no points are given
        polylines.add(
          Polyline(
            points: [widget.pickupLocation!, widget.dropoffLocation!],
            color: const Color(0xFF2563EB),
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
          ),
        );
      }
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
        interactionOptions: InteractionOptions(
          flags: widget.interactive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
        onMapReady: () {
          setState(() {
            _isMapReady = true;
          });
          _fitMapBounds();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.todago.driver',
        ),
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        if (markers.isNotEmpty) MarkerLayer(markers: markers),
      ],
    );
  }
}
