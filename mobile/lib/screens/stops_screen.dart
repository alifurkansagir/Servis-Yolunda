import 'package:flutter/material.dart';

class StopsScreen extends StatelessWidget {
  const StopsScreen({super.key});

  final List<Map<String, String>> stops = const [
    {'name': 'Merkez Durak (Kalkış)', 'time': '07:00', 'status': 'passed'},
    {'name': 'Yahya Kaptan Kavşağı', 'time': '07:15', 'status': 'passed'},
    {'name': 'Sanayi Sitesi Girişi', 'time': '07:30', 'status': 'next'},
    {'name': 'Symbol AVM Önü', 'time': '07:45', 'status': 'upcoming'},
    {'name': 'Sarcam Fabrika Varış', 'time': '08:00', 'status': 'upcoming'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Güzergah Durakları', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            _buildRouteInfo(),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stops.length,
              itemBuilder: (context, index) {
                return _buildStopItem(
                  stops[index]['name']!,
                  stops[index]['time']!,
                  stops[index]['status']!,
                  index == 0,
                  index == stops.length - 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('H-12 Izmit/Merkez Hattı', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('Toplam 5 Durak • 12.4 km', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Sıradaki durak: Sanayi Sitesi Girişi. Servis yaklaşık 8 dk sonra burada olacak.',
                    style: TextStyle(color: Colors.blue[800], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopItem(String name, String time, String status, bool isFirst, bool isLast) {
    Color color;
    IconData icon;
    bool isNext = status == 'next';

    switch (status) {
      case 'passed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'next':
        color = Colors.blueAccent;
        icon = Icons.radio_button_checked;
        break;
      default:
        color = Colors.grey[400]!;
        icon = Icons.radio_button_off;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 2,
                  height: 20,
                  color: isFirst ? Colors.transparent : Colors.grey[300],
                ),
                Icon(icon, color: color, size: 24),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : Colors.grey[300],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isNext ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: isNext ? Border.all(color: Colors.blueAccent.withAlpha(50)) : null,
                  boxShadow: isNext ? [BoxShadow(color: Colors.blueAccent.withAlpha(10), blurRadius: 10)] : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                            color: status == 'upcoming' ? Colors.grey[500] : Colors.black87,
                          ),
                        ),
                        if (isNext)
                          const Text('Sizin Durağınız', style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isNext ? Colors.blueAccent : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
