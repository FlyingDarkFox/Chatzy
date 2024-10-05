
import 'dart:developer';

import 'package:chatzy_web/widgets/reaction_pop_up/emoji_row.dart';
import 'package:chatzy_web/widgets/reaction_pop_up/glass_morphism_reaction.dart';
import 'package:chatzy_web/widgets/reaction_pop_up/reaction_config.dart';

import '../../config.dart';
import '../../utils/general_utils.dart';

class ReactionPopup extends StatefulWidget {
  const ReactionPopup({
    Key? key,
    this.reactionPopupConfig,this.onEmojiTap,
    required this.showPopUp,

  }) : super(key: key);

  /// Provides configuration of reaction pop-up appearance.
  final ReactionPopupConfiguration? reactionPopupConfig;

  /// Provides call back when user taps on reaction pop-up.
  final StringCallback? onEmojiTap;
  /// Represents should pop-up show or not.
  final bool showPopUp;

  @override
  ReactionPopupState createState() => ReactionPopupState();
}

class ReactionPopupState extends State<ReactionPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  ReactionPopupConfiguration? get reactionPopupConfig =>
      widget.reactionPopupConfig;

  bool get showPopUp => widget.showPopUp;
  double yCoordinate = 0.0;
  double xCoordinate = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimationControllers();
  }

  void _initializeAnimationControllers() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.reactionPopupConfig?.animationDuration ??
          const Duration(milliseconds: 180),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeInOutSine,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {

    if (showPopUp) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    return showPopUp
        ? Align(
alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: reactionPopupConfig?.showGlassMorphismEffect ?? false
              ? GlassMorphismReactionPopup(
            reactionPopupConfig: reactionPopupConfig,
            child: _reactionPopupRow,
          )
              : AnimatedContainer(duration: const Duration(seconds: 2),
            constraints: BoxConstraints(
                maxWidth: reactionPopupConfig?.maxWidth ?? 350,maxHeight: reactionPopupConfig?.maxWidth ??  40),
            margin: reactionPopupConfig?.margin ??
                const EdgeInsets.symmetric(horizontal: 25),
            padding: reactionPopupConfig?.padding ??
                const EdgeInsets.symmetric(

                  horizontal: 14,
                ),
            decoration: BoxDecoration(
              color: reactionPopupConfig?.backgroundColor ??
                  appCtrl.appTheme.primary,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                reactionPopupConfig?.shadow ??
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 8,
                      spreadRadius: -2,
                      offset: const Offset(0, 8),
                    )
              ],
            ),
            child: _reactionPopupRow,
          ),
        ),
      ),
    )
        : const SizedBox.shrink();
  }

  Widget get _reactionPopupRow => EmojiRow(
    onEmojiTap:(p0) => widget.onEmojiTap!(p0),
    emojiConfiguration: reactionPopupConfig?.emojiConfig,
  );


  void refreshWidget({
    required String message,
    required double xCoordinate,
    required double yCoordinate,
  }) {
    setState(() {
      log("_xCoordinate : $xCoordinate");
      message = message;
      xCoordinate = xCoordinate;
      yCoordinate = yCoordinate;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}