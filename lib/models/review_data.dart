// lib/models/review_data.dart
class ReviewData {
  final String userName;
  final double rating;
  final String comment;
  final String date;
  final String storeName;

  ReviewData({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.storeName,
  });
}