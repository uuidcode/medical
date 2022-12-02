import 'main.dart';
import 'person.dart';

class Info {
  String? name;
  String? personName;
  List<Person>? personList;

  Info({this.name, this.personName, this.personList});

  Info.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    personName = json['personName'];
    if (json['personList'] != null) {
      personList = <Person>[];
      json['personList'].forEach((v) {
        personList!.add(Person.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['personName'] = this.personName;
    if (this.personList != null) {
      data['personList'] = this.personList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}