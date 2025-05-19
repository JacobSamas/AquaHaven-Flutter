import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/fish.dart';

class FishDetailWidget extends StatelessWidget {
  final Fish fish;
  
  const FishDetailWidget({
    Key? key, 
    required this.fish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                fish.name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(0, 1),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: 'fish-${fish.id}-image',
                child: fish.imageUrl != null && fish.imageUrl!.isNotEmpty
                    ? Image.network(
                        fish.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error, color: Colors.red, size: 50),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareFish(context),
              ),
            ],
          ),
          
          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scientific Name and Care Level
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fish.scientificName,
                        style: GoogleFonts.roboto(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCareLevelColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${fish.careLevelText} ${fish.careLevelEmoji}',
                          style: GoogleFonts.roboto(
                            color: _getCareLevelColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    fish.description,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Quick Facts
                  _buildSectionTitle('Quick Facts'),
                  const SizedBox(height: 12),
                  _buildInfoGrid(),
                  const SizedBox(height: 24),
                  
                  // Gallery
                  if (fish.images?.isNotEmpty ?? false) ...[
                    _buildSectionTitle('Gallery'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fish.images?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                fish.images?[index] ?? '',
                                width: 160,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Compatible Fish
                  if (fish.compatibleFish?.isNotEmpty ?? false) ...[
                    _buildSectionTitle('Compatible Tank Mates'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: fish.compatibleFish!
                          .map((fishName) => _buildCompatibleFishChip(fishName))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 32),
                  
                  // Learn More Button
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.search, size: 20),
                      label: const Text('Learn More Online'),
                      onPressed: () => _searchFishOnline(fish.name),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.blueGrey[800],
      ),
    );
  }
  
  Widget _buildInfoGrid() {
    final infoItems = <_InfoItem>[];
    
    // Only add non-null and non-empty values
    if (fish.size.isNotEmpty) {
      infoItems.add(_InfoItem(Icons.straighten, 'Size', fish.size));
    }
    if (fish.temperature.isNotEmpty) {
      infoItems.add(_InfoItem(Icons.thermostat, 'Temperature', fish.temperature));
    }
    if (fish.phRange.isNotEmpty) {
      infoItems.add(_InfoItem(Icons.water_drop, 'pH Range', fish.phRange));
    }
    if (fish.lifespan?.isNotEmpty ?? false) {
      infoItems.add(_InfoItem(Icons.timelapse, 'Lifespan', fish.lifespan!));
    }
    if (fish.origin?.isNotEmpty ?? false) {
      infoItems.add(_InfoItem(Icons.water, 'Origin', fish.origin!));
    }
    if (fish.diet?.isNotEmpty ?? false) {
      infoItems.add(_InfoItem(Icons.restaurant, 'Diet', fish.diet!));
    }
    if (fish.temperament.isNotEmpty) {
      infoItems.add(_InfoItem(Icons.people, 'Temperament', fish.temperament));
    }
    if (fish.tankSize?.isNotEmpty ?? false) {
      infoItems.add(_InfoItem(Icons.square_foot, 'Tank Size', fish.tankSize!));
    }
    
    if (infoItems.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: infoItems.length,
      itemBuilder: (context, index) {
        final item = infoItems[index];
        return _buildInfoTile(item.icon, item.title, item.value);
      },
    );
  }
  
  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.blueGrey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[900],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompatibleFishChip(String fishName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Text(
        fishName,
        style: GoogleFonts.roboto(
          color: Colors.green[800],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Color _getCareLevelColor() {
    if (fish.careLevel == null) return Colors.grey;
    
    switch (fish.careLevel!) {
      case Difficulty.beginner:
        return Colors.green;
      case Difficulty.intermediate:
        return Colors.orange;
      case Difficulty.expert:
        return Colors.red;
    }
  }
  
  void _shareFish(BuildContext context) {
    final text = 'Check out ${fish.name} (${fish.scientificName}) on AquaHaven! 🐠\n\n${fish.description}';
    Share.share(text);
  }
  
  void _searchFishOnline(String query) async {
    final url = 'https://www.google.com/search?q=${Uri.encodeComponent('$query ${fish.scientificName} aquarium care')}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }
}

class _InfoItem {
  final IconData icon;
  final String title;
  final String value;
  
  _InfoItem(this.icon, this.title, this.value);
}
