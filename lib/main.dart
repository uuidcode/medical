import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
      title: 'Medical Report',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Medical Report'),
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
        MedicalCost medicalCost = MedicalCost.of();
        medicalCost.init(_info!);
        medicalCost.drawPage1();
        medicalCost.drawPage2();
        medicalCost.drawPersonAgreement();
        medicalCost.drawOwnerAgreement();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: new EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              iconSize: 30,
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
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
