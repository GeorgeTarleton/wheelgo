import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: const Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: const Text("Category", style: TextStyle(fontSize: 20)),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Expanded(child: Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: const Text(
                                "Wheelchair Rating",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24, color: Colors.green
                                )
                            )
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Container(
                          child: const Text("Description", style: TextStyle(fontSize: 18)),
                        ),
                      ]
                  ),
                )
              ))
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 4),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 20)
              ),
              child: const Text("Directions"),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                Text("Address", style: TextStyle(fontSize: 20)),
                Text("Website", style: TextStyle(fontSize: 20))
              ],
            ),
          )
        ],
      ),
    );
  }
}