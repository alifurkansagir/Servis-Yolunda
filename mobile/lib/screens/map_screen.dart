import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/vehicle.dart';
import '../services/api_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  List<Vehicle> vehicles = [];
  Map<String, Vehicle> previousVehicles = {};
  Map<String, AnimationController> controllers = {};
  Map<String, Animation<LatLng>> animations = {};
  
  String selectedFactory = 'FAC100';
  Timer? pollTimer;
  Vehicle? selectedVehicle;
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    pollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    pollTimer?.cancel();
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ApiService.fetchVehicles(factoryCode: selectedFactory);
      _updateVehicles(data);
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  void _updateVehicles(List<Vehicle> newVehicles) {
    Map<String, Vehicle> newPrevious = {};
    for (var v in vehicles) {
       newPrevious[v.nodeId] = v;
    }
    previousVehicles = newPrevious;

    for (var nv in newVehicles) {
      final pv = previousVehicles[nv.nodeId];
      if (pv != null && (pv.latitude != nv.latitude || pv.longitude != nv.longitude)) {
        if (!controllers.containsKey(nv.nodeId)) {
          controllers[nv.nodeId] = AnimationController(
            vsync: this, 
            duration: const Duration(seconds: 2) 
          );
        }
        
        var controller = controllers[nv.nodeId]!;
        animations[nv.nodeId] = LatLngTween(
          begin: LatLng(pv.latitude, pv.longitude),
          end: LatLng(nv.latitude, nv.longitude),
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
        
        controller.forward(from: 0.0);
      }
      
      // Update selected vehicle if it's the one we got new data for
      if (selectedVehicle?.nodeId == nv.nodeId) {
        setState(() {
          selectedVehicle = nv;
        });
      }
    }

    if (mounted) {
      setState(() {
        vehicles = newVehicles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(40.7654, 29.9408),
              initialZoom: 12.0,
              onTap: (_, __) => setState(() => selectedVehicle = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.sartech.servisyolunda',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: const [
                      LatLng(40.7600, 29.9200),
                      LatLng(40.7650, 29.9300),
                      LatLng(40.7666, 29.9167),
                      LatLng(40.7700, 29.9500),
                      LatLng(40.7654, 29.9408),
                    ],
                    color: Colors.blueAccent.withAlpha(100),
                    strokeWidth: 5.0,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Worker's Stop
                  const Marker(
                    point: LatLng(40.7666, 29.9167),
                    width: 60,
                    height: 60,
                    child: Column(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 30),
                        Text('Durağım', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.white)),
                      ],
                    ),
                  ),
                  // Vehicles
                  ...vehicles.map((v) {
                    final isSelected = selectedVehicle?.nodeId == v.nodeId;
                    return Marker(
                      width: isSelected ? 100.0 : 80.0,
                      height: isSelected ? 100.0 : 80.0,
                      point: _getMarkerPosition(v),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedVehicle = v),
                        child: AnimatedBuilder(
                          animation: controllers[v.nodeId] ?? const AlwaysStoppedAnimation(0),
                          builder: (context, child) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Transform.scale(
                                  scale: isSelected ? 1.2 : 1.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.blueAccent[700] : Colors.white.withAlpha(230),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]
                                    ),
                                    child: Text(
                                      v.plate,
                                      style: TextStyle(
                                        fontSize: 10, 
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : Colors.black87
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Icon(
                                  Icons.directions_bus_rounded,
                                  color: isSelected ? Colors.orangeAccent : (v.ignition ? Colors.blue[800] : Colors.grey[700]),
                                  size: isSelected ? 40.0 : 32.0,
                                ),
                              ],
                            );
                          }
                        ),
                      )
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          
          // Custom Glassmorphism Header
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.blueAccent[700]!.withAlpha(200),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Servis Yolunda',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFactory,
                        dropdownColor: Colors.blueAccent[700],
                        icon: const Icon(Icons.filter_list, color: Colors.white),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        items: ['FAC100', 'FAC200', 'FAC300'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedFactory = newValue;
                              vehicles.clear();
                              previousVehicles.clear();
                              selectedVehicle = null;
                            });
                            _fetchData();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Vehicle Detail Card
          if (selectedVehicle != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.directions_bus, color: Colors.blue[800], size: 30),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(selectedVehicle!.plate, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text('Tahmini Varış: ${selectedVehicle!.etaMin} dk', style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => selectedVehicle = null),
                        )
                      ],
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailItem(Icons.speed, '${selectedVehicle!.speed} km/s', 'Hız'),
                        _buildDetailItem(Icons.location_on_outlined, '${selectedVehicle!.distanceKm} km', 'Mesafe'),
                        _buildDetailItem(Icons.timer_outlined, '${selectedVehicle!.etaMin} dk', 'Varış'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: selectedVehicle == null ? FloatingActionButton(
        backgroundColor: Colors.blueAccent[700],
        onPressed: () {
          mapController.move(const LatLng(40.7654, 29.9408), 12.0);
        },
        child: const Icon(Icons.my_location, color: Colors.white),
      ) : null,
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent[700], size: 24),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }


  LatLng _getMarkerPosition(Vehicle v) {
    if (animations.containsKey(v.nodeId) && controllers.containsKey(v.nodeId)) {
      return animations[v.nodeId]!.value;
    }
    return LatLng(v.latitude, v.longitude);
  }
}

class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end}) : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    return LatLng(
      begin!.latitude + (end!.latitude - begin!.latitude) * t,
      begin!.longitude + (end!.longitude - begin!.longitude) * t,
    );
  }
}
