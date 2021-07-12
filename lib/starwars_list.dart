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
    List<People> peoples = await _repo.fetchPeople(page: _page);
    setState(() {
      _peoples = List<People>.from(_peoples);
      _peoples.addAll(peoples);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _peoples.length,
      itemBuilder: (context, index) {
        var people = _peoples[index];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.1, horizontal: 5),
          child: Card(
            child: Row(
              children: [
                Image.network(people.imagLink),
                Column(
                  children: [Text(people.name), Text(people.height)],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
