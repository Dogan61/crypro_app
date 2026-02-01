import 'package:crypto_app/core/constants/image_const.dart';
import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/extension/x_build_context.dart';
import 'package:crypto_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class CoinDetailCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CoinDetailCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.backgroundDark,
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.star))],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(backgroundImage: NetworkImage(ImageConst.avatar)),
          const SizedBox(width: 12),
          const Text(TextConst.bitcoin),
          const SizedBox(width: 8),
          Text(
            TextConst.btc,
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
