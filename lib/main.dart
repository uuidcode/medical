import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:medical/Info.dart';
import 'package:medical/person.dart';

import 'medicalCost.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Cost',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Medical Cost'),
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
  final TextEditingController _controller = TextEditingController();
  String? _selectedValue;
  Info? _info;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/info.json').then((json) {
      setState(() {
        print(json);
        _info = Info.fromJson(jsonDecode(json));
         _selectedValue = _info?.personList?.first.name;
      });
    });
  }

  void _incrementCounter() {
    setState(() {
        _info!.name = _controller.text;
        _info!.personName = _selectedValue;
        MedicalCost.of(_info!).create();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DropdownButton<String>(
              itemHeight: 80,
              iconSize: 40,
              isExpanded: true,
              value: _selectedValue,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValue = newValue;
                });
              },
              items:
              _info?.personList?.map<String>((Person p) {
                  return p.name!;
                })
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
            }).toList(),
            ),
            TextField(
              controller: _controller,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold)
            ),
            ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 30),
                    minimumSize: const Size(200, 60)),
              child: const Text("만들기"),
            )
          ],
        ),
      ),
    );
  }
}
