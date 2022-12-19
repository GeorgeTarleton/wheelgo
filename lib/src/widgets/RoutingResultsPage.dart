import 'package:flutter/material.dart';
import 'package:wheelgo/src/widgets/RoutingPage.dart';

class RoutingResultsPage extends StatelessWidget {
  const RoutingResultsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(
        shrinkWrap: true,
        children: [
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
                WalkingInfo(),
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
                    Icon(Icons.accessible_forward),
                    Icon(Icons.arrow_right_alt),
                    Icon(Icons.train),
                    Icon(Icons.arrow_right_alt),
                    Icon(Icons.accessible_forward),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Icon(Icons.accessible_forward, color: Colors.white),
                ),
                SizedBox(width: 20.0),
                Text("Wheeling time and distance", style: TextStyle(fontSize: 18),),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.topLeft,
                  child: const VerticalDivider(
                    width: 44,
                    thickness: 3,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 20.0),
                DirectionsDropDown(),
              ],
            ),
          ],
        ),
      );
  }
}

class DirectionsDropDown extends StatefulWidget {
  const DirectionsDropDown({super.key});

  @override
  State<StatefulWidget> createState() => _DirectionsDropDownState();
}

class _DirectionsDropDownState extends State<DirectionsDropDown> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(width: width*2/3, child: ExpansionPanelList(
      expansionCallback: (i, isExpanded) {
        setState(() {
          active = !active;
        });
      },
      children: [
        ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return ListTile(title: Text("Directions"));
            },
            body: Column(
              children: [
                Align(alignment: Alignment.topLeft,
                  child: Container(padding: EdgeInsets.all(12),
                      child: Text("Direction1", style: TextStyle(fontSize: 16),))),
                Container(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Distance: Xm", style: TextStyle(fontSize: 16)),
                      Text("Time Xmins,Ysecs", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 160,
                      height: 3,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),

                Align(alignment: Alignment.topLeft,
                    child: Container(padding: EdgeInsets.all(12),
                        child: Text("Direction2", style: TextStyle(fontSize: 16),))),
                Container(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Distance: Xm", style: TextStyle(fontSize: 16)),
                      Text("Time Xmins,Ysecs", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 160,
                      height: 3,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 20.0),
                      Text("Arrive at X", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ],
            ),
            isExpanded: active,
            canTapOnHeader: true,
        )
      ],
    ));
  }
}

class PublicTransportInfo extends StatelessWidget {
  const PublicTransportInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(Icons.train, color: Colors.white),
              ),
              SizedBox(width: 20.0),
              Text("Station at time", style: TextStyle(fontSize: 18),),
            ],
          ),
          Row(
            children: [
              Container(
                height: 100,
                alignment: Alignment.topLeft,
                child: const VerticalDivider(
                  width: 44,
                  thickness: 3,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Line 1 to Line 2 for X mins",
                          style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  StopsDropDown(),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(Icons.train, color: Colors.white),
              ),
              SizedBox(width: 20.0),
              Text("Change at station", style: TextStyle(fontSize: 18),),
            ],
          ),
          Row(
            children: [
              Container(
                height: 100,
                alignment: Alignment.topLeft,
                child: const VerticalDivider(
                  width: 44,
                  thickness: 3,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Line 2 to Line 3 for X mins",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  StopsDropDown(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class StopsDropDown extends StatefulWidget {
  const StopsDropDown({super.key});
  
  @override
  State<StatefulWidget> createState() => _StopsDropDownState();
}

class _StopsDropDownState extends State<StopsDropDown> {
  bool active = false;
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(width: width*2/3, child: ExpansionPanelList(
      expansionCallback: (i, isExpanded) {
        setState(() {
          active = !active;
        });
      },
      children: [
        ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return ListTile(title: Text("Stops"));
            },
            body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left:12, right: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_forward),
                    SizedBox(width: 10),
                    Text("Stop 1"),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left:12, right: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_forward),
                    SizedBox(width: 10),
                    Text("Stop 2"),
                  ],
                ),
              ),
            ],
          ),
          isExpanded: active,
          canTapOnHeader: true,
        ),
      ],
    ));
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