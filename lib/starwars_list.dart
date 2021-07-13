import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_starwars/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StarwarsListState();
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
    return Stack(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _peoples.length,
            itemBuilder: (context, index) {
              var people = _peoples[index];
              if (people.id == _peoples.length && _page != 9) {
                fetchPeople();
              }
              return Container(
                padding: EdgeInsets.symmetric(vertical: 0.1, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Card(
                  child: Row(
                    children: [
                      FadeInImage(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ' + people.name),
                          Row(
                            children: [
                              Text('Gender: '),
                              Text(people.gender == 'n/a'
                                  ? 'No gender'
                                  : people.gender)
                            ],
                          ),
                          Text('Height: ' + people.height),
                          Text('Weight: ' + people.mass),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          child: Align(alignment: Alignment.bottomCenter, child: getStatus()),
        )
      ],
    );
  }

  Widget getStatus() {
    return _page == 9
        ? Container(
            padding: EdgeInsets.all(6),
            child: Text(
              'Load Success',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.greenAccent[400],
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
