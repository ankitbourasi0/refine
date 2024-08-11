import 'package:flutter/material.dart';

class HabitModel {
  String id;
  String title;
  String icon;
  // String? details;
  // bool isDaily;
  // List<String> selectedDays;
  TimeOfDay startTime;
  TimeOfDay endTime;
  Duration duration;
  TimeOfDay reminderTime;
  DateTime date;
  bool isCompleted;


  HabitModel({
    required this.id,
    required this.title,
    required this.icon,
    // this.details,
    // required this.isDaily,
    // required this.selectedDays,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.reminderTime,
    required this.date,
    this.isCompleted = false
  });
}