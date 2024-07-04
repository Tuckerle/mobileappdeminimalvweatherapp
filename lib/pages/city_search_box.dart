import 'package:flutter/material.dart';

class CitySearchBox extends StatefulWidget {
  final Function(String) onCitySelected;

  const CitySearchBox({super.key, required this.onCitySelected});

  @override
  _CitySearchBoxState createState() => _CitySearchBoxState();
}

class _CitySearchBoxState extends State<CitySearchBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,  // Set the background color to black
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add a City',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    ),
                    borderSide: BorderSide(color: Theme.of(context).scaffoldBackgroundColor),  // Unfocused border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    ),
                    borderSide: BorderSide(color: Theme.of(context).scaffoldBackgroundColor),  // Unfocused border color
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                if (_controller.text.isNotEmpty) {
                  widget.onCitySelected(_controller.text);
                  _controller.clear();
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(Icons.search, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}