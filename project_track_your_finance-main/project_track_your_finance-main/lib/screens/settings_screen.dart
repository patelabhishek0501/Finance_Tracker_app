import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _autoBackupEnabled = false;
  String _selectedCurrency = "INR";
  String _selectedLanguage = "English";
  String _pinCode = "";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkTheme') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _autoBackupEnabled = prefs.getBool('autoBackupEnabled') ?? false;
      _selectedCurrency = prefs.getString('currency') ?? "USD";
      _selectedLanguage = prefs.getString('language') ?? "English";
      _pinCode = prefs.getString('pinCode') ?? "";
    });
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  void _showCupertinoPicker({
    required String title,
    required List<String> options,
    required String selected,
    required Function(String) onSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(title),
        actions: options.map((option) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() => onSelected(option));
              _updateSetting(title.toLowerCase(), option);
            },
            child: Text(
              option,
              style: TextStyle(
                fontWeight: option == selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  void _showPinSetupDialog() {
    TextEditingController pinController = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text("Set App Lock PIN"),
        content: Column(
          children: [
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              placeholder: "Enter 6-digit PIN",
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              setState(() => _pinCode = pinController.text);
              _updateSetting('pinCode', pinController.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loadSettings();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Settings Reset to Default")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Settings"),
        backgroundColor: CupertinoColors.systemGrey6,
      ),
      child: SafeArea(
        child: ListView(
          children: [
            _buildSectionHeader("General"),
            // _buildCupertinoTile(
            //   title: "Theme",
            //   child: CupertinoSlidingSegmentedControl<bool>(
            //     groupValue: _isDarkMode,
            //     onValueChanged: (value) {
            //       setState(() => _isDarkMode = value!);
            //       _updateSetting('isDarkTheme', value);
            //     },
            //     children: const {
            //       false: Padding(padding: EdgeInsets.all(8), child: Text("Light")),
            //       true: Padding(padding: EdgeInsets.all(8), child: Text("Dark")),
            //     },
            //   ),
            // ),
            _buildCupertinoSwitchTile(
              title: "Enable Notifications",
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
                _updateSetting('notificationsEnabled', val);
              },
            ),
            _buildCupertinoSwitchTile(
              title: "Enable Auto Backup",
              value: _autoBackupEnabled,
              onChanged: (val) {
                setState(() => _autoBackupEnabled = val);
                _updateSetting('autoBackupEnabled', val);
              },
            ),
            _buildCupertinoTile(
              title: "Currency",
              subtitle: _selectedCurrency,
              onTap: () => _showCupertinoPicker(
                title: "Currency",
                options: ["USD", "EUR", "INR", "GBP", "JPY"],
                selected: _selectedCurrency,
                onSelected: (val) => _selectedCurrency = val,
              ),
            ),
            _buildCupertinoTile(
              title: "Language",
              subtitle: _selectedLanguage,
              onTap: () => _showCupertinoPicker(
                title: "Language",
                options: ["English", "Spanish", "French", "German", "Hindi"],
                selected: _selectedLanguage,
                onSelected: (val) => _selectedLanguage = val,
              ),
            ),
            _buildSectionHeader("Security"),
            _buildCupertinoTile(
              title: "Set App Lock PIN",
              subtitle: _pinCode.isEmpty ? "Not Set" : "PIN Set",
              onTap: _showPinSetupDialog,
            ),
            _buildSectionHeader("Backup & Restore"),
            _buildCupertinoTile(
              title: "Backup & Restore",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Backup & Restore coming soon!")),
                );
              },
            ),
            _buildCupertinoTile(
              title: "Reset to Default Settings",
              titleColor: CupertinoColors.systemRed,
              onTap: _resetToDefaults,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  Widget _buildCupertinoTile({
    required String title,
    String? subtitle,
    Widget? child,
    VoidCallback? onTap,
    Color titleColor = CupertinoColors.label,
  }) {
    return CupertinoListTile(
      title: Text(title, style: TextStyle(color: titleColor)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: onTap,
      trailing: child ?? const Icon(CupertinoIcons.forward),
    );
  }

  Widget _buildCupertinoSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CupertinoListTile(
      title: Text(title),
      trailing: CupertinoSwitch(value: value, onChanged: onChanged),
    );
  }
}
