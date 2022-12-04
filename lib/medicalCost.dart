import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_save/image_save.dart';
import 'package:medical/person.dart';


import 'Info.dart';
import 'bank.dart';

class MedicalCost {
    final int fontSize = 14;
    final int fontSpace = 19;
    img.Image? image;
    Info? info;
    Person? person;
    Person? owner;
    String? year;
    String? month;
    String? day;
    String? hour;
    String? minute;
    String? second;
    String? millisecond;

    img.BitmapFont? bitmapFont;

    static MedicalCost of(Info info) {
        MedicalCost medicalCost = MedicalCost();
        medicalCost.init(info);
        return medicalCost;
    }

    void create() {
        drawPage0();
        drawPage1();
        drawPage2();
        drawPersonAgreement();
        drawOwnerAgreement();
    }

    MedicalCost init(Info currentInfo) {
        info = currentInfo;
        List<Person> personList = info!.personList!;

        owner = personList.firstWhere((p) => p.owner!);
        person = personList.firstWhere((p) => info!.personName == p.name);

        print(owner!.name);
        print(person!.name);

        year =  DateTime.now().year.toString();
        month = DateTime.now().month.toString();
        day = DateTime.now().day.toString();
        hour = DateTime.now().hour.toString();
        minute = DateTime.now().minute.toString();
        second = DateTime.now().second.toString();

        month = prependZero(month!);
        day = prependZero(day!);
        hour = prependZero(hour!);
        minute = prependZero(minute!);
        second = prependZero(second!);

        print(year);
        print(month);
        print(day);

        return this;
    }

    Future<ByteData> loadAssetFont() async {
        ByteData imageData = await rootBundle.load('assets/batang.zip');
        return imageData;
    }

    void draw(int page, void Function() runnable) async {
        ByteData fBitMapFontData = await loadAssetFont();
        bitmapFont = img.BitmapFont.fromZip(fBitMapFontData.buffer.asUint8List());

        String fileName = '$page.png';
        final byteData = await rootBundle.load('assets/$fileName');
        image = img.decodeImage(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

        runnable();

        var encodeImage = img.encodePng(image!) as Uint8List;

        await ImageSave.saveImage(encodeImage.buffer.asUint8List(), '$year-$month-$day-$hour-$minute-$second-$page.png', albumName: "의료비");
    }

    void drawPage0() {
        draw(0, () {
            int left = 10;
            int top = 10;
            img.drawString(image!, bitmapFont!, left, top, person!.name!);
            img.drawString(image!, bitmapFont!, left, top + 20, info!.name!);
            img.drawString(image!, bitmapFont!, left, top + 40, '$year-$month-$day');
            img.drawString(image!, bitmapFont!, left, top + 60, '$hour:$minute:$second');
        });
    }

    void drawPage1() {
        draw(1, () {
            drawPerson(person!, 150, 95);
            drawPerson(owner!, 150, 169);
            
            drawCheckCost();
            drawCheckDisease();
            drawCheckAgreement();
            
            drawBank(574);
            drawDisease(410);
            drawDate(person!, 725);
        });
    }

    void drawCheckAgreement() {
      drawCheck(491, 633);
    }

    void drawCheckDisease() {
      drawCheck(162, 346);
    }

    void drawCheckCost() {
      drawCheck(105, 194);
    }

    void drawPage2() {
        draw(2, () {
            int left = 473;
            drawCheck(left, 307);
            drawCheck(left, 374);
            drawCheck(left, 463);
        });
    }

    void drawPersonAgreement() {
        drawAgreement(3, person!);
    }

    void drawOwnerAgreement() {
        if (info!.personName == owner!.name) {
            return;
        }

        drawAgreement(4, owner!);
    }

    void drawAgreement(int page, Person person) {
        return draw(page, () {
            int left = 473;
            drawCheck(left, 103);
            drawCheck(left, 171);
            drawCheck(left, 259);
            drawCheck(left, 335);
            drawCheck(left, 526);
            drawCheck(left, 566);
            drawCheck(left, 667);
            drawAgreementPerson(person, 722);
        });
    }

    void drawDisease(int top) {
        img.drawString(image!, bitmapFont!, 120, top, info!.name!);
        img.drawString(image!, bitmapFont!, 350, top + 10, info!.name!);
    }

    void drawCheck(int left, int top) {
        img.drawString(image!, bitmapFont!, left, top, '∨');
    }

    String prependZero(String value) {
        if (value.length == 2) {
            return value;
        }

        return "0$value";
    }

    void drawDate(Person person, top) {
        drawNumber(year!, 105, top);
        drawNumber(month!, 190, top);
        drawNumber(day!, 235, top);

        img.drawString(image!, bitmapFont!, 370, top, person.name!);
        img.drawString(image!, bitmapFont!, 460, top, person.name!);
    }

    void drawAgreementPerson(Person person, top) {
        int nameTop = 700;

        drawNumber(year!, 155, top);
        drawNumber(month!, 245, top);
        drawNumber(day!, 300, top);

        img.drawString(image!, bitmapFont!, 440, nameTop, person.name!);
        img.drawString(image!, bitmapFont!, 500, nameTop, person.name!);
    }

    void drawBank(top) {
        Bank? bank = owner!.bank;

        img.drawString(image!, bitmapFont!, 139, top, bank!.name!);
        img.drawString(image!, bitmapFont!, 250, top, bank.number!);
        img.drawString(image!, bitmapFont!, 480, top, owner!.name!);
    }

    void drawNumber(String number, int left, int top) {
        int index = 0;

        number.split('').forEach((t) {
            img.drawString(image!, bitmapFont!, left + fontSpace * index, top, t);
            index++;
        });
    }

    void drawPerson(Person person, int left, int top) {
        img.drawString(image!, bitmapFont!, left, top, person.name!);
        drawNumber(person.number1!, left + 128, top);
        drawNumber(person.number2!, left + 248, top);

        if (person.owner?? false) {
            int phoneLeft = 141;
            int phoneTop = top + 49;

            drawNumber(person.phone1!, phoneLeft, phoneTop);
            drawNumber(person.phone2!, phoneLeft + 67, phoneTop);
            drawNumber(person.phone3!, phoneLeft + 150,  phoneTop);
        }
    }
}
