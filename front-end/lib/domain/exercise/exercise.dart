import 'package:flutter/material.dart';

class Exercise {
  final int? id;
  final String? category;
  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? description;
  final int? rating;

  Exercise(this.id, this.category, this.date, this.startTime, this.endTime,
      this.description, this.rating);

  Exercise.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        category = json["category"],
        date = json["date"],
        startTime = json["startTime"],
        endTime = json["endTime"],
        description = json["description"],
        rating = json["rating"];
}
