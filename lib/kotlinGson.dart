import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  String _kotlinCode = '';

  void _convertJsonToKotlin(String jsonString) {
    try {
      final jsonData = json.decode(jsonString);
      String kotlinCode = _generateKotlinVo(jsonData, 'ResponseVOReceiptOrderedListResVO');
      setState(() {
        _kotlinCode = kotlinCode;
      });
    } catch (e) {
      setState(() {
        _kotlinCode = 'Invalid JSON format';
      });
    }
  }

  String _generateKotlinVo(Map<String, dynamic> jsonData, String className) {
    StringBuffer kotlinCode = StringBuffer();

    void generateClass(StringBuffer buffer, Map<String, dynamic> jsonMap, String name) {
      buffer.writeln('data class $name (');
      jsonMap.forEach((key, value) {
        if (value is Map) {
          String nestedClassName = '${name}${key[0].toUpperCase()}${key.substring(1)}';
          generateClass(buffer, jsonMap, nestedClassName);
          buffer.writeln('    val $key: $nestedClassName,');
        } else if (value is List) {
          if (value.isNotEmpty && value[0] is Map) {
            String nestedClassName = '${name}${key[0].toUpperCase()}${key.substring(1, key.length - 1)}';
            generateClass(buffer, value[0], nestedClassName);
            buffer.writeln('    val $key: List<$nestedClassName>,');
          } else {
            buffer.writeln('    val $key: List<String>,'); // Assuming list of strings
          }
        } else {
          buffer.writeln('    val $key: ${_getType(value)},');
        }
      });
      buffer.writeln(')');
      buffer.writeln();
    }

    generateClass(kotlinCode, jsonData, className);

    return kotlinCode.toString();
  }

  String _getType(dynamic value) {
    if (value is int) return 'Int';
    if (value is double) return 'Double';
    if (value is bool) return 'Boolean';
    return 'String';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON to Kotlin VO Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter JSON',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final jsonLine = _controller.text.split("\n");
                for (var element in jsonLine) {
                  String reElemant = element.replaceAll("	string", ': ""')
                      .replaceAll("	integer(\$int32)", ': 0');

                  if(reElemant.indexOf(":") > 0) {
                      String key = reElemant.substring(0, reElemant.indexOf(":"));
                      String value = reElemant.substring(reElemant.indexOf(":"));

                      print('"$key" $value');
                  } else {
                    print("$reElemant");
                  }

                  // print(reElemant);
                }
                // print(_controller.text);

                // _convertJsonToKotlin(_controller.text);
              },
              child: Text('Convert to Kotlin VO'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _kotlinCode,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
