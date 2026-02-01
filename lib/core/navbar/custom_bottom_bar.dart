import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [_GlassBar(), _CenterActionButton()],
      ),
    );
  }
}

class _GlassBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 70,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(icon: Icons.bar_chart, label: 'Market', active: true),
              _NavItem(icon: Icons.account_balance_wallet, label: 'Portfolio'),
              SizedBox(width: 48),
              _NavItem(icon: Icons.newspaper, label: 'News'),
              _NavItem(icon: Icons.settings, label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.swap_horiz, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });
  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.blue : Colors.grey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}
