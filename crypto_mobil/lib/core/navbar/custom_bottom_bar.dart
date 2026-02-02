import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final currentLocation = GoRouterState.of(context).uri.path;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 70,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                icon: Icons.bar_chart,
                label: 'Market',
                active: currentLocation == '/',
                onTap: () => context.go('/'),
              ),
              _NavItem(
                icon: Icons.account_balance_wallet,
                label: 'Watchlist',
                active: currentLocation == '/watchlist',
                onTap: () => context.go('/watchlist'),
              ),
              const SizedBox(width: 48),
              _NavItem(
                icon: Icons.search,
                label: 'Search',
                active: currentLocation == '/search',
                onTap: () => context.go('/search'),
              ),
              _NavItem(
                icon: Icons.settings,
                label: 'Settings',
                active: currentLocation == '/settings',
                onTap: () => context.go('/settings'),
              ),
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
          onPressed: () {
            // TODO: Open trade/swap modal
          },
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.blue : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}
