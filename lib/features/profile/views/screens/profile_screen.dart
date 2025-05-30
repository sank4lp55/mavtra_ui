// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:mavtra_ui_test/core/constants/app_colors.dart';
import 'package:mavtra_ui_test/features/profile/models/menu_item_data.dart';
import '../../../contact_us/views/screens/contact_us_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildProfileInfo(),
              _buildMenuItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: const Text(
              'JD',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'john.doe@email.com',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      MenuItemData(
        icon: Icons.person_outline,
        title: 'Personal Information',
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.history,
        title: 'Booking History',
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.favorite_outline,
        title: 'Favorites',
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.notifications,
        title: 'Notifications',
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.help_outline,
        title: 'Help & Support',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactUsScreen()),
          );
        },
      ),
      MenuItemData(
        icon: Icons.contact_support_outlined,
        title: 'Contact Us',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactUsScreen()),
          );
        },
      ),
      MenuItemData(
        icon: Icons.info_outline,
        title: 'About',
        onTap: () {},
      ),
      MenuItemData(
        icon: Icons.logout,
        title: 'Logout',
        onTap: () {},
        isDestructive: true,
      ),
    ];

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuItems.length,
        separatorBuilder: (context, index) => Divider(
          color: AppColors.white.withOpacity(0.1),
          height: 1,
        ),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: Icon(
              item.icon,
              color: item.isDestructive ? AppColors.accent : AppColors.white,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                color: item.isDestructive ? AppColors.accent : AppColors.white,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: item.isDestructive ? AppColors.accent : AppColors.grey,
              size: 16,
            ),
            onTap: item.onTap,
          );
        },
      ),
    );
  }
}