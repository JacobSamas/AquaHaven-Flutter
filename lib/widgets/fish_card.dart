import 'package:flutter/material.dart';
import '../models/fish.dart';

class FishCard extends StatelessWidget {
  final Fish fish;
  final VoidCallback onTap;
  const FishCard({Key? key, required this.fish, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.asset(fish.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
        title: Text(fish.name),
        subtitle: Text(fish.species),
        onTap: onTap,
      ),
    );
  }
}
