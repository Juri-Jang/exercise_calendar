import 'package:flutter/material.dart';

class CreateReqDto {
  // final User user;
  final String category;
  final TimeOfDay createTime;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String description;
  final int rating;

  CreateReqDto(this.category, this.createTime, this.startTime, this.endTime,
      this.description, this.rating);

  Map<String, dynamic> toJson() => {
        "category": category,
        "createTime": createTime,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "rating": rating
      };
}
