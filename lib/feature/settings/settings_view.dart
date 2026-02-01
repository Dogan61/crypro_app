import 'package:crypto_app/core/constants/text_const.dart';
import 'package:crypto_app/core/navbar/custom_bottom_bar.dart';
import 'package:crypto_app/feature/settings/widgets/glass_switch_tile.dart';
import 'package:crypto_app/feature/settings/widgets/glass_tile.dart';
import 'package:crypto_app/feature/settings/widgets/profile_header_card.dart';
import 'package:crypto_app/feature/settings/widgets/settings_custom_app_bar.dart';
import 'package:crypto_app/feature/settings/widgets/settings_section_title.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SettingsCustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeaderCard(),
            SizedBox(height: 8),
            SettingsSectionTitle(title: TextConst.sectionAccount),
            GlassTile(icon: Icons.person, title: TextConst.tilePersonalInfo),
            GlassTile(
              icon: Icons.credit_card,
              title: TextConst.tileSubscription,
            ),
            SizedBox(height: 24),
            SettingsSectionTitle(title: TextConst.sectionSecurity),
            GlassTile(
              icon: Icons.lock_reset,
              title: TextConst.tileChangePassword,
            ),
            GlassTile(icon: Icons.phonelink_lock, title: TextConst.tile2FA),
            GlassSwitchTile(icon: Icons.face, title: TextConst.tileFaceID),
            SizedBox(height: 24),
            SettingsSectionTitle(title: TextConst.sectionPreferences),
            GlassTile(
              icon: Icons.currency_exchange,
              title: TextConst.tileBaseCurrency,
              trailingText: TextConst.baseCurrencyUSD,
            ),
            GlassSwitchTile(
              icon: Icons.notifications,
              title: TextConst.tileNotifications,
            ),
            GlassTile(
              icon: Icons.palette,
              title: TextConst.tileAppearance,
              trailingText: TextConst.appearanceSystem,
            ),
            SizedBox(height: 24),
            SettingsSectionTitle(title: TextConst.sectionSupport),
            GlassTile(icon: Icons.help, title: TextConst.tileHelp),
            GlassTile(icon: Icons.bug_report, title: TextConst.tileReportBug),
            GlassTile(icon: Icons.gavel, title: TextConst.tileTermsPrivacy),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
