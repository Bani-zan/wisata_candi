import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget{


  const ItemCard({super.key });


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset('assets/img/candi1.jpg'),
          const SizedBox(height: 8),
          const Text('Candi Borobudur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Magelang, Jawa Tengah', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}