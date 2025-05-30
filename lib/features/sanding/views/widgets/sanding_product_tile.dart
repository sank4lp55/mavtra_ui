// lib/widgets/sanding_product_tile.dart
import 'package:flutter/material.dart';
import 'package:mavtra_ui_test/core/constants/app_colors.dart';
import '../../models/sanding_product.dart';

class SandingProductTile extends StatelessWidget {
  final SandingProduct product;
  final VoidCallback onTap;
  final VoidCallback onStatusTap;

  const SandingProductTile({
    super.key,
    required this.product,
    required this.onTap,
    required this.onStatusTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.build_circle,
              color: AppColors.black,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            product.name,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor().withOpacity(0.3),
              ),
            ),
            child: Text(
              product.status.displayName,
              style: TextStyle(
                color: _getStatusColor(),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildInfoRow('SO(BON)', product.id, 'B.Prod. Code',
                    product.batchProductCode),
                const SizedBox(height: 16),
                _buildInfoRow('Warehouse', product.warehouse, 'Qty',
                    '${product.quantity} ${product.unit}'),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // GestureDetector(
              //   onTap: onStatusTap,
              //   child: Container(
              //     width: 36,
              //     height: 36,
              //     decoration: BoxDecoration(
              //       color: _getStatusColor(),
              //       shape: BoxShape.circle,
              //       boxShadow: [
              //         BoxShadow(
              //           color: _getStatusColor().withOpacity(0.3),
              //           blurRadius: 8,
              //           offset: const Offset(0, 2),
              //         ),
              //       ],
              //     ),
              //     child: Icon(
              //       _getStatusIcon(),
              //       color: AppColors.white,
              //       size: 18,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label1,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '#',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label2,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (label2 == 'B.Prod. Code')
                    Icon(
                      Icons.code,
                      size: 12,
                      color: AppColors.primary,
                    )
                  else if (label2 == 'Qty')
                    Icon(
                      Icons.scale,
                      size: 12,
                      color: AppColors.primary,
                    )
                  else if (label2.contains('Warehouse'))
                    Icon(
                      Icons.home,
                      size: 12,
                      color: AppColors.primary,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value2,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (product.status) {
      case SandingStatus.pending:
        return Colors.orange;
      case SandingStatus.inProgress:
        return Colors.green;
      case SandingStatus.completed:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon() {
    switch (product.status) {
      case SandingStatus.pending:
        return Icons.schedule;
      case SandingStatus.inProgress:
        return Icons.play_arrow;
      case SandingStatus.completed:
        return Icons.check;
    }
  }
}
