import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/emoji_catalog.g.dart';
import 'package:fujin/pages/common/sheet_frame.dart';

Future<String?> showEmojiSheet(BuildContext context) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      showDragHandle: false,
      sheetAnimationStyle: FujinMotion.sheet,
      builder: (context) => SheetFrame.handled(const EmojiSheet()),
    );

class EmojiSheet extends HookWidget {
  const EmojiSheet({super.key});

  static const double _share = 0.6;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final group = useState(0);
    const groups = EmojiCatalog.groups;
    final emojis = groups[group.value];
    final navigator = Navigator.of(context);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * _share,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetFrame.inset(
            Text(
              context.intl.chatMoreEmoji,
              style: FujinText.hina24.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(height: FujinSpace.s3),
          SizedBox(
            height: FujinSize.emojiTab,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: FujinSize.screenMargin,
              ),
              children: [
                for (final (index, members) in groups.indexed)
                  Semantics(
                    button: true,
                    selected: index == group.value,
                    child: InkResponse(
                      onTap: () => group.value = index,
                      radius: FujinSize.emojiTab / 2,
                      child: Container(
                        width: FujinSize.emojiTab,
                        height: FujinSize.emojiTab,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          shape: const CircleBorder(),
                          color: switch (index == group.value) {
                            true => colors.backgroundNeutral,
                            false => null,
                          },
                        ),
                        child: Text(
                          members.first,
                          style: FujinText.inter20Regular,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: FujinSpace.s2),
          Expanded(
            child: GridView.builder(
              key: ValueKey(group.value),
              padding: EdgeInsets.fromLTRB(
                FujinSize.screenMargin,
                0,
                FujinSize.screenMargin,
                MediaQuery.paddingOf(context).bottom + FujinSpace.s3,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: FujinSize.emojiCell,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) => Semantics(
                button: true,
                label: emojis[index],
                excludeSemantics: true,
                child: InkResponse(
                  onTap: () => navigator.pop(emojis[index]),
                  radius: FujinSize.emojiCell / 2,
                  child: Center(
                    child: Text(
                      emojis[index],
                      style: FujinText.hina24.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
