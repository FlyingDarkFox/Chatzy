import 'dart:developer';

import 'package:chatzy_web/widgets/reaction_pop_up/emoji_picker_widget.dart';
import 'package:chatzy_web/widgets/reaction_pop_up/reaction_config.dart';

import '../../config.dart';
import '../../utils/general_utils.dart';

class EmojiRow extends StatelessWidget {
  EmojiRow({
    Key? key,
    required this.onEmojiTap,
    this.emojiConfiguration,
  }) : super(key: key);

  /// Provides callback when user taps on emoji in reaction pop-up.
  final StringCallback onEmojiTap;

  /// Provides configuration of emoji's appearance in reaction pop-up.
  final EmojiConfiguration? emojiConfiguration;

  /// These are default emojis.
  final List<String> _emojiUnicodes = [
    heart,
    faceWithTears,
    astonishedFace,
    disappointedFace,
    angryFace,
    thumbsUp,
  ];

  @override
  Widget build(BuildContext context) {
    final emojiList = emojiConfiguration?.emojiList ?? _emojiUnicodes;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  emojiList.length,
                  (index) => InkWell(
                      onTap: () {
                        onEmojiTap(emojiList[index]);
                        log("CHECK `:${emojiList[index]}");
                      },
                      child: Text(
                        emojiList[index],
                        style: const TextStyle(fontSize: FontSize.f20),
                      ).marginOnly(right: Insets.i10,top: Insets.i8,bottom: Insets.i8)))),
          InkWell(
            child: SvgPicture.asset(eSvgAssets.addCircle),
            onTap: () => _showBottomSheet(context),
          )
        ],
      )
    );
  }

  void _showBottomSheet(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        builder: (context) => EmojiPickerWidget(onSelected: (emoji) {
          Navigator.pop(context);
          log("emoji : ${emoji.codeUnits}");
          log("emoji : ${emoji.characters}");
          onEmojiTap(emoji);
        }),
      );
}
