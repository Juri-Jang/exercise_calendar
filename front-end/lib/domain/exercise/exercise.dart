import 'package:exercise_calendar/domain/user/user.dart';
import 'package:flutter/material.dart';

class Exercise {
  final int id;
  final User user;
  final String category;
  final TimeOfDay createTime;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String description;
  final int rating;

  Exercise(
      {required this.id,
      required this.user,
      required this.category,
      required this.createTime,
      required this.startTime,
      required this.endTime,
      required this.description,
      required this.rating});
}
