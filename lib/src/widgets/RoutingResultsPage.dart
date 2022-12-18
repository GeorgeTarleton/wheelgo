import 'package:flutter/material.dart';

class RoutingResultsPage extends StatelessWidget {
  const RoutingResultsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [
          KeyInfo(),
          Container(
            child: Column(
              children: [
                StartInfo(),
                Container(
                  child: Text("Divider buffer"),
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
    return Container(
      child: Text("First info part"),
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
          Text("Start icon"),
          Text("Start location")
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