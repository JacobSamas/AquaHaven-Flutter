import 'package:flutter/material.dart';
import '../models/fish.dart';
import '../widgets/fish_detail_widget.dart';

class FishDetailScreen extends StatelessWidget {
  final Fish fish;
  const FishDetailScreen({Key? key, required this.fish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fish.name),
      ),
      body: FishDetailWidget(fish: fish),
    );
  }
}
