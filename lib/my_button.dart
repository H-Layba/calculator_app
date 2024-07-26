import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Function onPress;
  final Color color;

  const MyButton({
    Key? key,
    required this.title,
    required this.onPress,
    this.color = const Color(0xff323232),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onPress(),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, color: Colors.white), // Updated text color
          ),
        ),
      ),
    );
  }
}