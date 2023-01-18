import 'package:flutter/material.dart';
import 'package:wheelgo/src/widgets/SearchBar.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({super.key});

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          DirectionSearchBar(prompt: "From", textColour: Color.fromRGBO(53, 53, 53, 0.7)),
          Icon(Icons.arrow_downward),
          DirectionSearchBar(prompt: "Destination", textColour: Color.fromRGBO(53, 53, 53, 0.7)),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconToggleButton(icon: Icon(Icons.train_outlined), selectedIcon: Icon(Icons.train), getDefaultStyle: filledButtonStyle),
              SizedBox(width: 10),
              IconToggleButton(icon: Icon(Icons.accessible_forward_outlined), selectedIcon: Icon(Icons.accessible_forward), getDefaultStyle: filledButtonStyle),
            ],
          ),
          SizedBox(height: 16),
          RestrictionPanel(),
          SizedBox(height: 16),
          TextButton(onPressed: () {}, child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Text(
              "Search",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          )),
        ]
      ),
    );
  }
}

class RestrictionPanel extends StatefulWidget {
  const RestrictionPanel({super.key});

  @override
  State<StatefulWidget> createState() => _RestrictionPanelState();
}

class _RestrictionPanelState extends State<RestrictionPanel> {
  Item restrictions = Item(expandedValue: "Option1", headerValue: "Restrictions");

  int inclination = 6;
  double maxKerbHeight = 0.06;
  String routeSmoothness = "Good";
  bool avoidSteps = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          restrictions.isExpanded = !restrictions.isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder:
              (BuildContext context, bool isExpanded) => ListTile(title: Text(restrictions.headerValue)),
          body: Column(children: [
            ListTile(title:
              Row(
                children: [
                  Text("Max inclination"),
                  Spacer(),
                  DropdownButton<int>(
                    value: inclination,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (int? value) {
                      setState(() {
                        inclination = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(value: 3, child: Text("3")),
                      DropdownMenuItem(value: 6, child: Text("6")),
                      DropdownMenuItem(value: 10, child: Text("10")),
                      DropdownMenuItem(value: 15, child: Text("15"))
                    ],
                  )
                ],
              )
            ),
            ListTile(title:
              Row(
                children: [
                  Text("Max kerb height"),
                  Spacer(),
                  DropdownButton<double>(
                    value: maxKerbHeight,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (double? value) {
                      setState(() {
                        maxKerbHeight = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(value: 0.03, child: Text("0.03")),
                      DropdownMenuItem(value: 0.06, child: Text("0.03")),
                      DropdownMenuItem(value: 0.1, child: Text("0.03"))
                    ],
                  )
                ],
              )
            ),
            ListTile(title:
              Row(
                children: [
                  Text("Route smoothness"),
                  Spacer(),
                  DropdownButton<String>(
                    value: routeSmoothness,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        routeSmoothness = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(value: "Bad", child: Text("Bad")),
                      DropdownMenuItem(value: "Intermediate", child: Text("Intermediate")),
                      DropdownMenuItem(value: "Good", child: Text("Good")),
                      DropdownMenuItem(value: "Excellent", child: Text("Excellent"))
                    ],
                  )
                ],
              )
            ),
            ListTile(title:
              Row(
                children: [
                  Text("Avoid steps"),
                  Spacer(),
                  Checkbox(
                    checkColor: Colors.white,
                    value: avoidSteps,
                    onChanged: (bool? value) {
                      setState(() {
                        avoidSteps = value!;
                      });
                    },
                  )
                ],
              )
            ),
          ]),
          // backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
          isExpanded: restrictions.isExpanded,
        )
      ],
    );
  }

}

class IconToggleButton extends StatefulWidget {
  const IconToggleButton(
  {super.key, required this.icon, required this.selectedIcon, this.getDefaultStyle});

  final ButtonStyle? Function(bool, ColorScheme)? getDefaultStyle;
  final Icon icon;
  final Icon selectedIcon;

  @override
  State<IconToggleButton> createState() => _IconToggleButtonState();
}

class _IconToggleButtonState extends State<IconToggleButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    onPressed() {
      setState(() {
        selected = !selected;
      });
    }

    ButtonStyle? style;
    if (widget.getDefaultStyle != null) {
      style = widget.getDefaultStyle!(selected, colors);
    }

    return IconButton(
      isSelected: selected,
      icon: widget.icon,
      selectedIcon: widget.selectedIcon,
      onPressed: onPressed,
      iconSize: 30,
      style: style,
    );
  }
}

ButtonStyle filledButtonStyle(bool selected, ColorScheme colors) {
  return IconButton.styleFrom(
    foregroundColor: selected ? colors.onPrimary : colors.primary,
    backgroundColor: selected ? colors.primary : colors.surfaceVariant,
    disabledForegroundColor: colors.onSurface.withOpacity(0.38),
    disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
    hoverColor: selected
        ? colors.onPrimary.withOpacity(0.08)
        : colors.primary.withOpacity(0.08),
    focusColor: selected
        ? colors.onPrimary.withOpacity(0.12)
        : colors.primary.withOpacity(0.12),
    highlightColor: selected
        ? colors.onPrimary.withOpacity(0.12)
        : colors.primary.withOpacity(0.12),
  );
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

// TODO Replace this with a proper class for querying
class DirectionSearchBar extends StatelessWidget {
  const DirectionSearchBar({super.key,
    required this.prompt,
    this.fillColour = const Color.fromRGBO(222, 222, 222, 100),
    this.textColour = Colors.grey
  });

  final String prompt;
  final Color fillColour;
  final Color textColour;

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
    );
  }
}