import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BirthdayScreen(),
    );
  }
}

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  DateTime? _selectedDate;
  String _age = '';
  late AudioPlayer _audioPlayer;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _playBirthdaySong() async {
    await _audioPlayer.play(AssetSource('audio/its_my_birthday.mp3'));
  }

  Future<void> _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _calculateAge();
        _confettiController.play(); // Trigger confetti animation
        _playBirthdaySong(); // Play birthday song
      });
    }
  }

  void _calculateAge() {
    if (_selectedDate != null) {
      DateTime now = DateTime.now();
      int years = now.year - _selectedDate!.year;
      if (now.month < _selectedDate!.month ||
          (now.month == _selectedDate!.month && now.day < _selectedDate!.day)) {
        years--;
      }
      _age = years.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("It's My Birthday!"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "When is your birthday?",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showDatePicker,
                  child: const Text("Select your Birthday"),
                ),
                if (_selectedDate != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Your birthday is on: ${DateFormat('MMMM d, yyyy').format(_selectedDate!)}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "You are $_age years old!",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ]
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.blue,
                Colors.green,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }
}
