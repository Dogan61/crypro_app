import 'package:crypto_mobil/core/extension/x_build_context.dart';
import 'package:crypto_mobil/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class WatchListTitle extends StatelessWidget {
  const WatchListTitle({
    required this.headerText,
    required this.buttonText,
    super.key,
  });

  final String headerText;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headerText,
          style: context.theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: null,
          child: Text(
            buttonText,
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
