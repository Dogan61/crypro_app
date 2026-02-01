import 'package:crypto_app/core/constants/image_const.dart';
import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/extension/x_build_context.dart';
import 'package:flutter/material.dart';

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({super.key});

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
                TextConst.bitcoin,
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                TextConst.btc,
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
                TextConst.watchlistPrice,
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                TextConst.marketCapChange,
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.green,
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
