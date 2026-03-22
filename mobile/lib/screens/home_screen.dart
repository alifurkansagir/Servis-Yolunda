import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/api_service.dart';
import 'map_screen.dart';
import '../services/app_settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Vehicle? nextVehicle;
  bool isLoading = true;
  String selectedFactory = 'Sarcam A.Ş.';

  @override
  void initState() {
    super.initState();
    _loadNextService();
    AppSettings().onSettingsChanged = () {
      if (mounted) setState(() {});
    };
  }

  Future<void> _loadNextService() async {
    setState(() => isLoading = true);
    try {
      final vehicles = await ApiService.fetchVehicles(factoryCode: selectedFactory);
      if (vehicles.isNotEmpty) {
        setState(() {
          nextVehicle = vehicles.first; // Mocking "next" as the first one found
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildGreeting(),
                   const SizedBox(height: 25),
                   _buildMainStatusCard(),
                   const SizedBox(height: 25),
                   _buildQuickActions(),
                   const SizedBox(height: 25),
                   _buildRecentNotifications(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Servis Yolunda',
        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.black87),
          onPressed: () => Navigator.pushNamed(context, '/settings'),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
          onPressed: () {},
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/profile'),
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merhaba Alperen,',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const Text(
          'Güne Hazır Mısın?',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildMainStatusCard() {
    if (isLoading) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent[700]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (AppSettings().isAlarmEnabled && nextVehicle != null && nextVehicle!.distanceKm <= AppSettings().alarmDistance)
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.redAccent.withAlpha(50), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white30)),
              child: const Row(
                children: [
                  Icon(Icons.notification_important, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('ALARM: Servis Durağınıza Yaklaştı!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SIRADAKİ SERVİS',
                style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                child: const Text('CANLI', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Text(
                nextVehicle != null ? '${nextVehicle!.etaMin} Dakika' : '--',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            nextVehicle != null ? '${nextVehicle!.plate} plakalı servis ${nextVehicle!.distanceKm} km mesafede.' : 'Servis bulunamadı',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Divider(color: Colors.white24, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fabrikanız: Sarcam A.Ş.', style: TextStyle(color: Colors.white70)),
              Text(selectedFactory, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hızlı İşlemler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildActionItem(Icons.map_rounded, 'Canlı Takip', Colors.orange, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
            }),
            const SizedBox(width: 15),
            _buildActionItem(Icons.route_rounded, 'Duraklar', Colors.green, () {
              Navigator.pushNamed(context, '/stops');
            }),
            const SizedBox(width: 15),
            _buildActionItem(Icons.qr_code_scanner_rounded, 'QR Biniş', Colors.blue, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Okuyucu Açılıyor... (Puantaj İşleniyor)')),
              );
            }),
            const SizedBox(width: 15),
            _buildActionItem(Icons.support_agent_rounded, 'Destek', Colors.purple, () {
              Navigator.pushNamed(context, '/chat');
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentNotifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Bildirimler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('Tümünü Gör')),
          ],
        ),
        _buildNotificationItem('Hava Durumu', 'Kocaeli 12°C - Sağanak Yağışlı. Şemsiyenizi yanınıza alın.', Icons.cloud_outlined, Colors.blue),
        _buildNotificationItem('Yol Durumu', 'D-100 Karayolu Yahya Kaptan mevkiinde kaza nedeniyle trafik yoğun.', Icons.warning_amber_rounded, Colors.amber),
        _buildNotificationItem('Fabrika Duyurusu', 'Yarın fabrikadaki bakım çalışması nedeniyle servisler 15 dk erken kalkacaktır.', Icons.info_outline, Colors.purple),
      ],
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
