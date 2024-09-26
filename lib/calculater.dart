import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myapps extends StatefulWidget {
  const myapps({super.key});

  @override
  State<myapps> createState() => _myappsState();
}

// ignore: camel_case_types
class _myappsState extends State<myapps> {
  String displayvalue = "";
  String calculationvalue = "";
  String first = "";
  bool isReplace = false;

  void calculateResult({required String buttonName}) {
    setState(() {
      if (buttonName == 'c') {
        displayvalue = '';
        calculationvalue = '';
        isReplace = false;
      } else if (buttonName == 'x') {
        displayvalue = displayvalue.substring(0, displayvalue.length - 1);
      } else if (buttonName == '*' ||
          buttonName == '+' ||
          buttonName == '-' ||
          buttonName == '/' ||
          buttonName == '%') {
        if (displayvalue.isNotEmpty && calculationvalue.isEmpty) {
          calculationvalue = displayvalue + buttonName;
        } else if (calculationvalue.isNotEmpty) {
          String operator = calculationvalue[calculationvalue.length - 1];

          num first = double.parse(
              calculationvalue.substring(0, calculationvalue.length - 1));
          num secound = double.parse(displayvalue);
          num? result;
          if (operator == '+') {
            result = first + secound;
            displayvalue = result.toString();
            calculationvalue = "$result $buttonName";
          } else if (operator == '-') {
            result = first - secound;
            displayvalue = result.toString();
            calculationvalue = "$result $buttonName ";
          } else if (operator == '/') {
            result = first + secound;
            displayvalue = result.toString();
            calculationvalue = "$result $buttonName ";
          } else if (operator == '*') {
            result = first * secound;
            displayvalue = result.toString();
            calculationvalue = "$result $buttonName ";
          } else if (operator == '%') {
            result = first / 100;
            displayvalue = result.toString();
            calculationvalue = "$result $buttonName ";
          }
          isReplace = false;
        }
      } else if (buttonName == '=') {
        if (calculationvalue.endsWith('+') ||
            calculationvalue.endsWith('*') ||
            calculationvalue.endsWith('/') ||
            calculationvalue.endsWith('-') ||
            calculationvalue.endsWith('%')) {
          String operator = calculationvalue[calculationvalue.length - 1];

          num first = num.parse(
              calculationvalue.substring(0, calculationvalue.length - 1));
          num secound = num.parse(displayvalue);
          num? result;
          if (operator == '+') {
            result = first + secound;
            displayvalue = result.toString();
            calculationvalue = "$first $operator $secound=";
          } else if (operator == '-') {
            result = first - secound;
            displayvalue = result.toString();
            calculationvalue = "$first $operator $secound=";
          } else if (operator == '/') {
            result = first / secound;
            displayvalue = result.toString();
            calculationvalue = "$first $operator $secound=";
          } else if (operator == '*') {
            result = first * secound;
            displayvalue = result.toString();
            calculationvalue = "$first $operator $secound=";
          } else if (operator == '%') {
            result = first / 100;
            displayvalue = result.toString();
            calculationvalue = "$first $operator 100 =";
          }
          saveData();
        }
      } else if (buttonName == '*' ||
          buttonName == '+' ||
          buttonName == '-' ||
          buttonName == '/') {
        calculationvalue = displayvalue + buttonName;
      } else if (int.tryParse(buttonName) != null) {
        if (calculationvalue.endsWith('+') ||
            calculationvalue.endsWith('*') ||
            calculationvalue.endsWith('/') ||
            calculationvalue.endsWith('-') ||
            calculationvalue.endsWith('%')) {
          if (isReplace) {
            displayvalue = displayvalue + buttonName;
          } else {
            displayvalue = buttonName;
            isReplace = true;
          }
        } else if (calculationvalue.endsWith('=')) {
          calculationvalue = "";
          displayvalue = buttonName;
          isReplace = false;
        } else {
          displayvalue = displayvalue + buttonName;
        }
      }
    });
  }

  Future<void> saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int valueCount = 1;
    if (prefs.containsKey('count')) {
      valueCount = prefs.getInt('count')!;
      prefs.setInt("count", valueCount + 1);
    } else {
      prefs.setInt("count", 1);
    }
    prefs.setString('val_$valueCount', '$calculationvalue $displayvalue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              height: 30,
            ),
            IconButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                int count = prefs.getInt("count")!;
                List<ListTile> calHistory = [];
                for (int i = 1; i < count; i++) {
                  prefs.getString('val_$i');
                  calHistory.add(
                    ListTile(
                      title: Text(
                        "${prefs.getString("val_$i")}",
                        style: const TextStyle(color: Colors.black),
                      ),
                      tileColor: Colors.green,
                    ),
                  );
                }
                showModalBottomSheet(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (context) => ListView(children: calHistory),
                );
              },
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 90,
            ),
            Text(
              calculationvalue,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              displayvalue,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    button(buttonName: "mc"),
                    button(buttonName: "c"),
                    button(buttonName: "7"),
                    button(buttonName: "4"),
                    button(buttonName: "1"),
                    button(buttonName: "%"),
                  ],
                ),
                Column(
                  children: [
                    button(buttonName: "m+"),
                    button(buttonName: "x"),
                    button(buttonName: "8"),
                    button(buttonName: "5"),
                    button(buttonName: "2"),
                    button(buttonName: "0"),
                  ],
                ),
                Column(
                  children: [
                    button(buttonName: "m-"),
                    button(buttonName: "/", isColor: true, isOperation: true),
                    button(buttonName: "9"),
                    button(buttonName: "6"),
                    button(buttonName: "3"),
                    button(buttonName: "."),
                  ],
                ),
                Column(
                  children: [
                    button(buttonName: "mr"),
                    button(buttonName: "*", isColor: true, isOperation: true),
                    button(buttonName: "-", isColor: true, isOperation: true),
                    button(buttonName: "+", isColor: true, isOperation: true),
                    button(buttonName: "=", isEqullButton: true, isColor: true),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell button({
    required String buttonName,
    isEqullButton = false,
    isColor = false,
    isOperation = false,
    Function()? buttontapped,
  }) {
    return InkWell(
      onTap: () {
        calculateResult(buttonName: buttonName);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 60,
          height: isEqullButton ? 136 : 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isColor ? Colors.green : Colors.grey),
          child: Center(
            child: Text(
              buttonName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
