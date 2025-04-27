import 'package:flutter/material.dart';
import '../data/dummy_fish.dart';
import '../widgets/fish_card.dart';
import 'fish_detail_screen.dart';

class FishListScreen extends StatelessWidget {
  const FishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aquarium Fish'),
      ),
      body: ListView.builder(
        itemCount: dummyFish.length,
        itemBuilder: (ctx, idx) {
          final fish = dummyFish[idx];
          return FishCard(
            fish: fish,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FishDetailScreen(fish: fish),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
