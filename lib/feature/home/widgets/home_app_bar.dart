import 'package:crypto_app/core/constants/image_const.dart';
import 'package:crypto_app/core/constants/text_const.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(ImageConst.avatar),
        ),
        title: const Center(child: Text(TextConst.marketOverview)),
      ),
    );
  }
}
