import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mavtra_ui_test/qr_result_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mavtra_ui_test/app_colors.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScannerBottomSheet extends StatefulWidget {
  const QRScannerBottomSheet({super.key});

  @override
  State<QRScannerBottomSheet> createState() => _QRScannerBottomSheetState();
}

class _QRScannerBottomSheetState extends State<QRScannerBottomSheet>
    with TickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _flashEnabled = false;
  bool _cameraInitialized = false;
  bool _permissionGranted = false;
  String _permissionStatus = 'Checking permissions...';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
    _checkCameraPermission();
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() {
          _permissionGranted = true;
          _permissionStatus = 'Camera ready';
        });
      } else {
        setState(() {
          _permissionStatus = 'Camera permission denied';
        });
      }
    } else if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
        _permissionStatus = 'Camera ready';
      });
    } else {
      setState(() {
        _permissionStatus = 'Camera permission required';
      });
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (result == null) {
        setState(() {
          result = scanData;
        });
        _handleScanResult(scanData.code ?? '');
      }
    });

// Set camera as initialized after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _cameraInitialized = true;
        });
      }
    });
  }

  void _handleScanResult(String code) {
    controller?.pauseCamera();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRResultScreen(qrData: code),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildScannerView(),
          ),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'QR Code Scanner',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Position QR code within the frame to scan',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerView() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
// Camera view or permission message
            if (_permissionGranted)
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.transparent,
                  borderRadius: 20,
                  borderLength: 0,
                  borderWidth: 0,
                  cutOutSize: 250,
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.grey.withOpacity(0.3),
                      AppColors.black,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: AppColors.grey,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _permissionStatus,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                        ),
                      ),
                      if (!_permissionGranted) ...[
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _checkCameraPermission,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.black,
                          ),
                          child: const Text('Grant Permission'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

// Scanning frame overlay
            if (_permissionGranted && _cameraInitialized)
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
// Corner indicators
                      _buildCornerIndicator(Alignment.topLeft),
                      _buildCornerIndicator(Alignment.topRight),
                      _buildCornerIndicator(Alignment.bottomLeft),
                      _buildCornerIndicator(Alignment.bottomRight),
// Scanning line
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Positioned(
                            top: _animation.value * 220 + 15,
                            left: 15,
                            right: 15,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0),
                                    AppColors.primary,
                                    AppColors.primary.withOpacity(0),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.6),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

// Flash toggle
            if (_permissionGranted)
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () async {
                    await controller?.toggleFlash();
                    setState(() {
                      _flashEnabled = !_flashEnabled;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _flashEnabled
                            ? AppColors.primary.withOpacity(0.5)
                            : AppColors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      _flashEnabled ? Icons.flash_on : Icons.flash_off,
                      color: _flashEnabled ? AppColors.primary : AppColors
                          .white,
                      size: 24,
                    ),
                  ),
                ),
              ),

// Gallery button
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: _openGallery,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerIndicator(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.primary,
              width: alignment == Alignment.topLeft ||
                  alignment == Alignment.topRight ? 4 : 0,
            ),
            bottom: BorderSide(
              color: AppColors.primary,
              width: alignment == Alignment.bottomLeft ||
                  alignment == Alignment.bottomRight ? 4 : 0,
            ),
            left: BorderSide(
              color: AppColors.primary,
              width: alignment == Alignment.topLeft ||
                  alignment == Alignment.bottomLeft ? 4 : 0,
            ),
            right: BorderSide(
              color: AppColors.primary,
              width: alignment == Alignment.topRight ||
                  alignment == Alignment.bottomRight ? 4 : 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
// Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: (_permissionGranted && _cameraInitialized)
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (_permissionGranted && _cameraInitialized)
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: (_permissionGranted && _cameraInitialized)
                        ? AppColors.primary
                        : AppColors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  (_permissionGranted && _cameraInitialized)
                      ? 'Ready to scan'
                      : _permissionStatus,
                  style: TextStyle(
                    color: (_permissionGranted && _cameraInitialized)
                        ? AppColors.primary
                        : AppColors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
// Manual input option
          OutlinedButton(
            onPressed: _showManualInput,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.white,
              side: BorderSide(
                color: AppColors.white.withOpacity(0.2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard, size: 20),
                SizedBox(width: 8),
                Text('Enter Code Manually'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
// Here you would typically use a library to decode QR from image
// For now, we'll show a placeholder message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gallery QR scanning not implemented yet'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening gallery: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showManualInput() {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Enter Code Manually',
              style: TextStyle(color: AppColors.white),
            ),
            content: TextField(
              controller: textController,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Enter QR code data',
                hintStyle: TextStyle(color: AppColors.grey),
                filled: true,
                fillColor: AppColors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QRResultScreen(qrData: textController.text),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }
}