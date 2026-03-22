import 'package:flutter/material.dart';
import '../services/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final settings = AppSettings();
  late bool _isAlarmEnabled;
  late double _alarmDistance;
  late bool _vibrateOnAlarm;
  late bool _soundOnAlarm;

  @override
  void initState() {
    super.initState();
    _isAlarmEnabled = settings.isAlarmEnabled;
    _alarmDistance = settings.alarmDistance;
    _vibrateOnAlarm = settings.vibrateOnAlarm;
    _soundOnAlarm = settings.soundOnAlarm;
  }

  void _update() {
     settings.updateSettings(
       isAlarmEnabled: _isAlarmEnabled,
       alarmDistance: _alarmDistance,
       vibrateOnAlarm: _vibrateOnAlarm,
       soundOnAlarm: _soundOnAlarm,
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Ayarlar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            _buildAlarmSection(),
            const SizedBox(height: 20),
            _buildGeneralSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.alarm, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text('Akıllı Mesafe Alarmı', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Switch.adaptive(
                value: _isAlarmEnabled,
                onChanged: (val) => setState(() {
                _isAlarmEnabled = val;
                _update();
              }),
                activeColor: Colors.blueAccent,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Servis seçtiğiniz mesafeye geldiğinde sizi uyarır.',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          if (_isAlarmEnabled) ...[
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bildirim Mesafesi', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${_alarmDistance.toStringAsFixed(1)} km', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider.adaptive(
              value: _alarmDistance,
              min: 0.5,
              max: 5.0,
              divisions: 9,
              onChanged: (val) => setState(() {
                 _alarmDistance = val;
                 _update();
              }),
            ),
            const Divider(height: 30),
            _buildToggleItem(Icons.vibration, 'Titreşim', _vibrateOnAlarm, (v) => setState(() {
               _vibrateOnAlarm = v;
               _update();
            })),
            _buildToggleItem(Icons.volume_up_outlined, 'Sesli Uyarı', _soundOnAlarm, (v) => setState(() {
               _soundOnAlarm = v;
               _update();
            })),
          ],
        ],
      ),
    );
  }

  Widget _buildGeneralSection() {
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
          _buildDetailItem(Icons.language, 'Uygulama Dili', 'Türkçe'),
          const Divider(height: 30),
          _buildDetailItem(Icons.dark_mode_outlined, 'Görünüm', 'Açık Tema'),
          const Divider(height: 30),
          _buildDetailItem(Icons.info_outline, 'Versiyon', '1.0.4-beta'),
        ],
      ),
    );
  }

  Widget _buildToggleItem(IconData icon, String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        Row(
          children: [
            Text(value, style: TextStyle(color: Colors.grey[600])),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ],
    );
  }
}
