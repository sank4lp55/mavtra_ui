import
'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mavtra_ui_test/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class QRResultScreen extends StatelessWidget {
  final String qrData;

  const QRResultScreen({super.key, required this.qrData});

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
          'Scan Result',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _shareResult(context),
            icon: const Icon(Icons.share, color: AppColors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// Success indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'QR Code Scanned Successfully!',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

// Data section
            const Text(
              'Scanned Data:',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    qrData,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Type: ${_getDataType(qrData)}',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${qrData.length} characters',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

// Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _copyToClipboard(context),
                    icon: const Icon(Icons.copy, size: 20),
                    label: const Text('Copy'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      side: BorderSide(
                        color: AppColors.white.withOpacity(0.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUrl(qrData) ? () => _openUrl(context) : null,
                    icon: const Icon(Icons.open_in_new, size: 20),
                    label: const Text('Open'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isUrl(qrData)
                          ? AppColors.primary
                          : AppColors.grey.withOpacity(0.3),
                      foregroundColor: _isUrl(qrData)
                          ? AppColors.black
                          : AppColors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

// Scan another button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.qr_code_scanner, size: 20),
                label: const Text('Scan Another'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDataType(String data) {
    if (_isUrl(data)) return 'URL';
    if (_isEmail(data)) return 'Email';
    if (_isPhone(data)) return 'Phone';
    if (_isWifi(data)) return 'WiFi';
    return 'Text';
  }

  bool _isUrl(String data) {
    return data.startsWith('http://') || data.startsWith('https://');
  }

  bool _isEmail(String data) {
    return data.contains('@') && data.contains('.');
  }

  bool _isPhone(String data) {
    return RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(data);
  }

  bool _isWifi(String data) {
    return data.startsWith('WIFI:');
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: qrData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareResult(BuildContext context) {
// Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would be implemented here'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Future<void> _openUrl(BuildContext context) async {
    if (_isUrl(qrData)) {
      try {
        final Uri url = Uri.parse(qrData);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $qrData';
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open URL: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}