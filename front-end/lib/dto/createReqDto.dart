class CreateReqDto {
  final String category;
  final String date;
  final String startTime;
  final String endTime;
  final String description;
  final int rating;

  CreateReqDto({
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
        "category": category,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
        "rating": rating
      };
}
