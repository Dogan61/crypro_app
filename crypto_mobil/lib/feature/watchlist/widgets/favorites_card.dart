import 'package:crypto_mobil/core/constants/image_const.dart';
import 'package:crypto_mobil/core/extension/x_build_context.dart';
import 'package:flutter/material.dart';

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({
    required this.title,
    required this.symbol,
    required this.priceText,
    required this.changeText,
    this.isPositive = true,
    super.key,
  });

  final String title;
  final String symbol;
  final String priceText;
  final String changeText;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        border: Border.all(color: Colors.grey.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(ImageConst.avatar),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                symbol,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceText,
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                changeText,
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  color: isPositive ? Colors.green : Colors.red,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
