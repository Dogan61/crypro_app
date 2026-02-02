import 'package:crypto_mobil/core/constants/image_const.dart';
import 'package:crypto_mobil/core/constants/text_const.dart';
import 'package:crypto_mobil/core/extension/x_build_context.dart';
import 'package:crypto_mobil/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class WatchListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WatchListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      leading: const Padding(
        padding: EdgeInsets.only(left: 12),
        child: CircleAvatar(
          backgroundImage: NetworkImage(ImageConst.avatar),
        ),
      ),
      title: Text(
        TextConst.watchlistTitle,
        style: context.theme.textTheme.headlineMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 16),
      actions: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
