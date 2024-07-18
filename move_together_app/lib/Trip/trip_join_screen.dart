import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/core/services/trip_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:move_together_app/Widgets/button.dart';

class JoinTripScreen extends StatefulWidget {
  const JoinTripScreen({super.key});

  @override
  JoinTripScreenState createState() => JoinTripScreenState();
}

class JoinTripScreenState extends State<JoinTripScreen> {
  final TextEditingController _tripCodeController = TextEditingController();
  String? errorMessage;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isKeyboardEnable = false;
  bool isJoiningTrip = false;
  @override
  void initState() {
    super.initState();
    _tripCodeController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _tripCodeController.removeListener(_handleTextChanged);
    _tripCodeController.dispose();
    controller?.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {});
  }

  Future<void> _joinTrip() async {
    if (isJoiningTrip) return;
    setState(() {
      isJoiningTrip = true;
    });
    try {
      final tripServices = TripService(context.read<AuthProvider>());
      await tripServices.join(
        _tripCodeController.text,
      );
      context.replaceNamed('home');
    } catch (e) {
      setState(() {
        errorMessage = 'Impossible de rejoindre le voyage';
      });
    } finally {
      setState(() {
        isJoiningTrip = false;
      });
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _tripCodeController.text = result!.code!;
      });
      _joinTrip();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              ButtonBack(),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Tu as été invité?'),
              const Text(
                  'S\'il te plait, entre le code PIN ci-dessous ou scanne le QR code'),
              const Icon(Icons.groups_rounded,
                  size: 100, color: Color(0xFF79D0BF)),
              if (!isKeyboardEnable)
                Expanded(
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: const Color(0xFF79D0BF),
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _tripCodeController,
                decoration: const InputDecoration(
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent),
                  ),
                ),
                textAlign: TextAlign.center,
                maxLength: 10,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  setState(() {
                    isKeyboardEnable = true;
                  });
                },
                onSubmitted: (_) {
                  setState(() {
                    isKeyboardEnable = false;
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Button(
                  onPressed: _joinTrip,
                  type: _tripCodeController.text.length >= 8
                      ? ButtonType.primary
                      : ButtonType.disabled,
                  text: 'Rejoindre Maintenant',
                ),
              ),
              const SizedBox(height: 16),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
