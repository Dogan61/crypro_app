import 'package:crypto_mobil/core/constants/text_const.dart';
import 'package:flutter/material.dart';

class RecentSearchCard extends StatelessWidget {
  const RecentSearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3A2A15),
              border: Border.all(color: const Color(0xFFB87333), width: 1.2),
            ),
            child: const Center(
              child: Text(
                '₿',
                style: TextStyle(
                  color: Color(0xFFFF9900),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextConst.bitcoin,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  TextConst.btc,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.grey,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
