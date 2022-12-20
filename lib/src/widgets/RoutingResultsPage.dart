import 'package:flutter/material.dart';
import 'package:wheelgo/src/enums/TravelLegType.dart';
import 'package:wheelgo/src/parameters/PublicTransportLeg.dart';
import 'package:wheelgo/src/parameters/PublicTransportRide.dart';
import 'package:wheelgo/src/parameters/RoutingResultsPageParams.dart';
import 'package:intl/intl.dart';
import 'package:wheelgo/src/parameters/WheelingLeg.dart';

import '../interfaces/TravelLeg.dart';
import '../parameters/WheelingDirection.dart';

class RoutingResultsPage extends StatelessWidget {
  const RoutingResultsPage({super.key, required this.params});

  final RoutingResultsPageParams params;

  @override
  Widget build(BuildContext context) {
    List<Widget> sections = [
      StartInfo(start: params.start),
      Container(
        height: 25,
        alignment: Alignment.topLeft,
        child: const VerticalDivider(
          width: 44,
          thickness: 3,
          color: Colors.grey,
        ),
      ),
    ];

    for (final leg in params.legs) {
      switch (leg.getType()) {
        case TravelLegType.wheeling:
          sections.add(WheelingInfo(leg: leg as WheelingLeg));
          break;
        case TravelLegType.publicTransport:
          sections.add(PublicTransportInfo(leg: leg as PublicTransportLeg));
          break;
        case TravelLegType.other:
          throw Exception("Unsupported travel type");
      }
    }

    sections.addAll([
      ArrivalInfo(destination: params.destination, arrivalTime: params.arrivalTime),
      SizedBox(height: 20),
      ElevationInfo(up: 5, down: 3),
      SizedBox(height: 10),
    ]);

    return ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 8),
            child: KeyInfo(
              duration: params.duration,
              distance: params.distance,
              arrivalTime: params.arrivalTime,
              price: params.price,
              legs: params.legs,
            ),
          ),
          SizedBox(height: 4.0),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: sections,
            ),
          )
        ]
    );
  }
}


class KeyInfo extends StatelessWidget {
  const KeyInfo({
    super.key,
    required this.duration,
    required this.distance,
    required this.arrivalTime,
    this.price,
    required this.legs,
  });

  final Duration duration;
  final double distance;
  final TimeOfDay arrivalTime;
  final double? price;
  final List<TravelLeg> legs;

  Icon getIcon(TravelLegType type) {
    switch (type) {
      case TravelLegType.wheeling:
        return const Icon(Icons.accessible_forward);
      case TravelLegType.publicTransport:
        return const Icon(Icons.train);
      case TravelLegType.other:
        return const Icon(Icons.arrow_circle_right);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: "en_GB");

    List<Icon> legIcons = [];
    if (legs.isNotEmpty) {
      for (int i=0; i < legs.length-1; i++) {
        TravelLegType type = legs[i].getType();
        legIcons.add(getIcon(type));
        legIcons.add(const Icon(Icons.arrow_right_alt));
      }

      legIcons.add(getIcon(legs[legs.length-1].getType()));
    }

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
                Row(children: legIcons),
                SizedBox(height: 4.0),
                Text(currencyFormat.format(price),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Column(
              children: [
                Text("${duration.inMinutes} mins - ${distance.round()} km",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text("Arrival time: ${arrivalTime.format(context)}", textAlign: TextAlign.left),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class StartInfo extends StatelessWidget {
  const StartInfo({
    super.key,
    required this.start,
  });

  final String start;

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
          Text(start,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class WheelingInfo extends StatelessWidget {
  const WheelingInfo({super.key, required this.leg});

  final WheelingLeg leg;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            Text("Travel for ${leg.duration.inMinutes} minutes (${leg.distance} km)", style: TextStyle(fontSize: 18)),
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
            DirectionsDropDown(directions: leg.directions, destination: leg.destination),
          ],
        ),
      ],
    );
  }
}

class DirectionsDropDown extends StatefulWidget {
  const DirectionsDropDown({super.key, required this.directions, required this.destination});

  final List<WheelingDirection> directions;
  final String destination;

  @override
  State<StatefulWidget> createState() => _DirectionsDropDownState();
}

class _DirectionsDropDownState extends State<DirectionsDropDown> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<Widget> directionSteps = [];
    for (final direction in widget.directions) {
      directionSteps.add(
        Align(alignment: Alignment.topLeft,
            child: Container(padding: EdgeInsets.all(12),
                child: Text(direction.description, style: TextStyle(fontSize: 16))))
      );
      directionSteps.add(
          Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${direction.distance} km", style: TextStyle(fontSize: 16)),
                Text("${direction.duration.inMinutes} mins, ${direction.duration.inSeconds % 60} secs", style: TextStyle(fontSize: 16))
              ],
            ),
          )
      );
      directionSteps.add(
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
      );
    }

    directionSteps.add(Container(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.location_on),
          SizedBox(width: 20.0),
          Text("Arrive at ${widget.destination}", style: TextStyle(fontSize: 16))
        ],
      ),
    ));

    return SizedBox(width: width*2/3, child: ExpansionPanelList(
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
              children: directionSteps,
            ),
            isExpanded: active,
            canTapOnHeader: true,
        )
      ],
    ));
  }
}


class PublicTransportInfo extends StatelessWidget {
  const PublicTransportInfo({super.key, required this.leg});

  final PublicTransportLeg leg;

  @override
  Widget build(BuildContext context) {
    assert(leg.rides.isNotEmpty);

    PublicTransportRide firstRide = leg.rides[0];
    String nextStation = leg.rides.length > 1 ? leg.rides[1].startStation : leg.finalStation;
    List<Widget> steps = [
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
          Text("${firstRide.startStation} at ${firstRide.leavingTime.format(context)}", style: TextStyle(fontSize: 18)),
        ],
      ),
      Row(
        children: [
          Container(
            height: 125,
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
              Text("${firstRide.line} Line",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Text("${firstRide.startStation} to $nextStation for ${firstRide.duration.inMinutes} mins",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              StopsDropDown(stops: firstRide.stops),
            ],
          ),
        ],
      ),
    ];

    for (int i=1; i < leg.rides.length; i++) {
      String nextStation = leg.rides.length > i+1 ? leg.rides[i+1].startStation : leg.finalStation;

      steps.addAll([
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
            Text("Change at ${leg.rides[i].startStation}", style: TextStyle(fontSize: 18)),
          ],
        ),
        Row(
          children: [
            Container(
              height: 140,
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
                Text("${leg.rides[i].line} Line",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Text("${leg.rides[i].startStation} to $nextStation for ${leg.rides[i].duration.inMinutes} mins",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                StopsDropDown(stops: leg.rides[i].stops),
              ],
            ),
          ],
        ),
      ]);
    }

    steps.addAll([
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
          Text("Exit at ${leg.finalStation} at ${leg.arrivalTime.format(context)}", style: TextStyle(fontSize: 18)),
        ],
      ),
      Container(
        height: 25,
        alignment: Alignment.topLeft,
        child: const VerticalDivider(
          width: 44,
          thickness: 3,
          color: Colors.grey,
        ),
      ),
    ]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: steps,
    );
  }
}


class StopsDropDown extends StatefulWidget {
  const StopsDropDown({super.key, required this.stops});

  final List<String> stops;
  
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
            children: widget.stops
                    .map(
                      (stop) => Container(
                        padding:
                            EdgeInsets.only(left: 12, right: 12, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_forward),
                            SizedBox(width: 10),
                            Text(stop),
                          ],
                        ),
                      ),
                    ).toList(),
              ),
              isExpanded: active,
          canTapOnHeader: true,
        ),
      ],
    ));
  }
}


class ArrivalInfo extends StatelessWidget {
  const ArrivalInfo({super.key, required this.destination, required this.arrivalTime});

  final String destination;
  final TimeOfDay arrivalTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.green,
            ),
            child: Icon(Icons.location_on_outlined, color: Colors.white),
          ),
          SizedBox(width: 20.0),
          Text.rich(TextSpan(
            children: [
              TextSpan(text: "Arrive at ",
                  style: TextStyle(fontSize: 18)),
              TextSpan(text: destination,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextSpan(text: " at ${arrivalTime.format(context)}",
                  style: TextStyle(fontSize: 18)),
            ]
          )),
        ],
      ),
    );
  }
}

class ElevationInfo extends StatelessWidget {
  const ElevationInfo({super.key, required this.up, required this.down});

  final double up;
  final double down;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_upward),
              SizedBox(width: 5),
              Text("$up m"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_downward),
              SizedBox(width: 5),
              Text("$down m"),
            ],
          )
        ],
      ),
    );
  }
}