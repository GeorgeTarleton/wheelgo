import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RetryPlaceRequestPage extends StatelessWidget {
  const RetryPlaceRequestPage({
    super.key,
    required this.text,
    this.onRetry,
  });

  final String text;
  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 35),
        onRetry != null ? ElevatedButton(
          onPressed: onRetry,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text("Retry", style: TextStyle(fontSize: 24)),
          ),
        ) : Container(),
      ],
    );
  }
}