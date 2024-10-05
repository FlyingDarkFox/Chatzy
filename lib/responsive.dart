

import 'config.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop help us later
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 900;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1500 && MediaQuery.of(context).size.width >= 900;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 900;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (size.width >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (size.width >= 850 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }

  static double get logicalWidth => (View.of(Get.context!).physicalSize / View.of(Get.context!).devicePixelRatio).width;
  static double get logicalHeight => (View.of(Get.context!).physicalSize / View.of(Get.context!).devicePixelRatio).height;

  static bool get isSm => logicalWidth < 850;
  static bool get isMd => logicalWidth < 1100 && logicalWidth >= 850;
  static bool get isLg => logicalWidth >= 1100;
}
