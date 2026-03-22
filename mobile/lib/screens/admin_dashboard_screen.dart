import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Sarcam Yönetici Paneli', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Sistem Özeti'),
              const SizedBox(height: 15),
              _buildStatGrid(),
              const SizedBox(height: 30),
              _buildSectionTitle('Canlı Sefer Durumu'),
              const SizedBox(height: 15),
              _buildLiveStatusList(),
              const SizedBox(height: 30),
              _buildSectionTitle('Sürdürülebilirlik & Verimlilik'),
              const SizedBox(height: 15),
              _buildEfficiencyStats(),
              const SizedBox(height: 30),
              _buildSectionTitle('Hızlı İşlemler'),
              const SizedBox(height: 15),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Toplam Araç', '12', Icons.local_shipping_rounded, Colors.blue),
        _buildStatCard('Aktif Sefer', '8', Icons.route_rounded, Colors.green),
        _buildStatCard('Geciken', '1', Icons.warning_amber_rounded, Colors.orange),
        _buildStatCard('Puantaj (Bugün)', '142', Icons.how_to_reg_rounded, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLiveStatusList() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildLiveStatusItem('H-12 Izmit/Merkez', '41 AS 123', 'Zamanında', Colors.green),
          const Divider(height: 20),
          _buildLiveStatusItem('H-05 Gebze/Çayırova', '34 BK 999', '3 dk Gecikme', Colors.orange),
          const Divider(height: 20),
          _buildLiveStatusItem('H-22 Sakarya/Adapazarı', '54 S 456', 'Zamanında', Colors.green),
        ],
      ),
    );
  }

  Widget _buildLiveStatusItem(String route, String plate, String status, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(route, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(plate, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: statusColor.withAlpha(30), borderRadius: BorderRadius.circular(8)),
          child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildEfficiencyStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green[700]!, Colors.green[400]!]),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEfficiencyItem(Icons.eco_rounded, 'Karbon Azaltımı', '240 kg CO2'),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildEfficiencyItem(Icons.local_gas_station_rounded, 'Yakıt Tasarrufu', '420 Litre'),
            ],
          ),
          const Divider(color: Colors.white24, height: 30),
          const Text(
            'Rota Optimizasyonu ile Personel Memnuniyeti %18 Artış Gösterdi',
            style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            Icons.campaign_rounded,
            'Duyuru Yayınla',
            Colors.blueAccent,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Duyuru tüm şoför ve personele iletildi.')),
              );
            },
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildActionButton(
            Icons.analytics_rounded,
            'PDF Rapor Al',
            Colors.purple,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aylık verimlilik raporu hazırlandı.')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
