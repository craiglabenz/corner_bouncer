import 'package:corner_bouncer/corner_bouncer.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Corner Bouncer'),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                CornerBouncer(
                  child: FlutterLogo(
                    size: 100,
                  ),
                  childHeight: 100,
                  childWidth: 100,
                  containerWidth: constraints.maxWidth,
                  containerHeight: constraints.maxHeight,
                ),
                CornerBouncer(
                  child: Container(
                    color: Colors.red,
                    height: 50,
                    width: 100,
                  ),
                  childHeight: 50,
                  childWidth: 100,
                  containerWidth: constraints.maxWidth,
                  containerHeight: constraints.maxHeight,
                ),
                CornerBouncer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    height: 50,
                    width: 50,
                  ),
                  childHeight: 50,
                  childWidth: 50,
                  containerWidth: constraints.maxWidth,
                  containerHeight: constraints.maxHeight,
                ),
              ],
            );
          },
        )
      ),
    );
  }
}
