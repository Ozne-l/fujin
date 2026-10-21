import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_spinner.dart';
import 'package:fujin/pages/common/scan_icon.dart';

class BarcodeCard extends StatelessWidget {
  const BarcodeCard({
    required this.format,
    required this.running,
    required this.onTap,
    super.key,
  });

  final String format;
  final bool running;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(FujinRadius.card),
      side: BorderSide(
        color: context.colors.textLink,
        width: FujinStroke.fieldFocus,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      child: Material(
        color: context.colors.backgroundCard,
        shape: shape,
        child: InkWell(
          onTap: switch (running) {
            true => null,
            false => onTap,
          },
          customBorder: shape,
          child: Padding(
            padding: const EdgeInsets.all(FujinSpace.s4),
            child: Row(
              spacing: FujinSpace.s3,
              children: [
                CircleAvatar(
                  radius: FujinSize.tile / 2,
                  backgroundColor: context.colors.backgroundSuccess,
                  child: SvgPicture.asset(
                    ScanIcon.asset,
                    width: FujinSize.searchIcon,
                    height: FujinSize.searchIcon,
                    theme: SvgTheme(
                      currentColor: context.colors.textLink,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: FujinSpace.s1,
                    children: [
                      Text(
                        context.intl.addSearchBarcode,
                        style: FujinText.inter15Medium.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                      Text(
                        context.intl.addBarcodeValid(format),
                        style: FujinText.inter12Regular.copyWith(
                          color: context.colors.textLink,
                        ),
                      ),
                    ],
                  ),
                ),
                switch (running) {
                  true => const FujinSpinner.card(),
                  false => Icon(
                    Icons.chevron_right,
                    size: FujinSize.rowChevron,
                    color: context.colors.textSecondary,
                  ),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}
