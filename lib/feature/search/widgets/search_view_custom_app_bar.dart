import 'package:crypto_app/core/constants/image_const.dart';
import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/extension/x_build_context.dart';
import 'package:flutter/material.dart';

class SearchViewCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SearchViewCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xff101622),
      title: Text(
        TextConst.searchAssetsTitle,
        style: context.theme.textTheme.headlineMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: NetworkImage(ImageConst.avatar),
        ),
      ],
      actionsPadding: const EdgeInsets.only(right: 16),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
