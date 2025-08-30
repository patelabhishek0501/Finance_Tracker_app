import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinLockScreen extends StatefulWidget {
  final Widget child; // The app's home content after PIN entry
  const PinLockScreen({super.key, required this.child});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _savedPin = '';
  bool _unlocked = false;

  @override
  void initState() {
    super.initState();
    _loadSavedPin();
  }

  Future<void> _loadSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPin = prefs.getString('pinCode') ?? '';
    });
  }

  void _verifyPin() {
    if (_pinController.text == _savedPin) {
      setState(() => _unlocked = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_savedPin.isEmpty || _unlocked) return widget.child;

    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter App PIN", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                placeholder: "6-digit PIN",
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                child: const Text("Unlock"),
                onPressed: _verifyPin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
