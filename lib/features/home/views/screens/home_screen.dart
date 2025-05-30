// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mavtra_ui_test/features/activity/views/screens/activity_detail_screen.dart';
import 'package:mavtra_ui_test/features/sanding/views/screens/sanding_mmn_screen.dart';
import '../widgets/erp_module_card.dart';
import '../widgets/activity_tile.dart';
import '../widgets/stats_card.dart';
import '../../../all_modules/views/screens/all_modules_screen.dart';
import 'package:mavtra_ui_test/core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildStatsCards(),
              _buildQuickAccessModules(context),
              _buildRecentActivity(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Image.asset(
            "assets/Mavtra Logo Transparent 2.png",
            height: 25,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: AppColors.white,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: StatsCard(
              title: 'Active Orders',
              value: '24',
              subtitle: '+3 today',
              icon: Icons.shopping_cart,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatsCard(
              title: 'In Production',
              value: '12',
              subtitle: '8 pending',
              icon: Icons.precision_manufacturing,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatsCard(
              title: 'Shipped',
              value: '156',
              subtitle: 'This month',
              icon: Icons.local_shipping,
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessModules(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Quick Access',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllModulesScreen(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    "assets/Arrow_Up_Right_MD.svg",
                    color: AppColors.primary,
                  )),
            ],
          ),
          const SizedBox(height: 16),
          _buildStaggeredGrid(context),
        ],
      ),
    );
  }

  Widget _buildStaggeredGrid(BuildContext context) {
    return Column(
      children: [
        // First row - 2 cards
        Row(
          children: [
            Expanded(
              flex: 3,
              child: ErpModuleCard(
                title: 'Sale Orders',
                icon: Icons.receipt_long,
                backgroundColor: AppColors.moduleColors[0],
                pendingCount: 8,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ErpModuleCard(
                title: 'Purchase',
                icon: Icons.shopping_cart,
                backgroundColor: AppColors.moduleColors[1],
                pendingCount: 5,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row - 3 cards
        Row(
          children: [
            Expanded(
              child: ErpModuleCard(
                title: 'Gate Activity',
                icon: Icons.door_front_door,
                backgroundColor: AppColors.moduleColors[2],
                pendingCount: 3,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ErpModuleCard(
                title: 'Shipping',
                icon: Icons.local_shipping,
                backgroundColor: AppColors.moduleColors[3],
                pendingCount: 12,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ErpModuleCard(
                title: 'Reports',
                icon: Icons.bar_chart,
                backgroundColor: AppColors.moduleColors[4],
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Third row - 2 cards
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ErpModuleCard(
                title: 'Sanding',
                icon: Icons.handyman,
                backgroundColor: AppColors.moduleColors[5],
                pendingCount: 7,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SandingScreen()));
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: ErpModuleCard(
                title: 'Polish',
                icon: Icons.auto_awesome,
                backgroundColor: AppColors.moduleColors[6],
                pendingCount: 4,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Last 24 hours',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              ActivityTile(
                title: 'SO-2024-001 Confirmed',
                subtitle: 'Sale order for ₹2,45,000 • 2 hours ago',
                icon: Icons.check_circle,
                iconColor: const Color(0xFF10B981),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityDetailScreen(
                        activityId: 'PO-2024-089',
                        title: 'PO-2024-089 Created',
                        subtitle:
                            'Purchase order for raw materials • 4 hours ago',
                        icon: Icons.add_circle_outline,
                        iconColor: AppColors.primary,
                        timestamp: '4 hours ago',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ActivityTile(
                title: 'PO-2024-089 Created',
                subtitle: 'Purchase order for raw materials • 4 hours ago',
                icon: Icons.add_circle_outline,
                iconColor: AppColors.primary,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              ActivityTile(
                title: 'Sanding Completed',
                subtitle: 'Batch SND-240315 ready for polish • 6 hours ago',
                icon: Icons.done_all,
                iconColor: const Color(0xFF06B6D4),
                onTap: () {},
              ),
              const SizedBox(height: 12),
              ActivityTile(
                title: 'Shipment Dispatched',
                subtitle: 'SH-2024-156 sent to Mumbai • 8 hours ago',
                icon: Icons.local_shipping,
                iconColor: const Color(0xFF8B5CF6),
                onTap: () {},
              ),
              const SizedBox(height: 12),
              ActivityTile(
                title: 'Quality Check Failed',
                subtitle: 'Batch QC-240314 needs rework • 10 hours ago',
                icon: Icons.error_outline,
                iconColor: AppColors.accent,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              ActivityTile(
                title: 'Component Polish Done',
                subtitle: 'Batch CP-240313 moved to fitting • 12 hours ago',
                icon: Icons.auto_fix_high,
                iconColor: const Color(0xFFEC4899),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
