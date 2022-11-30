import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(),
        DestinationCard(name: "Name 1", address: "Address 1", distance: "10"),
        DestinationCard(name: "Name 2", address: "Address 2", distance: "20"),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 8),
      child: TextField(
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            fillColor: Color.fromRGBO(222, 222, 222, 100),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
            ),
            hintText: 'Search here',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 18
            ),
            prefixIcon: Container(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.search),
            )
        ),
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  const DestinationCard({super.key, required this.name, required this.address, required this.distance});

  final String name;
  final String address;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 40, top: 8, bottom: 8),
        child:
        Row(
          children: [
            Expanded(flex: 1, child: Column(
              children: [
                Icon(Icons.map),
                SizedBox(
                  height: 4.0,
                ),
                Text(distance + " km")
              ],
            )),
            Expanded(flex: 4, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 20)),
                SizedBox(
                  height: 4.0,
                ),
                Text(address),
                Divider(color: Colors.black)
              ],
            )),
          ],
        )
    );
  }
}