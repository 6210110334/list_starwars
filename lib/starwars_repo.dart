import 'package:dio/dio.dart';

class People {
  final String name;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String gender;
  final String imagLink;

  People(this.name, this.height, this.eyeColor, this.gender, this.hairColor,
      this.mass, this.skinColor, this.imagLink);

  factory People.fromJson(dynamic data, int index) {
    return People(
        data['name'],
        data['height'],
        data['mass'],
        data['hair_color'],
        data['skin_color'],
        data['eye_color'],
        data['gender'],
        'https://starwars-visualguide.com/assets/img/characters/$index.jpg');
  }
}

class StarwarsRepo {
  int index = 1;
  Future<List<People>> fetchPeople({int page = 1}) async {
    var response = await Dio().get('https://swapi.dev/api/people/?page=$page');
    List<dynamic> results = response.data['results'];
    List<People> peoples = [];
    results.forEach((people) {
      peoples.add(People.fromJson(people, index));
      index++;
    });
    return peoples;
  }
}
