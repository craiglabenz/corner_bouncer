# corner_bouncer

A simple Flutter widget that bounces around the boundaries of its container, ala that classic DVD menu icon.

## Getting Started

To use the `CornerBouncer` widget in your Flutter project, you need only wrap it in a `LayoutBuilder` and then a `Stack`. These are excellent for adding a little life to a `Scaffold` background, or for programming a Pong client.

```dart
import 'package:corner_bouncer/corner_bouncer.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corner Bouncer Demo',
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
              ],
            );
          },
        )
      ),
    );
  }
}
```

<img src="https://raw.githubusercontent.com/craiglabenz/corner_bouncer/master/doc/assets/example.gif" alt="Example" height="600" />
