import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    required this.title,
    required this.background,
    required this.titleColor,
    required this.detailColor,
    this.detail,
    super.key,
  });

  final String title;
  final String? detail;
  final Color background;
  final Color titleColor;
  final Color detailColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: FujinSpace.s4,
      vertical: FujinSpace.s3,
    ),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(FujinRadius.field),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: FujinSpace.s1,
      children: [
        Text(title, style: FujinText.inter14Medium.copyWith(color: titleColor)),
        if (detail case final detail?)
          Text(
            detail,
            style: FujinText.inter12Regular.copyWith(color: detailColor),
          ),
      ],
    ),
  );
}
