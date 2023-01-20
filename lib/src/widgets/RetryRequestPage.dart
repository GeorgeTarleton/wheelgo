import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RetryPlaceRequestPage extends StatelessWidget {
  const RetryPlaceRequestPage({
    super.key,
    required this.onRetry,
  });

  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        Text("An error occurred!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 35),
        ElevatedButton(
          onPressed: onRetry,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text("Retry", style: TextStyle(fontSize: 24)),
          ),
        ),
      ],
    );
  }
}