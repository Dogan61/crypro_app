import 'dart:ui';

import 'package:crypto_mobil/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class GlassSwitchTile extends StatefulWidget {
  const GlassSwitchTile({
    required this.icon,
    required this.title,
    super.key,
    this.initialValue = false,
  });

  final IconData icon;
  final String title;
  final bool initialValue;

  @override
  State<GlassSwitchTile> createState() => _GlassSwitchTileState();
}

class _GlassSwitchTileState extends State<GlassSwitchTile> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                _icon(widget.icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: value,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => value = v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
