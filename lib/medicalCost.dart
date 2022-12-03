import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
    img.BitmapFont? bitmapFont;

    static MedicalCost of() {
        return MedicalCost();
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

        month = prependZero(month!);
        day = prependZero(day!);

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
        ImageGallerySaver.saveImage(encodeImage.buffer.asUint8List());
    }
    
    void drawPage1() {
        draw(1, () {
            drawPerson(person!, 150, 107);
            drawPerson(owner!, 150, 181);
            
            drawCheck(108, 205);
            drawCheck(165, 357);
            drawCheck(495, 645);
            
            drawBank();
            drawDisease();
            drawDate(person!);
        });
    }

    void drawPage2() {
        draw(2, () {
            int left = 476;
            drawCheck(left, 319);
            drawCheck(left, 386);
            drawCheck(left, 475);
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
            int left = 476;
            drawCheck(left, 115);
            drawCheck(left, 183);
            drawCheck(left, 271);
            drawCheck(left, 347);
            drawCheck(left, 538);
            drawCheck(left, 578);
            drawCheck(left, 679);
            drawAgreementPerson(person);
        });
    }

    void drawDisease() {
        img.drawString(image!, img.arial_14, 120, 420, '\ud55c\uae00');
        img.drawString(image!, bitmapFont!, 350, 430, 'test');
    }

    void drawCheck(int left, int top) {
        img.drawString(image!, bitmapFont!, left, top, 'V');
    }

    String prependZero(String value) {
        if (value.length == 2) {
            return value;
        }

        return "0$value";
    }

    void drawDate(Person person) {
        int top = 736;

        drawNumber(year!, 105, top);
        drawNumber(month!, 190, top);
        drawNumber(day!, 235, top);

        img.drawString(image!, bitmapFont!, 370, top, person.name!);
        img.drawString(image!, bitmapFont!, 460, top, person.name!);
    }

    void drawAgreementPerson(Person person) {
        int top = 734;
        int nameTop = 710;

        drawNumber(year!, 155, top);
        drawNumber(month!, 245, top);
        drawNumber(day!, 300, top);

        img.drawString(image!, bitmapFont!, 440, nameTop, person.name!);
        img.drawString(image!, bitmapFont!, 500, nameTop, person.name!);
    }

    void drawBank() {
        int top = 585;
        Bank? bank = owner!.bank;

        img.drawString(image!, bitmapFont!, 145, top, bank!.name!);
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
            int phoneLeft = 140;
            int phoneTop = 230;

            drawNumber(person.phone1!, phoneLeft, phoneTop);
            drawNumber(person.phone2!, phoneLeft + 67, phoneTop);
            drawNumber(person.phone3!, phoneLeft + 150,  phoneTop);
        }
    }
}
