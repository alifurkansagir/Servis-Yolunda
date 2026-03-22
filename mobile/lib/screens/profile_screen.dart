import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Profilim', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildInfoSection(context),
            const SizedBox(height: 20),
            _buildBoardingHistory(),
            const SizedBox(height: 20),
            _buildAdminAccess(context),
            const SizedBox(height: 30),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          'Alperen Demir',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          'İşçi No: 410293',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildInfoItem(Icons.factory_rounded, 'Çalıştığı Fabrika', 'Sarcam A.Ş.'),
          const Divider(height: 30),
          _buildInfoItem(Icons.local_shipping_rounded, 'Servis Firması', 'Sarcam Özmal Filo'),
          const Divider(height: 30),
          _buildInfoItem(Icons.route_rounded, 'Servis Hattı', 'H-12 Izmit/Merkez'),
          const Divider(height: 30),
          _buildInfoItem(Icons.location_on_rounded, 'Kayıtlı Durak', 'Sanayi Sitesi Girişi'),
        ],
      ),
    );
  }

  Widget _buildBoardingHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history_rounded, color: Colors.blueAccent, size: 20),
              SizedBox(width: 10),
              Text('Biniş Geçmişi (Puantaj)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 15),
          _buildHistoryItem('Bugün', '07:42', '41 AS 123', true),
          _buildHistoryItem('Dün', '17:10', '41 AS 123', true),
          _buildHistoryItem('Dün', '07:45', '41 AS 123', true),
          _buildHistoryItem('18 Mart', '07:38', '41 AS 999', true),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String date, String time, String plate, bool verified) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(plate, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: Colors.green, size: 12),
                  SizedBox(width: 4),
                  Text('Doğrulandı', style: TextStyle(color: Colors.green, fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.blue[800], size: 20),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded),
            SizedBox(width: 10),
            Text('Oturumu Kapat', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget _buildAdminAccess(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/admin'),
        icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.blueAccent),
        label: const Text('Yönetici Paneline Geç', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(color: Colors.blueAccent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
