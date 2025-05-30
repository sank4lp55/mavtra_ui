// lib/screens/activity_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:mavtra_ui_test/core/constants/app_colors.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String activityId;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String timestamp;

  const ActivityDetailScreen({
    super.key,
    required this.activityId,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final activityData = _getActivityData();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Activity Details',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.white),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(activityData),
            const SizedBox(height: 20),

            // Status Card
            _buildStatusCard(activityData),
            const SizedBox(height: 20),

            // Details Card
            _buildDetailsCard(activityData),
            const SizedBox(height: 20),

            // Timeline Card
            _buildTimelineCard(activityData),
            const SizedBox(height: 20),

            // Actions
            _buildActionButtons(context, activityData),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['category'],
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.grey, size: 16),
              const SizedBox(width: 6),
              Text(
                timestamp,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: data['statusColor'].withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: data['statusColor'].withOpacity(0.3),
                  ),
                ),
                child: Text(
                  data['status'],
                  style: TextStyle(
                    color: data['statusColor'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                data['priority'],
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...data['details'].map<Widget>((detail) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    detail['label'],
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    detail['value'],
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Timeline',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...data['timeline'].map<Widget>((event) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: BoxDecoration(
                    color: event['color'],
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        event['time'],
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> data) {
    return Column(
      children: [
        if (data['actions'].isNotEmpty) ...[
          ...data['actions'].map<Widget>((action) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleAction(context, action['type']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: action['isPrimary']
                      ? AppColors.primary
                      : AppColors.white.withOpacity(0.05),
                  foregroundColor: action['isPrimary']
                      ? AppColors.white
                      : AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: action['isPrimary']
                        ? BorderSide.none
                        : BorderSide(color: AppColors.white.withOpacity(0.1)),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  action['label'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )).toList(),
        ],
      ],
    );
  }

  Map<String, dynamic> _getActivityData() {
    // Mock data based on activity type
    if (title.contains('PO-2024-089')) {
      return {
        'category': 'Purchase Order',
        'status': 'Active',
        'statusColor': AppColors.primary,
        'priority': 'High Priority',
        'details': [
          {'label': 'Order ID', 'value': 'PO-2024-089'},
          {'label': 'Supplier', 'value': 'ABC Raw Materials Ltd.'},
          {'label': 'Amount', 'value': '₹2,45,000'},
          {'label': 'Items', 'value': '15 different materials'},
          {'label': 'Expected', 'value': 'March 20, 2024'},
        ],
        'timeline': [
          {'title': 'Order created and sent to supplier', 'time': '4 hours ago', 'color': AppColors.primary},
          {'title': 'Supplier acknowledged order', 'time': '2 hours ago', 'color': const Color(0xFF06B6D4)},
          {'title': 'Payment processed', 'time': '1 hour ago', 'color': const Color(0xFF10B981)},
        ],
        'actions': [
          {'label': 'Track Order', 'type': 'track', 'isPrimary': true},
          {'label': 'Contact Supplier', 'type': 'contact', 'isPrimary': false},
          {'label': 'View Invoice', 'type': 'invoice', 'isPrimary': false},
        ],
      };
    } else if (title.contains('Sanding Completed')) {
      return {
        'category': 'Production',
        'status': 'Completed',
        'statusColor': const Color(0xFF06B6D4),
        'priority': 'Normal Priority',
        'details': [
          {'label': 'Batch ID', 'value': 'SND-240315'},
          {'label': 'Quantity', 'value': '250 units'},
          {'label': 'Operator', 'value': 'Rajesh Kumar'},
          {'label': 'Duration', 'value': '6.5 hours'},
          {'label': 'Next Stage', 'value': 'Polish Department'},
        ],
        'timeline': [
          {'title': 'Sanding process started', 'time': '12 hours ago', 'color': AppColors.primary},
          {'title': 'Quality check passed', 'time': '7 hours ago', 'color': const Color(0xFF10B981)},
          {'title': 'Sanding completed', 'time': '6 hours ago', 'color': const Color(0xFF06B6D4)},
        ],
        'actions': [
          {'label': 'Move to Polish', 'type': 'move', 'isPrimary': true},
          {'label': 'View Quality Report', 'type': 'report', 'isPrimary': false},
        ],
      };
    } else if (title.contains('Shipment Dispatched')) {
      return {
        'category': 'Shipping',
        'status': 'In Transit',
        'statusColor': const Color(0xFF8B5CF6),
        'priority': 'High Priority',
        'details': [
          {'label': 'Shipment ID', 'value': 'SH-2024-156'},
          {'label': 'Destination', 'value': 'Mumbai, Maharashtra'},
          {'label': 'Carrier', 'value': 'Express Logistics'},
          {'label': 'Weight', 'value': '150 kg'},
          {'label': 'Est. Delivery', 'value': 'March 18, 2024'},
        ],
        'timeline': [
          {'title': 'Package prepared for shipping', 'time': '10 hours ago', 'color': AppColors.primary},
          {'title': 'Dispatched from warehouse', 'time': '8 hours ago', 'color': const Color(0xFF8B5CF6)},
          {'title': 'In transit to Mumbai', 'time': '6 hours ago', 'color': const Color(0xFF06B6D4)},
        ],
        'actions': [
          {'label': 'Track Shipment', 'type': 'track', 'isPrimary': true},
          {'label': 'Contact Carrier', 'type': 'contact', 'isPrimary': false},
          {'label': 'Generate Invoice', 'type': 'invoice', 'isPrimary': false},
        ],
      };
    } else if (title.contains('Quality Check Failed')) {
      return {
        'category': 'Quality Control',
        'status': 'Failed',
        'statusColor': AppColors.accent,
        'priority': 'Critical',
        'details': [
          {'label': 'Batch ID', 'value': 'QC-240314'},
          {'label': 'Inspector', 'value': 'Priya Sharma'},
          {'label': 'Failed Items', 'value': '23 out of 100'},
          {'label': 'Issue Type', 'value': 'Surface defects'},
          {'label': 'Action Req.', 'value': 'Rework required'},
        ],
        'timeline': [
          {'title': 'Quality inspection started', 'time': '12 hours ago', 'color': AppColors.primary},
          {'title': 'Defects identified', 'time': '10 hours ago', 'color': AppColors.accent},
          {'title': 'Batch marked for rework', 'time': '10 hours ago', 'color': const Color(0xFFF59E0B)},
        ],
        'actions': [
          {'label': 'Start Rework', 'type': 'rework', 'isPrimary': true},
          {'label': 'View Defect Report', 'type': 'report', 'isPrimary': false},
          {'label': 'Notify Supervisor', 'type': 'notify', 'isPrimary': false},
        ],
      };
    } else {
      return {
        'category': 'Production',
        'status': 'Completed',
        'statusColor': const Color(0xFFEC4899),
        'priority': 'Normal Priority',
        'details': [
          {'label': 'Batch ID', 'value': 'CP-240313'},
          {'label': 'Quantity', 'value': '180 units'},
          {'label': 'Operator', 'value': 'Amit Singh'},
          {'label': 'Duration', 'value': '4.2 hours'},
          {'label': 'Next Stage', 'value': 'Fitting Department'},
        ],
        'timeline': [
          {'title': 'Polish process started', 'time': '16 hours ago', 'color': AppColors.primary},
          {'title': 'Quality approved', 'time': '13 hours ago', 'color': const Color(0xFF10B981)},
          {'title': 'Moved to fitting', 'time': '12 hours ago', 'color': const Color(0xFFEC4899)},
        ],
        'actions': [
          {'label': 'Start Fitting', 'type': 'fitting', 'isPrimary': true},
          {'label': 'View Progress', 'type': 'progress', 'isPrimary': false},
        ],
      };
    }
  }

  void _handleAction(BuildContext context, String actionType) {
    // Handle different action types
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$actionType action triggered'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.white),
              title: const Text('Share Activity', style: TextStyle(color: AppColors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border, color: AppColors.white),
              title: const Text('Bookmark', style: TextStyle(color: AppColors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.download, color: AppColors.white),
              title: const Text('Export Details', style: TextStyle(color: AppColors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}