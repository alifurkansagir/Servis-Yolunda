import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/vehicle.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Merhaba Alperen! Ben Servis Yolunda Asistanı. Sana nasıl yardımcı olabilirim?',
      'isMe': false,
    }
  ];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  void _handleSend() async {
    final text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isMe': true});
      _isTyping = true;
    });
    _controller.clear();

    // AI logic (simulated with keyword detection)
    String response = 'Şu an ne dediğini tam anlayamadım ama servisini senin için kontrol edebilirim. "Servis nerede" diye sormayı deneyebilirsin.';
    
    if (text.toLowerCase().contains('nerede') || text.toLowerCase().contains('kaç') || text.toLowerCase().contains('ne zaman')) {
      try {
        final vehicles = await ApiService.fetchVehicles(factoryCode: 'FAC100');
        if (vehicles.isNotEmpty) {
          final v = vehicles.first;
          response = 'Servis aracın (${v.plate}) şu an duraktan ${v.distanceKm} km mesafede. Tahminen ${v.etaMin} dakika içinde senin durakta olacak. 🚌';
        } else {
          response = 'Sisteme bağlı aktif servis bulamadım. İlgili birimle iletişime geçiyorum.';
        }
      } catch (e) {
        response = 'Veri çekerken bir sorun oluştu, lütfen biraz sonra tekrar sor.';
      }
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({'text': response, 'isMe': false});
          _isTyping = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Akıllı Asistan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text('Çevrimiçi', style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return _buildMessageBubble(m['text'], m['isMe']);
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Asistan yazıyor...', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent[700] : Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Mesajınızı yazın...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.blueAccent[700],
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _handleSend,
            ),
          ),
        ],
      ),
    );
  }
}
