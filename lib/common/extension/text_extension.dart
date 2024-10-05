

import 'dart:math';

import 'package:flutter/cupertino.dart';


extension StyledText<T extends Text> on T {
  T copyWith({
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis, TextDecoration? textDecoration,
  }) =>
      Text(
        data ?? this.data ?? "",
        style: style ?? this.style,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        locale: locale ?? this.locale,
        maxLines: maxLines ?? this.maxLines,
        overflow: overflow ?? this.overflow,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        softWrap: softWrap ?? this.softWrap,
        textDirection: textDirection ?? this.textDirection,
        textWidthBasis: textWidthBasis ?? this.textWidthBasis,


      ) as T;

  T textStyle(TextStyle style) => copyWith(
        style: (this.style ?? const TextStyle()).copyWith(
          background: style.background,
          backgroundColor: style.backgroundColor,
          color: style.color,
          debugLabel: style.debugLabel,
          decoration: style.decoration,
          decorationColor: style.decorationColor,
          decorationStyle: style.decorationStyle,
          decorationThickness: style.decorationThickness,
          fontFamily: style.fontFamily,
          fontFamilyFallback: style.fontFamilyFallback,
          fontFeatures: style.fontFeatures,
         fontSize: style.fontSize,
          fontStyle: style.fontStyle,
          fontWeight: style.fontWeight,
          foreground: style.foreground,
          height: style.height,
          inherit: style.inherit,
          letterSpacing: style.letterSpacing,
          locale: style.locale,
          shadows: style.shadows,
          textBaseline: style.textBaseline,
          wordSpacing: style.wordSpacing,
        ),
      );

  T textScale(double scaleFactor) => copyWith(textScaleFactor: scaleFactor);

  T bold() => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
        ),
      );


  T fontWeight(FontWeight fontWeight) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontWeight: fontWeight,
        ),
      );

  T appFontSize(double size) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontSize: size,
        ),
      );

  T fontFamily(String font) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontFamily: font.toString(),
        ),
      );

  T letterSpacing(double space) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          letterSpacing: space,
        ),
      );

  T wordSpacing(double space) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          wordSpacing: space,
        ),
      );

  T textOverflow(TextOverflow overflow) => copyWith(
    style: (style ?? const TextStyle()).copyWith(
      overflow: overflow,
    ),
  );

  T textShadow({
    Color color = const Color(0x33000000),
    double blurRadius = 0.0,
    Offset offset = Offset.zero,
  }) =>
      copyWith(
        style: (style ?? const TextStyle()).copyWith(
          shadows: [
            Shadow(
              color: color,
              blurRadius: blurRadius,
              offset: offset,
            ),
          ],
        ),
      );

  double _elevationOpacityCurve(double x) => pow(x, 1 / 16) / sqrt(pow(x, 2) + 2) + 0.2;

  T textElevation(
    double elevation, {
    double angle = 0.0,
    Color color = const Color(0x33000000),
    double opacityRatio = 1.0,
  }) {
    double calculatedOpacity = _elevationOpacityCurve(elevation) * opacityRatio;

    Shadow shadow = Shadow(
      color: color.withOpacity(calculatedOpacity),
      blurRadius: elevation,
      offset: Offset(sin(angle) * elevation, cos(angle) * elevation),
    );
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        shadows: [
          shadow,
        ],
      ),
    );
  }

  T textColor(Color color) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          color: color,
        ),
      );

  T textAlignment(TextAlign align) => copyWith(textAlign: align);

  T textDecoration(TextDecoration textDecoration) => copyWith(textDecoration: textDecoration);

  T textDirection(TextDirection direction) => copyWith(textDirection: direction);

  T textBaseline(TextBaseline textBaseline) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          textBaseline: textBaseline,
        ),
      );

  T textWidthBasis(TextWidthBasis textWidthBasis) => copyWith(textWidthBasis: textWidthBasis);
}
