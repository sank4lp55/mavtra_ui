// lib/screens/sanding_screen.dart
import 'package:flutter/material.dart';
import '../widgets/sanding_product_tile.dart';
import '../models/sanding_product.dart';
import 'app_colors.dart';

class SandingScreen extends StatefulWidget {
  const SandingScreen({super.key});

  @override
  State<SandingScreen> createState() => _SandingScreenState();
}

class _SandingScreenState extends State<SandingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<SandingProduct> _products = [
    SandingProduct(
      id: 'SO001',
      name: 'Table Top A',
      batchProductCode: 'TPA-001',
      warehouse: 'Unit 1',
      quantity: 10,
      unit: 'pcs',
      imageUrl:
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=200&fit=crop',
      status: SandingStatus.pending,
    ),
    SandingProduct(
      id: 'SO002',
      name: 'Chair Leg B',
      batchProductCode: 'CLB-002',
      warehouse: 'Unit 2',
      quantity: 20,
      unit: 'pcs',
      imageUrl:
      'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?w=300&h=200&fit=crop',
      status: SandingStatus.inProgress,
    ),
    SandingProduct(
      id: 'SO003',
      name: 'Wood Panel C',
      batchProductCode: 'WPC-003',
      warehouse: 'Unit 3',
      quantity: 15,
      unit: 'pcs',
      imageUrl:
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=200&fit=crop',
      status: SandingStatus.completed,
    ),
    SandingProduct(
      id: 'SO004',
      name: 'Drawer D',
      batchProductCode: 'DRD-004',
      warehouse: 'Unit 1',
      quantity: 30,
      unit: 'pcs',
      imageUrl:
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&h=200&fit=crop',
      status: SandingStatus.pending,
    ),
    SandingProduct(
      id: 'SO005',
      name: 'Cupboard Door E',
      batchProductCode: 'CDE-005',
      warehouse: 'Unit 2',
      quantity: 25,
      unit: 'pcs',
      imageUrl:
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=200&fit=crop',
      status: SandingStatus.inProgress,
    ),
  ];

  List<SandingProduct> get _filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.batchProductCode
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          product.id.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: const Text(
          'Sanding Management',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildStatsRow(),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
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
                'Search products...',
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
    );
  }

  Widget _buildStatsRow() {
    final pendingCount =
        _products
            .where((p) => p.status == SandingStatus.pending)
            .length;
    final inProgressCount =
        _products
            .where((p) => p.status == SandingStatus.inProgress)
            .length;
    final completedCount =
        _products
            .where((p) => p.status == SandingStatus.completed)
            .length;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 00, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Pending', pendingCount, Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
                'In Progress', inProgressCount, const Color(0xFF10B981)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
                'Completed', completedCount, const Color(0xFF3B82F6)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return SandingProductTile(
          product: _filteredProducts[index],
          onTap: () => _showProductDetails(_filteredProducts[index]),
          onStatusTap: () => _updateProductStatus(_filteredProducts[index]),
        );
      },
    );
  }

  void _showProductDetails(SandingProduct product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildProductDetailsSheet(product),
    );
  }

  Widget _buildProductDetailsSheet(SandingProduct product) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('SO(BON) #', product.id),
                        _buildDetailRow(
                            'B.Prod. Code', product.batchProductCode),
                        _buildDetailRow('Warehouse', product.warehouse),
                        _buildDetailRow(
                            'Quantity', '${product.quantity} ${product.unit}'),
                        _buildDetailRow('Status', product.status.displayName),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildActionButtons(product),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(SandingProduct product) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateProductStatus(product);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              product.status == SandingStatus.pending
                  ? 'Start Sanding'
                  : product.status == SandingStatus.inProgress
                  ? 'Complete Sanding'
                  : 'Mark as Pending',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('QR code for ${product.name} scanned'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.black,
              side: const BorderSide(color: AppColors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, size: 20),
                SizedBox(width: 8),
                Text('Scan QR Code',style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _updateProductStatus(SandingProduct product) {
    setState(() {
      switch (product.status) {
        case SandingStatus.pending:
          product.status = SandingStatus.inProgress;
          break;
        case SandingStatus.inProgress:
          product.status = SandingStatus.completed;
          break;
        case SandingStatus.completed:
          product.status = SandingStatus.pending;
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${product.name} status updated to ${product.status.displayName}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
