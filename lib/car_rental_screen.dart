// lib/screens/car_rental_screen.dart
import 'package:flutter/material.dart';
import 'package:mavtra_ui_test/widgets/car_card.dart';

import 'app_colors.dart';
import 'models/car_data.dart';

class CarRentalScreen extends StatefulWidget {
  const CarRentalScreen({super.key});

  @override
  State<CarRentalScreen> createState() => _CarRentalScreenState();
}

class _CarRentalScreenState extends State<CarRentalScreen> {
  String selectedCategory = 'SUV';

  final List<String> categories = ['SUV', 'Hatchback', 'Sedan', 'Luxury'];

  final List<CarData> cars = [
    CarData(
      name: 'Mazda CX-3',
      price: '\$200',
      rating: 5.0,
      image: '🚙',
      category: 'SUV',
    ),
    CarData(
      name: 'Buick Envision',
      price: '\$200',
      rating: 4.8,
      image: '🚗',
      category: 'SUV',
    ),
    CarData(
      name: 'Mazda 3',
      price: '\$180',
      rating: 4.8,
      image: '🚗',
      category: 'Hatchback',
    ),
    CarData(
      name: 'Toyota Corolla',
      price: '\$110',
      rating: 4.9,
      image: '🚗',
      category: 'Hatchback',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Car rent',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Filters',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: _buildCarList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? AppColors.black : AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarList() {
    final filteredCars = cars.where((car) => car.category == selectedCategory).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredCars.length,
      itemBuilder: (context, index) {
        return CarCard(car: filteredCars[index]);
      },
    );
  }
}