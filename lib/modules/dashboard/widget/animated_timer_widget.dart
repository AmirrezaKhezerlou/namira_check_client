import 'package:flutter/material.dart';
import 'dart:async';


class AnimatedCountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onFinished;
  final double widgetSize;

  const AnimatedCountdownTimer({
    Key? key,
    required this.duration,
    this.widgetSize = 1.0,
    required this.onFinished,
  }) : super(key: key);

  @override
  _AnimatedCountdownTimerState createState() => _AnimatedCountdownTimerState();
}

class _AnimatedCountdownTimerState extends State<AnimatedCountdownTimer>
    with SingleTickerProviderStateMixin {
  late Duration remainingTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds <= 1) {
        widget.onFinished();
        setState(() {
          remainingTime = widget.duration;
        });
      } else {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimatedBox(minutes),
        SizedBox(width: 10 * widget.widgetSize),
        Text(
          ":",
          style: TextStyle(
            fontSize: 48 * widget.widgetSize,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 10 * widget.widgetSize),
        _buildAnimatedBox(seconds),
      ],
    );
  }

  Widget _buildAnimatedBox(String value) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Container(
        key: ValueKey<String>(value),
        padding: EdgeInsets.symmetric(
          vertical: 8 * widget.widgetSize,
          horizontal: 16 * widget.widgetSize,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8 * widget.widgetSize),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4 * widget.widgetSize,
              offset: Offset(2 * widget.widgetSize, 2 * widget.widgetSize),
            ),
          ],
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 48 * widget.widgetSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}