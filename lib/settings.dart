import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Color themeColor;
  final double fontSize;

  const SettingsPage({Key? key, required this.themeColor, required this.fontSize}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Color _selectedColor;
  late double _selectedFontSize;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.themeColor;
    _selectedFontSize = widget.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Theme Color', style: TextStyle(fontSize: 20)),
              Row(
                children: [
                  _colorButton(Colors.deepPurple),
                  _colorButton(Colors.red),
                  _colorButton(Colors.green),
                  _colorButton(Colors.blue),
                ],
              ),
              SizedBox(height: 20),
              Text('Font Size', style: TextStyle(fontSize: 20)),
              Slider(
                value: _selectedFontSize,
                min: 20,
                max: 40,
                divisions: 10,
                label: _selectedFontSize.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _selectedFontSize = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'themeColor': _selectedColor,
                    'fontSize': _selectedFontSize,
                  });
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}
