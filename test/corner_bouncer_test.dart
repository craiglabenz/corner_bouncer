import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:corner_bouncer/corner_bouncer.dart';
typedef cornerBouncerBuilder = CornerBouncer Function(double height, double width, {Direction xDirection, Direction yDirection});

Function builder = (double height, double width, {Direction xDirection = Direction.up, Direction yDirection = Direction.down}) {
  return CornerBouncer(
    key: Key('bouncer'),
    child: Text('bounce me'),
    childHeight: 100,
    childWidth: 100,
    containerHeight: height,
    containerWidth: width,
    xDirection: xDirection,
    yDirection: yDirection,
    xStart: 1,
    yStart: 1,
  );
};

void main() {

  Widget makeTestableWidget(cornerBouncerBuilder, {Direction xDirection = Direction.up, Direction yDirection = Direction.down}) {
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                cornerBouncerBuilder(constraints.maxHeight, constraints.maxWidth, xDirection: xDirection, yDirection: yDirection),
              ],
            );
          }
        )
      )
    );
  }
  testWidgets('renders widget in a scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(builder));
    expect(find.text('bounce me'), findsOneWidget);
  });

  testWidgets('widget moves in specified direction', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(builder));
    Finder bouncer = find.byKey(Key('bouncer'));
    Offset off = tester.getCenter(bouncer);
    await tester.pump(Duration(seconds: 1));
    Offset off2 = tester.getCenter(bouncer);
    expect(off2.dx > off.dx, true);
    expect(off2.dy < off.dy, true);
  });

  testWidgets('widget moves in new specified direction', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(builder, yDirection: Direction.up));
    Finder bouncer = find.byKey(Key('bouncer'));
    Offset off = tester.getCenter(bouncer);
    await tester.pump(Duration(seconds: 1));
    Offset off2 = tester.getCenter(bouncer);
    expect(off2.dx > off.dx, true);
    expect(off2.dy > off.dy, true);
  });
}
