import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class Tree extends StatelessWidget {
  static const routeName = "tree";
  dynamic family = {
    "R1": "Gfather",
    "R2": "GMother",
    "children": [
      {
        "P1": "father",
        "P2": "mother",
        "children": {
          0: {
            "P1": "brother1",
            "P2": "sister-in-law-1",
            "children": {
              0: "nephew1",
              1: "neice1",
            }
          },
          1: "sister",
          2: "you",
        }
      },
      {
        "P1": "uncle1",
        "P2": "aunty1",
        "children": {
          0: "brother1",
          1: "sister1",
        }
      },
      {
        "P1": "uncle2",
        "P2": "aunty2",
        "children": {
          0: "brother2",
          1: "sister2",
        }
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    print(family['R1']);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tree'),
      ),
      body: Zoom(
        width: 1800,
        height: 1800,
        onPositionUpdate: (Offset position) {
          print(position);
        },
        onScaleUpdate: (double scale, double zoom) {
          print("$scale  $zoom");
        },
        child: Center(
          child: Column(
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        RaisedButton(
                          child: Text(family['R1']),
                          onPressed: () {},
                        ),
                        RaisedButton(
                          child: Text(family['R2']),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )),
              Flexible(
                flex: 8,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: family['children'].length,
                    // itemExtent: 10.0,
                    // reverse: true, //makes the list appear in descending order
                    itemBuilder: (BuildContext context, int i) {
                      return Flexible(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  RaisedButton(
                                    child: Text(family['children'][i]['P1']),
                                    onPressed: () {},
                                  ),
                                  RaisedButton(
                                    child: Text(family['children'][i]['P2']),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount:
                                      family['children'][i]['children'].length,
                                  // itemExtent: 10.0,
                                  // reverse: true, //makes the list appear in descending order
                                  itemBuilder: (BuildContext context, int iX) {
                                    if (family['children'][i]['children'][iX]
                                        is String) {
                                      return Row(
                                        children: [
                                          RaisedButton(
                                            child: Text(family['children'][i]
                                                ['children'][iX]),
                                            onPressed: () {},
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              RaisedButton(
                                                child: Text(family['children']
                                                    [i]['children'][iX]['P1']),
                                                onPressed: () {},
                                              ),
                                              RaisedButton(
                                                child: Text(family['children']
                                                    [i]['children'][iX]['P2']),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: family['children'][i]
                                                          ['children'][iX]
                                                      ['children']
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int iy) {
                                                return Row(
                                                  children: [
                                                    SizedBox(width: 20),
                                                    RaisedButton(
                                                      child: Text(family[
                                                                  'children'][i]
                                                              ['children'][iX]
                                                          ['children'][iy]),
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                );
                                              })
                                        ],
                                      );
                                    }
                                  })
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
