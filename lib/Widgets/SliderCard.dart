import 'package:flutter/material.dart';

class SliderCard extends StatelessWidget {
  final int selectedNumQuestions;
  final Function(int) onChanged;

  const SliderCard({
    Key? key,
    required this.selectedNumQuestions,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_list_numbered, color: Colors.purpleAccent),
                SizedBox(width: 8),
                Text("Nombre de questions : $selectedNumQuestions",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: selectedNumQuestions.toDouble(),
              min: 5,
              max: 20,
              divisions: 3,
              label: selectedNumQuestions.toString(),
              onChanged: (value) {
                onChanged(value.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }
}
