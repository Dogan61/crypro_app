import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_mobil/core/extension/x_build_context.dart';
import 'package:crypto_mobil/core/theme/app_color.dart';
import 'package:crypto_mobil/core/utils/coin_image_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CoinDetailCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CoinDetailCustomAppBar({required this.symbol, super.key});
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final baseAsset = symbol.replaceAll('USDT', '');

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.backgroundDark,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Add to watchlist
          },
          icon: const Icon(Icons.star_border),
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withOpacity(0.1),
            child: CachedNetworkImage(
              imageUrl: CoinImageHelper.getCoinIconUrl(symbol),
              width: 24,
              height: 24,
              errorWidget: (context, url, error) => Text(
                CoinImageHelper.getCoinSymbolText(symbol),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(baseAsset),
          const SizedBox(width: 8),
          Text(
            symbol,
            style: context.theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
