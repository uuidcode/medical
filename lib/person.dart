import 'bank.dart';

class Person {
  String? name;
  String? number1;
  String? number2;
  String? phone1;
  String? phone2;
  String? phone3;
  bool? owner;
  Bank? bank;

  Person(
      {this.name,
        this.number1,
        this.number2,
        this.phone1,
        this.phone2,
        this.phone3,
        this.owner,
        this.bank});

  Person.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number1 = json['number1'];
    number2 = json['number2'];
    phone1 = json['phone1'];
    phone2 = json['phone2'];
    phone3 = json['phone3'];
    owner = json['owner'];
    bank = json['bank'] != null ? new Bank.fromJson(json['bank']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['number1'] = this.number1;
    data['number2'] = this.number2;
    data['phone1'] = this.phone1;
    data['phone2'] = this.phone2;
    data['phone3'] = this.phone3;
    data['owner'] = this.owner;
    if (this.bank != null) {
      data['bank'] = this.bank!.toJson();
    }
    return data;
  }
}