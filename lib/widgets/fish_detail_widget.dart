import 'package:flutter/material.dart';
import '../models/fish.dart';

class FishDetailWidget extends StatelessWidget {
  final Fish fish;
  const FishDetailWidget({Key? key, required this.fish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(fish.imageUrl, width: 180, height: 180, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          Text('Species: ${fish.species}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Text(fish.description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
