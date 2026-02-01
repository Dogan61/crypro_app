import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      backgroundColor: WidgetStatePropertyAll(
        AppColors.glassBg.withOpacity(0.9),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      hintText: TextConst.searchHint,
      hintStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
      leading: const IconButton(
        icon: Icon(Icons.search, color: Colors.grey),
        padding: EdgeInsets.only(left: 12),
        onPressed: null,
      ),
      trailing: const [
        IconButton(
          icon: Icon(Icons.mic, color: Colors.grey),
          padding: EdgeInsets.only(right: 12),
          onPressed: null,
        ),
      ],
    );
  }
}
