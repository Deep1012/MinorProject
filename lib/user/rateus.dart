import 'package:flutter/material.dart';

class RateUs extends StatefulWidget {
  const RateUs({super.key});

  @override
  State<RateUs> createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  int? _rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Us'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Rate Our App',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            _buildStarRating(),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: _rating != null ? _submitRating : null,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.white), // Background color
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Rounded corners
                  ),
                ),
                elevation: WidgetStateProperty.all<double>(5.0), // Shadow
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.deepPurpleAccent.withOpacity(
                          0.5); // Change to accent color when pressed
                    }
                    return null; // Use the default overlay color
                  },
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildStar(1),
        _buildStar(2),
        _buildStar(3),
        _buildStar(4),
        _buildStar(5),
      ],
    );
  }

  Widget _buildStar(int index) {
    return IconButton(
      iconSize: _rating != null && index <= _rating! ? 45.0 : 40.0,
      icon: Icon(
        _rating == null || _rating! < index ? Icons.star_border : Icons.star,
        color:
            _rating != null && index <= _rating! ? Colors.amber : Colors.grey,
      ),
      onPressed: () => _setRating(index),
    );
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  void _submitRating() {
    if (_rating != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thank You!'),
            content: Text(
                'Thank you for rating us $_rating stars! Your feedback is valuable to us.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: RateUs(),
  ));
}
