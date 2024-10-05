import 'dart:ui';


import 'package:chatzy_web/widgets/reaction_pop_up/gradient_painter.dart';
import 'package:chatzy_web/widgets/reaction_pop_up/reaction_config.dart';

import '../../config.dart';

class GlassMorphismReactionPopup extends StatelessWidget {
  const GlassMorphismReactionPopup({
    Key? key,
    required this.child,
    this.reactionPopupConfig,
  }) : super(key: key);

  /// Allow user to assign custom widget which is appeared in glassmorphism
  /// effect.
  final Widget child;

  /// Provides configuration for reaction pop-up appearance.
  final ReactionPopupConfiguration? reactionPopupConfig;

  Color get backgroundColor =>
      reactionPopupConfig?.glassMorphismConfig?.backgroundColor ?? Colors.white;

  double get strokeWidth =>
      reactionPopupConfig?.glassMorphismConfig?.strokeWidth ?? 2;

  Color get borderColor =>
      reactionPopupConfig?.glassMorphismConfig?.borderColor ??
          Colors.grey.shade400;

  double get borderRadius =>
      reactionPopupConfig?.glassMorphismConfig?.borderRadius ?? 30;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints:
          BoxConstraints(maxWidth: reactionPopupConfig?.maxWidth ?? 350),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                backgroundColor.withAlpha(18),
                backgroundColor.withAlpha(18),
              ],
              stops: const <double>[
                0.3,
                0,
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8,
                sigmaY: 16,
              ),
              child: Padding(
                padding: reactionPopupConfig?.padding ??
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                child: child,
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: true,
          child: Padding(
            padding: reactionPopupConfig?.margin ??
                const EdgeInsets.symmetric(horizontal: 25),
            child: CustomPaint(
              painter: GradientPainter(
                strokeWidth: strokeWidth,
                radius: borderRadius,
                borderColor: borderColor,
              ),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: reactionPopupConfig?.maxWidth ?? 350),
                padding: EdgeInsets.symmetric(
                  vertical: reactionPopupConfig?.emojiConfig?.size ?? 28,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(borderRadius),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}