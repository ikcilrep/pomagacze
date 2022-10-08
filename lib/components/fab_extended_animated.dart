/*
https://github.com/ajomuch92/flutter-scrolling-fab-animated/

MIT License

Copyright (c) 2021

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

/// Widget to animate the button when scroll down
class ScrollingFabAnimated extends StatefulWidget {
  /// Function to use when press the button
  final GestureTapCallback? onPress;

  /// Double value to set the button elevation
  final double? elevation;

  /// Double value to set the button width
  final double? width;

  /// Double value to set the button height
  final double? height;

  /// Value to set the duration for animation
  final Duration? duration;

  /// Widget to use as button icon
  final Widget? icon;

  /// Widget to use as button text when button is expanded
  final Widget? text;

  /// Value to set the curve for animation
  final Curve? curve;

  /// ScrollController to use to determine when user is on top or not
  final ScrollController? scrollController;

  /// Double value to set the boundary value when scroll animation is triggered
  final double? limitIndicator;

  /// Color to set the button background color
  final Color? color;

  /// Value to indicate if animate or not the icon
  final bool? animateIcon;

  /// Value to inverte the behavior of the animation
  final bool? inverted;

  /// Double value to set the button radius
  final double? radius;

  const ScrollingFabAnimated(
      {Key? key,
      required this.icon,
      required this.text,
      required this.onPress,
      required this.scrollController,
      this.elevation = 5.0,
      this.width = 120.0,
      this.height = 60.0,
      this.duration = const Duration(milliseconds: 250),
      this.curve,
      this.limitIndicator = 10.0,
      this.color,
      this.animateIcon = true,
      this.inverted = false,
      this.radius})
      : super(key: key);

  @override
  _ScrollingFabAnimatedState createState() => _ScrollingFabAnimatedState();
}

class _ScrollingFabAnimatedState extends State<ScrollingFabAnimated> {
  /// Double value for tween ending
  double _endTween = 100;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    if (widget.inverted!) {
      setState(() {
        _endTween = 0;
      });
    }
    _handleScroll();
  }

  @override
  void dispose() {
    widget.scrollController!.removeListener(() {});
    super.dispose();
  }

  /// Function to add listener for scroll
  void _handleScroll() {
    ScrollController _scrollController = widget.scrollController!;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > widget.limitIndicator! &&
          _scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
        setState(() {
          _endTween = widget.inverted! ? 100 : 0;
        });
      } else if (_scrollController.position.pixels <= widget.limitIndicator! &&
          _scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
        setState(() {
          _endTween = widget.inverted! ? 0 : 100;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(widget.radius ?? (widget.height! / 2)))),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: _endTween),
          duration: widget.duration!,
          builder: (BuildContext _, double size, Widget? child) {
            double _widthPercent = (widget.width! - widget.height!).abs() / 100;
            bool _isFull = _endTween == 100;
            double _radius = widget.radius ?? (widget.height! / 2);
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(_radius)),
                  color: widget.color ?? Theme.of(context).primaryColor),
              height: widget.height,
              width: widget.height! + _widthPercent * size,
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular((widget.radius ?? (widget.height! / 2))),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onPress,
                        child: Row(
                          mainAxisAlignment: _isFull
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.center,
                          children: [
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Transform.rotate(
                                  angle: widget.animateIcon!
                                      ? (3.6 * math.pi / 180) * size
                                      : 0,
                                  child: widget.icon,
                                )),
                            ...(_isFull
                                ? [
                                    Expanded(
                                      child: AnimatedOpacity(
                                        opacity: size > 90 ? 1 : 0,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        child: widget.text!,
                                      ),
                                    )
                                  ]
                                : []),
                          ],
                        ),
                      ))),
            );
          },
        ));
  }
}
