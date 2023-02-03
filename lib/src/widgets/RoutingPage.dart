import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wheelgo/src/dtos/NominatimElement.dart';
import 'package:wheelgo/src/widgets/SearchPage.dart';

import '../parameters/DestinationCardParams.dart';
import '../parameters/MarkerInfo.dart';
import '../services/QueryService.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({super.key});

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  QueryService queryService = QueryService();
  DestinationCardParams? originInfo;
  DestinationCardParams? destinationInfo;
  int inclination = 6;
  double maxKerbHeight = 0.06;
  String routeSmoothness = "Good";
  bool avoidSteps = true;
  bool usePublicTransport = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          DirectionSearchBar(
              prompt: originInfo?.name ?? "From",
              textColour: Color.fromRGBO(53, 53, 53, 0.7),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text("Select Start", style: TextStyle(color: Colors.white)),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          body: ListView(
                              shrinkWrap: true,
                              children: [
                                SizedBox(height: 5),
                                SearchPage(onCardSelect: (params) {
                                  setState(() => originInfo = params);
                                  Navigator.pop(context);
                                })
                              ]
                          ),
                        );
                      }),
                );
              }),
          SizedBox(height: 5),
          Icon(Icons.arrow_downward),
          SizedBox(height: 5),
          DirectionSearchBar(
            prompt: destinationInfo?.name ?? "Destination",
            textColour: Color.fromRGBO(53, 53, 53, 0.7),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text("Select Destination", style: TextStyle(color: Colors.white)),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        body: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(height: 5),
                              SearchPage(onCardSelect: (params) {
                                setState(() => destinationInfo = params);
                                Navigator.pop(context);
                              })
                            ]
                        ),
                      );
                    }),
              );
            }),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconToggleButton(
                icon: Icon(Icons.train_outlined),
                selectedIcon: Icon(Icons.train),
                selected: !usePublicTransport,
                onPressed: () => setState(() => usePublicTransport = !usePublicTransport),
                getDefaultStyle: filledButtonStyle,
              ),
              SizedBox(width: 10),
              IconToggleButton(
                selectedIcon: Icon(Icons.accessible_forward_outlined),
                icon: Icon(Icons.accessible_forward),
                selected: usePublicTransport,
                onPressed: () => setState(() => usePublicTransport = !usePublicTransport),
                getDefaultStyle: filledButtonStyle,
              ),
            ],
          ),
          SizedBox(height: 16),
          RestrictionPanel(
            inclination: inclination,
            maxKerbHeight: maxKerbHeight,
            routeSmoothness: routeSmoothness,
            avoidSteps: avoidSteps,
          ),
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
  RestrictionPanel({
    super.key,
    required this.inclination,
    required this.maxKerbHeight,
    required this.routeSmoothness,
    required this.avoidSteps,
  });

  int inclination;
  double maxKerbHeight;
  String routeSmoothness;
  bool avoidSteps;

  @override
  State<StatefulWidget> createState() => _RestrictionPanelState();
}

class _RestrictionPanelState extends State<RestrictionPanel> {
  Item restrictions = Item(expandedValue: "Option1", headerValue: "Restrictions");

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
                  Text("Max inclination (%)"),
                  Spacer(),
                  DropdownButton<int>(
                    value: widget.inclination,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (int? value) {
                      setState(() {
                        widget.inclination = value!;
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
                  Text("Max kerb height (m)"),
                  Spacer(),
                  DropdownButton<double>(
                    value: widget.maxKerbHeight,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (double? value) {
                      setState(() {
                        widget.maxKerbHeight = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(value: 0.03, child: Text("0.03")),
                      DropdownMenuItem(value: 0.06, child: Text("0.06")),
                      DropdownMenuItem(value: 0.1, child: Text("0.1"))
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
                    value: widget.routeSmoothness,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        widget.routeSmoothness = value!;
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
                    value: widget.avoidSteps,
                    onChanged: (bool? value) {
                      setState(() {
                        widget.avoidSteps = value!;
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
  IconToggleButton({super.key,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onPressed,
    this.getDefaultStyle,
  });

  final ButtonStyle? Function(bool, ColorScheme)? getDefaultStyle;
  final Icon icon;
  final Icon selectedIcon;
  final Function() onPressed;
  bool selected;

  @override
  State<IconToggleButton> createState() => _IconToggleButtonState();
}

class _IconToggleButtonState extends State<IconToggleButton> {

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    ButtonStyle? style;
    if (widget.getDefaultStyle != null) {
      style = widget.getDefaultStyle!(widget.selected, colors);
    }

    return IconButton(
      isSelected: widget.selected,
      icon: widget.icon,
      selectedIcon: widget.selectedIcon,
      onPressed: widget.onPressed,
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
    required this.onTap,
    this.fillColour = const Color.fromRGBO(222, 222, 222, 100),
    this.textColour = Colors.grey
  });

  final String prompt;
  final Color fillColour;
  final Color textColour;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: onTap,
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