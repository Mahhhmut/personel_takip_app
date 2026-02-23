import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  // Kamera kontrolcüsü
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  @override
  void dispose() {
    controller.dispose(); // Ekran kapanırken kamerayı tamamen serbest bırakır
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Kodu Okutun')),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          if (isScanned) return;

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              isScanned = true;
              
              // SİYAH EKRAN ÇÖZÜMÜ: Önce taramayı durdur, sonra çık
              await controller.stop();
              
              if (mounted) {
                Navigator.pop(context, code);
              }
            }
          }
        },
      ),
    );
  }
}