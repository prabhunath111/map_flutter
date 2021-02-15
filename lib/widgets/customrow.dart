import 'package:flutter/material.dart';
class CustomRow extends StatefulWidget {
  @override
  _CustomRowState createState() => _CustomRowState();
}

class _CustomRowState extends State<CustomRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0, right: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:1.0,bottom:1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          size: 16.0,
                          color: Colors.cyan.withOpacity(0.5),
                        ),
                        Text(
                          "Select your Uber",
                          style:
                          TextStyle(
                              fontSize: 10.0,
                              color: Colors.cyan.withOpacity(0.5)),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.airline_seat_recline_normal,
                          size: 16.0,
                          color: Colors.cyan.withOpacity(0.5),
                        ),
                        Text(
                          "Passenger",
                          style:
                          TextStyle(fontSize: 10.0,color: Colors.cyan.withOpacity(0.5)),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:4.0, top:4.0, right:4.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/car.png",
                                width: 30.0,
                                height: 30.0,
                              ),
                              Text(
                                "\$7.80",
                                style: TextStyle(
                                    fontSize: 7.0,
                                    color: Colors.cyan.withOpacity(0.6)),
                              ),
                              Text("6:15pm",
                                  style: TextStyle(
                                      fontSize: 6.0,
                                      color: Color(0xFF5F9EA0)))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:4.0, top:4.0, right:4.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/car.png",
                                width: 30.0,
                                height: 30.0,
                              ),
                              Text("\$12.30",
                                  style: TextStyle(
                                      fontSize: 7.0,
                                      color: Colors.cyan.withOpacity(0.6))),
                              Text("6:18pm",
                                  style: TextStyle(
                                      fontSize: 6.0,
                                      color: Color(0xFF5F9EA0)))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:4.0, top:4.0, right:4.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/car.png",
                                width: 30.0,
                                height: 30.0,
                              ),
                              Text("\$7.80",
                                  style: TextStyle(
                                      fontSize: 7.0,
                                      color: Colors.cyan.withOpacity(0.6))),
                              Text("6:15pm",
                                  style: TextStyle(
                                      fontSize: 6.0,
                                      color: Color(0xFF5F9EA0)))
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:4.0, right:4.0),
                          child: Text(
                            "1",
                            style: TextStyle(
                                color: Color(0xFF148CA6),
                                fontSize: 20.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:4.0, right:4.0),
                          child: Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Color(0xFF148CA6),),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),),
                            ),
                            child: Center(
                              child: Text(
                                "2",
                                style: TextStyle(
                                    color: Color(0xFF148CA6),
                                    fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left:4.0, right:4.0),
                          child: Text(
                            "3",
                            style: TextStyle(
                                color: Color(0xFF148CA6),
                                fontSize: 20.0),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}