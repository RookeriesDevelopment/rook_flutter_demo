import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3e6837),
      surfaceTint: Color(0xff3e6837),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffbff0b1),
      onPrimaryContainer: Color(0xff275021),
      secondary: Color(0xff53634e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd6e8cd),
      onSecondaryContainer: Color(0xff3c4b37),
      tertiary: Color(0xff386569),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbcebef),
      onTertiaryContainer: Color(0xff1e4d51),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff8fbf1),
      onSurface: Color(0xff191d17),
      onSurfaceVariant: Color(0xff42493f),
      outline: Color(0xff73796e),
      outlineVariant: Color(0xffc2c8bc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e322b),
      inversePrimary: Color(0xffa4d397),
      primaryFixed: Color(0xffbff0b1),
      onPrimaryFixed: Color(0xff002201),
      primaryFixedDim: Color(0xffa4d397),
      onPrimaryFixedVariant: Color(0xff275021),
      secondaryFixed: Color(0xffd6e8cd),
      onSecondaryFixed: Color(0xff111f0f),
      secondaryFixedDim: Color(0xffbbccb2),
      onSecondaryFixedVariant: Color(0xff3c4b37),
      tertiaryFixed: Color(0xffbcebef),
      onTertiaryFixed: Color(0xff002022),
      tertiaryFixedDim: Color(0xffa0cfd2),
      onTertiaryFixedVariant: Color(0xff1e4d51),
      surfaceDim: Color(0xffd8dbd2),
      surfaceBright: Color(0xfff8fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f5eb),
      surfaceContainer: Color(0xffecefe5),
      surfaceContainerHigh: Color(0xffe6e9e0),
      surfaceContainerHighest: Color(0xffe0e4da),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff163e12),
      surfaceTint: Color(0xff3e6837),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4d7744),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2c3a28),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff62715c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff073c40),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff477478),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8fbf1),
      onSurface: Color(0xff0e120d),
      onSurfaceVariant: Color(0xff32382f),
      outline: Color(0xff4e544b),
      outlineVariant: Color(0xff696f65),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e322b),
      inversePrimary: Color(0xffa4d397),
      primaryFixed: Color(0xff4d7744),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff355e2e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff62715c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4a5945),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff477478),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2e5c5f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc4c8bf),
      surfaceBright: Color(0xfff8fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f5eb),
      surfaceContainer: Color(0xffe6e9e0),
      surfaceContainerHigh: Color(0xffdbded5),
      surfaceContainerHighest: Color(0xffcfd3ca),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0a3408),
      surfaceTint: Color(0xff3e6837),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff295223),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff22301e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3e4d3a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003235),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff215053),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8fbf1),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff282e25),
      outlineVariant: Color(0xff454b42),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e322b),
      inversePrimary: Color(0xffa4d397),
      primaryFixed: Color(0xff295223),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff123b0f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3e4d3a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff283624),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff215053),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff02393c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb6bab1),
      surfaceBright: Color(0xfff8fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff2e8),
      surfaceContainer: Color(0xffe0e4da),
      surfaceContainerHigh: Color(0xffd2d6cc),
      surfaceContainerHighest: Color(0xffc4c8bf),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa4d397),
      surfaceTint: Color(0xffa4d397),
      onPrimary: Color(0xff0f380c),
      primaryContainer: Color(0xff275021),
      onPrimaryContainer: Color(0xffbff0b1),
      secondary: Color(0xffbbccb2),
      onSecondary: Color(0xff263422),
      secondaryContainer: Color(0xff3c4b37),
      onSecondaryContainer: Color(0xffd6e8cd),
      tertiary: Color(0xffa0cfd2),
      onTertiary: Color(0xff00363a),
      tertiaryContainer: Color(0xff1e4d51),
      onTertiaryContainer: Color(0xffbcebef),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff11140f),
      onSurface: Color(0xffe0e4da),
      onSurfaceVariant: Color(0xffc2c8bc),
      outline: Color(0xff8c9387),
      outlineVariant: Color(0xff42493f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4da),
      inversePrimary: Color(0xff3e6837),
      primaryFixed: Color(0xffbff0b1),
      onPrimaryFixed: Color(0xff002201),
      primaryFixedDim: Color(0xffa4d397),
      onPrimaryFixedVariant: Color(0xff275021),
      secondaryFixed: Color(0xffd6e8cd),
      onSecondaryFixed: Color(0xff111f0f),
      secondaryFixedDim: Color(0xffbbccb2),
      onSecondaryFixedVariant: Color(0xff3c4b37),
      tertiaryFixed: Color(0xffbcebef),
      onTertiaryFixed: Color(0xff002022),
      tertiaryFixedDim: Color(0xffa0cfd2),
      onTertiaryFixedVariant: Color(0xff1e4d51),
      surfaceDim: Color(0xff11140f),
      surfaceBright: Color(0xff363a34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff191d17),
      surfaceContainer: Color(0xff1d211b),
      surfaceContainerHigh: Color(0xff272b25),
      surfaceContainerHighest: Color(0xff32362f),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb9e9ab),
      surfaceTint: Color(0xffa4d397),
      onPrimary: Color(0xff032d03),
      primaryContainer: Color(0xff709c65),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd0e1c7),
      onSecondary: Color(0xff1b2918),
      secondaryContainer: Color(0xff85957e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb6e5e9),
      onTertiary: Color(0xff002b2d),
      tertiaryContainer: Color(0xff6b989c),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff11140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd8ded2),
      outline: Color(0xffaeb4a8),
      outlineVariant: Color(0xff8c9287),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4da),
      inversePrimary: Color(0xff285122),
      primaryFixed: Color(0xffbff0b1),
      onPrimaryFixed: Color(0xff001600),
      primaryFixedDim: Color(0xffa4d397),
      onPrimaryFixedVariant: Color(0xff163e12),
      secondaryFixed: Color(0xffd6e8cd),
      onSecondaryFixed: Color(0xff071406),
      secondaryFixedDim: Color(0xffbbccb2),
      onSecondaryFixedVariant: Color(0xff2c3a28),
      tertiaryFixed: Color(0xffbcebef),
      onTertiaryFixed: Color(0xff001416),
      tertiaryFixedDim: Color(0xffa0cfd2),
      onTertiaryFixedVariant: Color(0xff073c40),
      surfaceDim: Color(0xff11140f),
      surfaceBright: Color(0xff42463f),
      surfaceContainerLowest: Color(0xff050804),
      surfaceContainerLow: Color(0xff1b1f19),
      surfaceContainer: Color(0xff252923),
      surfaceContainerHigh: Color(0xff30342d),
      surfaceContainerHighest: Color(0xff3b3f38),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffccfdbd),
      surfaceTint: Color(0xffa4d397),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa0cf93),
      onPrimaryContainer: Color(0xff000f00),
      secondary: Color(0xffe4f5da),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb7c8ae),
      onSecondaryContainer: Color(0xff030e02),
      tertiary: Color(0xffc9f9fc),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff9ccbcf),
      onTertiaryContainer: Color(0xff000e0f),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff11140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffecf2e5),
      outlineVariant: Color(0xffbfc5b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4da),
      inversePrimary: Color(0xff285122),
      primaryFixed: Color(0xffbff0b1),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa4d397),
      onPrimaryFixedVariant: Color(0xff001600),
      secondaryFixed: Color(0xffd6e8cd),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbbccb2),
      onSecondaryFixedVariant: Color(0xff071406),
      tertiaryFixed: Color(0xffbcebef),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa0cfd2),
      onTertiaryFixedVariant: Color(0xff001416),
      surfaceDim: Color(0xff11140f),
      surfaceBright: Color(0xff4d514a),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1d211b),
      surfaceContainer: Color(0xff2e322b),
      surfaceContainerHigh: Color(0xff393d36),
      surfaceContainerHighest: Color(0xff444841),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
