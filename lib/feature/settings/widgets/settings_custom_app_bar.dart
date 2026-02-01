import 'package:crypto_app/core/constants/text_const.dart';
import 'package:flutter/material.dart';

class SettingsCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SettingsCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        TextConst.settingsTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
