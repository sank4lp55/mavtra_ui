// lib/models/sanding_product.dart
enum SandingStatus {
  pending,
  inProgress,
  completed,
}

extension SandingStatusExtension on SandingStatus {
  String get displayName {
    switch (this) {
      case SandingStatus.pending:
        return 'Pending';
      case SandingStatus.inProgress:
        return 'In Progress';
      case SandingStatus.completed:
        return 'Completed';
    }
  }

  String get colorCode {
    switch (this) {
      case SandingStatus.pending:
        return '#FFA500'; // Orange
      case SandingStatus.inProgress:
        return '#4CAF50'; // Green
      case SandingStatus.completed:
        return '#2196F3'; // Blue
    }
  }
}

class SandingProduct {
  final String id;
  final String name;
  final String batchProductCode;
  final String warehouse;
  final int quantity;
  final String unit;
  final String imageUrl;
  SandingStatus status;

  SandingProduct({
    required this.id,
    required this.name,
    required this.batchProductCode,
    required this.warehouse,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
    required this.status,
  });
}