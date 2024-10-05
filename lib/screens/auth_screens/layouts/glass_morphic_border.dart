import '../../../../config.dart';

class GlassMorphicBorder extends StatelessWidget {

  final double _radius;
  final double? width;
  final double? height;
  const GlassMorphicBorder({super.key,
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    this.height,
    this.width,
  })  :
        _radius = radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
      ),
      width: width,
      height: height,
    );
  }
}