import 'package:flutter/material.dart';


var initialThemeData = _switchTheme(false);



ThemeData _switchTheme(bool dark) {
  Color foregroundColor = dark ? Colors.white : Colors.black;
  Color backgroundColor = dark ? Colors.black : Colors.white;
  TextStyle textStyle = TextStyle(color: foregroundColor);
  return ThemeData(
    brightness: dark ? Brightness.dark : Brightness.light,
    primaryColor: foregroundColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: TextTheme(
      displayLarge: textStyle,
      displayMedium: textStyle,
      displaySmall: textStyle,
      headlineMedium: TextStyle(color: foregroundColor, fontSize: 18, fontWeight: FontWeight.w500),
      headlineSmall: TextStyle(color: foregroundColor, fontSize: 14, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(color: foregroundColor),
      bodyMedium: TextStyle(color: foregroundColor),
      bodyLarge: TextStyle(color: foregroundColor),
      bodySmall: TextStyle(color: foregroundColor, fontSize: 13),
    ),
  );
}

class ThemeSwitcher extends InheritedWidget {
  final _ThemeSwitcherWidgetState data;

  const ThemeSwitcher({
    super.key,
    required this.data,
    required super.child,
  });

  static _ThemeSwitcherWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>()
            as ThemeSwitcher)
        .data;
  }

  @override
  bool updateShouldNotify(ThemeSwitcher old) {
    return this != old;
  }
}

class ThemeSwitcherWidget extends StatefulWidget {
  final ThemeData initialTheme;
  final Widget child;

  const ThemeSwitcherWidget(
      {super.key, required this.initialTheme, required this.child});

  @override
  _ThemeSwitcherWidgetState createState() => _ThemeSwitcherWidgetState();
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget> {
  late ThemeData themeData = initialThemeData;
  bool isDarkMode = false;

  void switchTheme(bool dark) {
    ThemeData theme = _switchTheme(dark);
    setState(() {
      themeData = theme;
      isDarkMode = dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      data: this,
      child: widget.child,
    );
  }
}
