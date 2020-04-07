import 'dart:convert';
import 'dart:math' show Random;

import 'mock_data.dart';

class MockUser {
  final String userName;
  final int id;
  final String email;
  MockUser({this.userName, this.id, this.email});

  static MockUser generateWithId(int id) {
    String userName = _getRandomUserName();
    id = int.parse(
        ((id > 1000) ? id.toString().substring(0, 4) : id.toString()));
    String email = userName + id.toString() + '@' + _getRandomEmailDomain();
    return MockUser(userName: userName, id: id, email: email);
  }

  static List<MockUser> generate({int limit = 1}) {
    List<MockUser> list = [];
    for (int i = 0; i < limit; i++) {
      String userName = _getRandomUserName();
      int id = _getRandomId();
      String email = userName + id.toString() + '@' + _getRandomEmailDomain();
      list.add(MockUser(userName: userName, id: id, email: email));
    }
    return list;
  }

  static List<String> generateAsJson({int limit = 1}) {
    List<String> list = [];
    for (int i = 0; i < limit; i++) {
      String userName = _getRandomUserName();
      int id = _getRandomId();
      String email = userName + id.toString() + '@' + _getRandomEmailDomain();
      list.add(MockUser(userName: userName, id: id, email: email).toJson());
    }
    return list;
  }

  static List<Map> generateAsMap({int limit = 1}) {
    List<Map> list = [];
    for (int i = 0; i < limit; i++) {
      String userName = _getRandomUserName();
      int id = _getRandomId();
      String email = userName + id.toString() + '@' + _getRandomEmailDomain();
      list.add(MockUser(userName: userName, id: id, email: email).toMap());
    }
    return list;
  }

  static int _getRandomId() {
    return Random().nextInt(1000);
  }

  static String _getRandomUserName() {
    int randomNumber = Random().nextInt(MockData.usernames.length);
    return MockData.usernames[randomNumber];
  }

  static String _getRandomEmailDomain() {
    int randomNumber = Random().nextInt(MockData.emails.length);
    return MockData.emails[randomNumber];
  }

  Map toMap() => {'username': userName, 'id': id, 'email': email};

  String toJson() => jsonEncode(toMap());
}
