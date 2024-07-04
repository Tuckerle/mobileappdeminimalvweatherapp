import 'package:flutter/material.dart';
import 'package:weather_app/theme/theme_switcher.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings".toUpperCase()),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: ThemeSwitcher.of(context).isDarkMode,
              onChanged: ThemeSwitcher.of(context).switchTheme,
            ),
            // Text(
            //   'Units of Measurement',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            // DropdownButton<String>(
            //   value: 'Metric',
            //   onChanged: null,
            //   items: <String>['Metric', 'Imperial']
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            // ),
          ],
        ),
      ),
    );
  }
}