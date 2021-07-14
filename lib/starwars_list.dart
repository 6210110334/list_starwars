import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_starwars/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StarwarsListState();
}

extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

class _StarwarsListState extends State<StarwarsList> {
  final StarwarsRepo _repo;
  late List<People> _peoples;
  late int _page;

  _StarwarsListState() : _repo = new StarwarsRepo();

  @override
  void initState() {
    super.initState();
    _page = 1;
    _peoples = [];
    fetchPeople();
  }

  Future<void> fetchPeople() async {
    if (_page < 10) {
      List<People> peoples = await _repo.fetchPeople(page: _page);
      setState(() {
        _peoples = List<People>.from(_peoples);
        _peoples.addAll(peoples);
        _page += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String noImage =
        'https://i0.wp.com/cms.ironk12.org/wp-content/uploads/2020/02/no-person-profile-pic.png?fit=225%2C225&ssl=1';
    var colorText = TextStyle(color: Colors.yellow[900]);
    return Center(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://media.istockphoto.com/photos/background-of-galaxy-and-stars-picture-id1035676256?k=6&m=1035676256&s=612x612&w=0&h=MwfEydInA8winJ8z4VfhiWXlEx5ItVOQt68OGwO8Y18='),
                fit: BoxFit.cover)),
        child: ListView.builder(
          itemCount: _peoples.length,
          itemBuilder: (context, index) {
            var people = _peoples[index];
            if (people.id == _peoples.length && _page != 9) {
              fetchPeople();
            }
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  color: Colors.yellow,
                  child: Card(
                    child: Container(
                      color: Colors.black,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            child: FadeInImage(
                              image: people.id != 17
                                  ? NetworkImage(
                                      people.imagLink,
                                      scale: 5,
                                    )
                                  : NetworkImage(
                                      noImage,
                                      scale: 2.8,
                                    ),
                              placeholder: NetworkImage(
                                noImage,
                                scale: 2.8,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ' + people.name,
                                  style: colorText,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Gender: ',
                                      style: colorText,
                                    ),
                                    Text(
                                      people.gender == 'n/a'
                                          ? 'No gender'
                                          : people.gender.inCaps,
                                      style: colorText,
                                    )
                                  ],
                                ),
                                Text(
                                  'Height: ' + people.height,
                                  style: colorText,
                                ),
                                Text(
                                  'Weight: ' + people.mass,
                                  style: colorText,
                                ),
                                Text(
                                  'Birth Year: ' + people.birth_year,
                                  style: colorText,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _peoples.length == people.id ? getStatus() : Container(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getStatus() {
    return _page >= 9
        ? Container(
            padding: EdgeInsets.all(6),
            child: Text(
              'Load Success',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
          )
        : Container(
            width: 100,
            padding: EdgeInsets.all(6),
            child: Row(
              children: [
                Container(
                    width: 20, height: 20, child: CircularProgressIndicator()),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Loading',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            color: Colors.blue[300],
          );
  }
}
