// Nama : Yuandika Purnama H.
// Nim  : 222410102012
// PBM A

import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(TimerApp());

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('TIMER APP'),
          ),
          body: TimerPage(),
        ));
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _timeLeft = 0; // Time in seconds

  final TextEditingController _textController = TextEditingController();

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel(); // Cancel any existing timer
    }

    final enteredTime = int.tryParse(_textController.text) ?? 0;
    setState(() {
      _timeLeft = enteredTime * 60; // Ensure time is in seconds
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer!.cancel();
        setState(() {
          _timeLeft = -1; // Use -1 to indicate timer completion
        });
      }
    });
  }

  void _resetTimer() {
    setState(() {
      final enteredTime = int.tryParse(_textController.text) ?? 0;
      _timeLeft = enteredTime * 60; // Reset time in seconds
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _timeLeft = 0; // Set time to 0 on stop
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayTime;
    if (_timeLeft == -1) {
      displayTime = 'Waktu Habis !'; // Use 'Waktu Habis' for consistency
    } else {
      final minutes = _timeLeft ~/ 60;
      final seconds = (_timeLeft % 60).toString().padLeft(2, '0');
      displayTime = '$minutes:$seconds';
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Masukkan Durasi (Menit)'),
            SizedBox(height: 8),
            TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Menit',
              ),
            ),
            SizedBox(height: 24),
            Text(
              displayTime,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 24),
            _timeLeft != -1 // Conditional widget based on timer state
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _startTimer,
                        child: Text('Mulai'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _stopTimer,
                        child: Text('Berhenti'),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _resetTimer,
                    child: Text('Mulai Ulang'),
                  ),
          ],
        ),
      ),
    );
  }
}
