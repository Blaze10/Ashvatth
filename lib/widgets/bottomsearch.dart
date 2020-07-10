import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class BottomSearch extends StatefulWidget {
  final BuildContext ctx;

  BottomSearch({this.ctx});

  @override
  _BottomSearchState createState() => _BottomSearchState();
}

class _BottomSearchState extends State<BottomSearch> {
  bool showLoader = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xff8d6e52),
                        )),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: MediaQuery.of(context).size.height * 0.11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/profile.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Relationship'),
                        DropdownButton<String>(
                          hint: Text('Relationship'),
                          items: <String>[
                            "Grandfather",
                            "Grandmother",
                            "Father",
                            "Mother",
                            "Brother",
                            "Sister",
                            "Son",
                            "Daughter",
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: AutoCompleteTextField<String>(
                    decoration: InputDecoration(
                        hintText: "Search relatives:",
                        suffixIcon:  Icon(Icons.search)),
                    itemSubmitted: (item) => setState(() => selected = item),
                    key: key,
                    suggestions: suggestions,
                    itemBuilder: (context, suggestion) =>  Padding(
                        child:  ListTile(
                          title:  Text(suggestion),
                        ),
                        padding: EdgeInsets.all(8.0)),
                    itemSorter: (a, b) {
                      return a.compareTo(b);
                    },
                    itemFilter: (suggestion, input) => suggestion
                        .toLowerCase()
                        .startsWith(input.toLowerCase()),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  String selected;

  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<String>>();
  List<String> suggestions = [
    "Aarav",
    "Aarush",
    "Aayush",
    "Abram",
    "Advik",
    "Akarsh",
    "Anay",
    "Aniruddh",
    "Arhaan",
    "Armaan",
    "Arnav",
    "Azad",
    "Badal",
    "Bhavin",
    "Chirag",
    "Darshit",
    "Devansh",
    "Dhanuk",
    "Dhruv",
    "Divij",
    "Divit",
    "Divyansh",
  ];
  // set loader state
  showHideLoader(bool value) {
    setState(() {
      showLoader = value;
    });
  }
}
