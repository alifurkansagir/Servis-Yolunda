import 'package:flutter/material.dart';

class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  bool isAlarmEnabled = true;
  double alarmDistance = 1.0;
  bool vibrateOnAlarm = true;
  bool soundOnAlarm = true;

  // Simple listeners for UI updates
  VoidCallback? onSettingsChanged;

  void updateSettings({
    bool? isAlarmEnabled,
    double? alarmDistance,
    bool? vibrateOnAlarm,
    bool? soundOnAlarm,
  }) {
    if (isAlarmEnabled != null) this.isAlarmEnabled = isAlarmEnabled;
    if (alarmDistance != null) this.alarmDistance = alarmDistance;
    if (vibrateOnAlarm != null) this.vibrateOnAlarm = vibrateOnAlarm;
    if (soundOnAlarm != null) this.soundOnAlarm = soundOnAlarm;
    onSettingsChanged?.call();
  }
}
