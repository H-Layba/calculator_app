import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'my_button.dart';
import 'settings.dart';
import 'package:flutter/foundation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var userInput = "";
  var answer = "";
  List<String> history = [];
  double memory = 0.0;
  Color themeColor = Colors.deepPurple;
  double fontSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor:Colors.white,
        title: Text('Flutter Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              final settings = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    themeColor: themeColor,
                    fontSize: fontSize,
                  ),
                ),
              );
              if (settings != null) {
                setState(() {
                  themeColor = settings['themeColor'];
                  fontSize = settings['fontSize'];
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          userInput,
                          style: TextStyle(fontSize: fontSize, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        answer,
                        style: TextStyle(fontSize: fontSize, color: Colors.white),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButtonRow(["MC", "MR", "M+", "M-", "MS"], [Colors.green, Colors.green, Colors.green, Colors.green, Colors.green]),
                    buildButtonRow(["AC", "+/-", "%", "/"], [themeColor, themeColor, themeColor, Colors.orange]),
                    buildButtonRow(["7", "8", "9", "x"], [themeColor, themeColor, themeColor, Colors.orange]),
                    buildButtonRow(["4", "5", "6", "-"], [themeColor, themeColor, themeColor, Colors.orange]),
                    buildButtonRow(["1", "2", "3", "+"], [themeColor, themeColor, themeColor, Colors.orange]),
                    buildButtonRow(["0", ".", "DEL", "="], [themeColor, themeColor, themeColor, Colors.orange]),
                    // Adding the "Clear History" button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            history.clear();  // Clear history
                          });
                        },
                        child: Text("Clear History"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Background color
                          foregroundColor: Colors.white, // Text color
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white),
                Container(
                  height: 300, // Adjust this height as necessary
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          history[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildButtonRow(List<String> titles, List<Color> colors) {
    return Row(
      children: List.generate(
        titles.length,
            (index) => MyButton(
          title: titles[index],
          color: colors[index],
          onPress: () {
            setState(() {
              if (titles[index] == "=") {
                equalPress();
              } else {
                handleMemoryFunctions(titles[index]);
                if (titles[index] == "DEL") {
                  if (userInput.isNotEmpty) {
                    userInput = userInput.substring(0, userInput.length - 1);
                  }
                } else if (titles[index] == "AC") {
                  userInput = "";
                  answer = "";
                } else if (!memoryFunctions.contains(titles[index])) {
                  userInput += titles[index];
                }
              }
            });
          },
        ),
      ),
    );
  }

  final List<String> memoryFunctions = ["MC", "MR", "M+", "M-", "MS"];

  void handleMemoryFunctions(String function) {
    setState(() {
      switch (function) {
        case "MC":
          memory = 0.0;
          print("Memory Cleared: $memory");
          break;
        case "MR":
          userInput = memory.toString();
          print("Memory Recalled: $memory");
          break;
        case "M+":
          memory += double.tryParse(answer) ?? 0.0;
          print("Memory Added: $memory");
          break;
        case "M-":
          memory -= double.tryParse(answer) ?? 0.0;
          print("Memory Subtracted: $memory");
          break;
        case "MS":
          memory = double.tryParse(answer) ?? 0.0;
          print("Memory Stored: $memory");
          break;
      }
    });
  }

  void equalPress() async {
    String finalUserInput = userInput.replaceAll('x', '*');
    Parser p = Parser();

    try {
      Expression expression = p.parse(finalUserInput);
      ContextModel contextModel = ContextModel();
      double eval = await compute(evaluateExpression, {'expression': expression, 'contextModel': contextModel});
      setState(() {
        answer = eval.toString();
        history.add('$userInput = $answer');
      });
    } catch (e) {
      setState(() {
        answer = "Error";
      });
    }
  }

  static Future<double> evaluateExpression(Map<String, dynamic> params) async {
    Expression expression = params['expression'];
    ContextModel contextModel = params['contextModel'];
    return expression.evaluate(EvaluationType.REAL, contextModel);
  }
}
