import 'dart:async';

import 'package:flutter/material.dart';


class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final int hours = 12;
  late Timer _timer;
  bool _isTimerRunning = false;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    if (_timerShouldStart()) {
      startTimer();
    }
  }

  bool _timerShouldStart() {
    // Check if the previous timer was running and if it has not ended yet
    if (_endTime != null && DateTime.now().isBefore(_endTime)) {
      _startTimerFromPreviousEndTime();
      return false;
    }
    return true;
  }

  void _startTimerFromPreviousEndTime() {
    final remainingTime = _endTime.difference(DateTime.now());
    _startTimer(remainingTime);
  }

  void startTimer() {
    final duration = Duration(hours: hours);
    _endTime = DateTime.now().add(duration);
    _startTimer(duration);
    _isTimerRunning = true;
  }

  void _startTimer(Duration duration) {
    _timer = Timer(duration, () {
      // Call your function here when the timer ends
      onTimerEnd();
    });
  }

  void onTimerEnd() {
    // Your function to be called when the timer ends
    print('Timer ended!');
    // Add your function calls or logic here
    setState(() {
      _isTimerRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 50,
      width: 200,
      child: Text(
        'Timer Running: $_isTimerRunning',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}