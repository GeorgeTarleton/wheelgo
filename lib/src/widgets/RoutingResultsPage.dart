import 'package:flutter/material.dart';

class RoutingResultsPage extends StatelessWidget {
  const RoutingResultsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [
          Container(
            child: Text("First info part"),
          ),
          Container(
            child: Column(
              children: [
                // TODO Extract this out into a start component
                Container(
                  child: Row(
                    children: [
                      Text("Start icon"),
                      Text("Start location")
                    ],
                  ),
                ),
                Container(
                  child: Text("Divider buffer"),
                ),
                // TODO Extract this into its own walking component
                Container(
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
                ),
                // TODO Extract this to its own public transport component
                Container(
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
                ),
                // TODO Extract this out into an arrival component
                Container(
                  child: Row(
                    children: [
                      Text("Arrival icon"),
                      Text("Arrived at X at time")
                    ],
                  ),
                ),
                // TODO Extract out into an elevation component
                Container(
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
                )
              ],
            ),
          )
        ]
    );
  }

}