import 'package:flutter/material.dart';

class RoutingResultsPage extends StatelessWidget {
  const RoutingResultsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 8),
            child: KeyInfo(),
          ),
          SizedBox(
            height: 4.0,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                StartInfo(),
                Container(
                  height: 25,
                  alignment: Alignment.topLeft,
                  child: const VerticalDivider(
                    width: 44,
                    thickness: 3,
                    color: Colors.grey,
                  ),
                ),
                WalkingInfo(),
                PublicTransportInfo(),
                ArrivalInfo(),
                ElevationInfo(),
              ],
            ),
          )
        ]
    );
  }
}

class KeyInfo extends StatelessWidget {
  const KeyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.accessible),
                    Icon(Icons.arrow_right_alt),
                    Icon(Icons.train),
                    Icon(Icons.arrow_right_alt),
                    Icon(Icons.accessible),
                  ],
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text("£Price",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Column(
              children: [
                Text("Time mins - X km",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text("End time: ", textAlign: TextAlign.left,),
              ],
            ),
          ],
        ),
      ),
    );

  }
}

class StartInfo extends StatelessWidget {
  const StartInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).primaryColor,
            ),
            child: Icon(Icons.location_on_outlined, color: Colors.white),
          ),
          SizedBox(width: 20.0),
          Text("Start location",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class WalkingInfo extends StatelessWidget {
  const WalkingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text("Wheeling icon"),
              Text("Wheeling time and distance")
            ],
          ),
          Row(
            children: [
              Text("Divider"),
              Text("Directions dropdown"),
            ],
          )
        ],
      ),
    );
  }
}

class PublicTransportInfo extends StatelessWidget {
  const PublicTransportInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text("Public transport icon"),
              Text("Station at time")
            ],
          ),
          Row(
            children: [
              Text("Divider"),
              Column(
                children: [
                  Text("Line 1 to Line 2 for X mins"),
                  Text("Stops dropdown")
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text("Public transport icon"),
              Text("Line 2 to Line 3 for X mins"),
            ],
          ),
          Row(
            children: [
              Text("Divider"),
              Text("Stops dropdown"),
            ],
          ),
        ],
      ),
    );
  }
}

class ArrivalInfo extends StatelessWidget {
  const ArrivalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text("Arrival icon"),
          Text("Arrived at X at time")
        ],
      ),
    );
  }
}

class ElevationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Row(
            children: [
              Text("Up icon"),
              Text("X m")
            ],
          ),
          Row(
            children: [
              Text("Down icon"),
              Text("X m")
            ],
          )
        ],
      ),
    );
  }
}