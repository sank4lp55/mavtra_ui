import 'package:flutter/material.dart';
import '../widgets/erp_module_card.dart';
import 'app_colors.dart';

class AllModulesScreen extends StatelessWidget {
  const AllModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'All Modules',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: AppColors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search modules...',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.tune,
                    color: AppColors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Production Modules',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                ErpModuleCard(
                  title: 'Sanding',
                  icon: Icons.build_circle,
                  backgroundColor: AppColors.moduleColors[5], // Sanding (index 5)
                  pendingCount: 7,
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Polish',
                  icon: Icons.auto_fix_high,
                  backgroundColor: AppColors.moduleColors[6], // Polish (index 6)
                  pendingCount: 4,
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Fitting',
                  icon: Icons.construction,
                  backgroundColor: AppColors.moduleColors[3], // Shipping color (index 3)
                  pendingCount: 9,
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Packing',
                  icon: Icons.inventory_2,
                  backgroundColor: AppColors.moduleColors[1], // Purchase color (index 1)
                  pendingCount: 6,
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Component Polish',
                  icon: Icons.precision_manufacturing,
                  backgroundColor: AppColors.moduleColors[6], // Polish (index 6)
                  pendingCount: 11,
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Maintenance',
                  icon: Icons.settings,
                  backgroundColor: AppColors.moduleColors[0], // Sale Orders (index 0)
                  pendingCount: 2,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Business Modules',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                ErpModuleCard(
                  title: 'Sale Orders',
                  icon: Icons.point_of_sale,
                  backgroundColor: AppColors.moduleColors[0], // Sale Orders (index 0)
                  pendingCount: 8,
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Purchase',
                  icon: Icons.shopping_bag,
                  backgroundColor: AppColors.moduleColors[1], // Purchase (index 1)
                  pendingCount: 5,
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Gate Activity',
                  icon: Icons.sensor_door,
                  backgroundColor: AppColors.moduleColors[2], // Gate Activity (index 2)
                  pendingCount: 3,
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Shipping',
                  icon: Icons.local_shipping,
                  backgroundColor: AppColors.moduleColors[3], // Shipping (index 3)
                  pendingCount: 12,
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Reporting',
                  icon: Icons.analytics,
                  backgroundColor: AppColors.moduleColors[4], // Reports (index 4)
                  onTap: () {},
                ),
                ErpModuleCard(
                  title: 'Management',
                  icon: Icons.manage_accounts,
                  backgroundColor: AppColors.moduleColors[0], // Sale Orders (index 0)
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
