import 'package:flutter/material.dart';

class CoinDetailBottomNav extends StatelessWidget {
  const CoinDetailBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: CryptoActionButton(
                label: 'Sell',
                icon: Icons.sell_outlined,
                backgroundColor: Colors.white.withOpacity(0.08),
                contentColor: Colors.white,
                onTap: () {
                  print('Sell tıklandı');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CryptoActionButton(
                label: 'Buy',
                icon: Icons.shopping_bag_outlined,
                backgroundColor: const Color(0xFF3D5AFE),
                contentColor: Colors.white,
                onTap: () {
                  print('Buy tıklandı');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CryptoActionButton extends StatelessWidget {
  const CryptoActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.contentColor,
    required this.onTap,
    super.key,
  });
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color contentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: contentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
