// import 'dart:io';

import 'package:flutter/material.dart';
import 'main.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}
  
class _TimetablePageState extends State<TimetablePage> {
  Future<List<Performance>> performances = MyAppState().performances;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Performance>>(
        future: performances,
        // future: fetchTimetableData('http://grzybek.bymarcin.com:8081/getAll'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // switch (snapshot.connectionState) {

          //   case ConnectionState.none:
          //     // TODO: Handle this case.
          //     break;
          //   case ConnectionState.waiting:
          //     // TODO: Handle this case.
          //     break;
          //   case ConnectionState.active:
          //     // TODO: Handle this case.
          //     break;
          //   case ConnectionState.done:
          //     // TODO: Handle this case.
          //     break;
          // }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int i) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Text(snapshot.data[i].problem),
                        Text(snapshot.data[i].age),
                        Text(snapshot.data[i].stage),
                      ],
                    ),
                    Row( 
                      children: [
                        Text(snapshot.data[i].performance),
                        Text(snapshot.data[i].team),
                        Text(snapshot.data[i].spontan),
                        // Text(snapshot.data[i].id.toString()),
                        // Text(snapshot.data[i].city),
                      ]
                    ),
                    Divider(),
                  ]
                );
              }
            );
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        }
      )
    );
  }  
}
    
// class