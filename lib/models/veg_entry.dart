import 'package:flutter/material.dart';

enum LogStatus { pending, accepted, question }

class VegEntry {
  VegEntry({
    required this.id,
    required this.amount,
    required this.time,
    required this.weight,
    required this.status,
    this.note,
    this.photoUrl,
    this.photoTone = const [Colors.transparent, Colors.transparent],
  });
  final String id;
  final double amount;
  final String time;
  final String weight;
  LogStatus status;
  final List<Color> photoTone;
  final String? note;
  final String? photoUrl;

  VegEntry copyWith({
    String? id,
    double? amount,
    String? weight,
    String? time,
    LogStatus? status,
    String? photoUrl,
    List<Color>? photoTone,
  }) {
    return VegEntry(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      weight: weight ?? this.weight,
      time: time ?? this.time,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
      photoTone: photoTone ?? this.photoTone,
    );
  }
}

class StatusStyle {
  const StatusStyle(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

StatusStyle statusStyle(LogStatus status) {
  switch (status) {
    case LogStatus.pending:
      return const StatusStyle(
        'Pending',
        Icons.hourglass_bottom,
        Color(0xFF8A5B00),
      );
    case LogStatus.accepted:
      return const StatusStyle(
        'Checked',
        Icons.verified_outlined,
        Color(0xFF2F6B4F),
      );
    case LogStatus.question:
      return const StatusStyle('Ask', Icons.help_outline, Color(0xFFB23A2F));
  }
}
