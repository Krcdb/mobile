import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _expression = "0";
  String _result = "0";
  bool _isResultPresed = false;

  void _onButtonPressed(String value) {
  setState(() {
    if (value == "C") {
      _expression = (_expression.length > 1) 
          ? _expression.substring(0, _expression.length - 1) 
          : "0";
    } 
    else if (value == "AC") {
      _expression = "0";
      _result = "0";
    } 
    else if (value == "=") {
      try {
        _result = _expression.interpret().toString();
      } catch (e) {
        _result = "Error";
      }
      _isResultPresed = true;
    } 
    else {
      if (_isResultPresed) {
        _expression = "0";
        _isResultPresed = false;
      }
      _expression = (_expression == "0") ? value : _expression + value;
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_expression, style: TextStyle(fontSize: 32, color: Colors.green)),
                  Text(_result, style: TextStyle(fontSize: 48, color: Colors.green)),
                ],
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            itemCount: buttons.length,
            itemBuilder: (BuildContext context, int index) {
              return CalculatorButton(
                label: buttons[index],
                onTap: () {
                  _onButtonPressed(buttons[index]);
                },
              );
            },
          ),
        ]
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CalculatorButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.grey[900]!),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

const List<String> buttons = [
  "7", "8", "9", "C", "AC",
  "4", "5", "6", "+", "-",
  "1", "2", "3", "*", "/",
  "0", ".", "00", "="
];
