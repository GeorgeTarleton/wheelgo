import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key, required this.prompt, this.onSubmit,
    this.fillColour = const Color.fromRGBO(222, 222, 222, 100),
    this.textColour = Colors.grey
  });

  final String prompt;
  final Color fillColour;
  final Color textColour;
  final Function(String)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        fillColor: fillColour,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        hintText: prompt,
        hintStyle: TextStyle(
            color: textColour,
            fontSize: 18
        ),
        prefixIcon: Container(
          padding: EdgeInsets.all(15),
          child: Icon(Icons.search),
        ),
      ),
      onSubmitted: onSubmit,
    );
  }
}