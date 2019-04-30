import 'dart:math';
import 'package:flutter/material.dart';

enum Direction { up, down }

Direction changeDirection(Direction oldDirection) {
  return oldDirection == Direction.up ? Direction.down : Direction.up;
}

Direction randomDirection() {
  return Random().nextInt(2) == 0 ? Direction.up : Direction.down;
}

/// A widget that bounces around the perimeter of its containing Stack
/// like the classic DVD menu icon.
///
/// [CornerBouncer] must reside nested beneath a [LayoutBuilder] and then
/// a [Stack]. The [LayoutBuilder] is required for the [CornerBouncer] to
/// understand and calculate its constraints, and the [Stack] is required
/// to act on that knowledge via a [Positioned] widget.
class CornerBouncer extends StatefulWidget {
  final Widget child;
  final double xStart;
  final double yStart;
  final Direction xDirection;
  final Direction yDirection;
  final double childHeight;
  final double childWidth;
  final double containerHeight;
  final double containerWidth;
  final double secondsTopToBottom;
  CornerBouncer({
    Key key,
    /// The child widget that will bounce around the wrapping [Stack]
    @required this.child,
    /// Optional parameter to define the amount of logical pixels,
    /// from the left boundary of the surrounding stack, where the
    /// widget will first appear
    this.xStart,
    /// Optional parameter to define the amount of logical pixels,
    /// from the top boundary of the surrounding stack, where the
    /// widget will first appear
    this.yStart,
    /// Optional parameter to define the initial horizontal direction of
    /// travel for our child widget. `Direction.up` is left-to-right travel.
    this.xDirection,
    /// Optional parameter to define the initial vertical direction of
    /// travel for our child widget.
    this.yDirection,
    /// Vertical size of the child widget, required to correctly
    /// know when its bottom boundary will be colliding with the
    /// bottom of the containing [Stack]
    @required this.childHeight,
    /// Horizontal size of the child widget, required to correctly
    /// know when its right boundary will be colliding with the
    /// bottom of the containing [Stack]
    @required this.childWidth,
    /// Vertical size of the containing [Stack], as provided by
    /// the [LayoutBuilder]'s `constraints.maxHeight` parameter
    @required this.containerHeight,
    /// Horizontal size of the containing [Stack], as provided by
    /// the [LayoutBuilder]'s `constraints.maxWidth` parameter
    @required this.containerWidth,
    /// Speed controls on the bouncing child widget. Smaller numbers
    /// result in faster traversals across the containing [Stack]
    this.secondsTopToBottom = 3.0,
  }) : super(key: key);

  _CornerBouncerState createState() => _CornerBouncerState(
    xStart: this.xStart,
    yStart: this.yStart,
    xDirection: this.xDirection,
    yDirection: this.yDirection,
  );
}

class _CornerBouncerState extends State<CornerBouncer> with TickerProviderStateMixin {
  AnimationController _childBouncerController;
  Animation<double> _animation;

  double xStart;
  double yStart;

  double xPos;
  double yPos;

  double xDistance;
  double yDistance;

  Direction xDirection;
  Direction yDirection;

  double runTimeMS;

  double get xPlayArea => widget.containerWidth - widget.childWidth;
  double get yPlayArea => widget.containerHeight - widget.childHeight;
  double get pixelsPerMillisecond => yPlayArea / widget.secondsTopToBottom / 1000;

  _CornerBouncerState({this.xStart, this.yStart, this.xDirection, this.yDirection});

  @override
  void initState() {
    super.initState();
    xDirection = xDirection ?? randomDirection();
    yDirection = yDirection ?? randomDirection();
    Random random = Random();
    xPos = xStart ?? random.nextDouble() * xPlayArea;
    yPos = yStart ?? random.nextDouble() * yPlayArea;
    startAnimation();
  }

  /// Kicks off a single animation that directs `child` at a 45° angle toward one
  /// of the boundaries. At that time, this animation ends, but a `statusListener`
  /// will promptly reverse any appropriate directions and kick off a new animation,
  /// again at a 45° angle, toward the next boundary. And on and on...
  void startAnimation() {
    xStart = xPos;
    yStart = yPos;

    yDistance = yDirection == Direction.up ? yPlayArea - yPos : yPos;
    xDistance = xDirection == Direction.up ? xPlayArea - xPos : xPos;

    double shorterDistance = xDistance < yDistance ? xDistance : yDistance;
    runTimeMS = shorterDistance / pixelsPerMillisecond;

    _childBouncerController = AnimationController(duration: Duration(milliseconds: runTimeMS.round()), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1.0).animate(_childBouncerController)
      ..addListener(() {
        setState(() {
          double delta = runTimeMS * _animation.value * pixelsPerMillisecond;
          if (xDirection == Direction.up) {
            xPos = xStart + delta;
          } else {
            xPos = xStart - delta;
          }

          if (yDirection == Direction.up) {
            yPos = yStart + delta;
          } else {
            yPos = yStart - delta;
          }
        });
      })
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          if ((xPos < 10 && xDirection == Direction.down) || ((xPlayArea - xPos) < 10) && xDirection == Direction.up) {
            xDirection = changeDirection(xDirection);
          }
          if ((yPos < 10 && yDirection == Direction.down) || ((yPlayArea - yPos) < 10) && yDirection == Direction.up) {
            yDirection = changeDirection(yDirection);
          }
          startAnimation();
        }
      });

    _childBouncerController.forward();
  }

  void dispose() {
    _childBouncerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPos,
      left: xPos,
      child: widget.child,
    );
  }
}
