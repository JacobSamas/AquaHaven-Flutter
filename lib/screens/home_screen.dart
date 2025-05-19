import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aquahaven/models/fish.dart';
import 'package:aquahaven/screens/fish_detail_screen.dart';
import 'package:aquahaven/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> categories = [
    {'icon': Icons.waves, 'label': 'Freshwater', 'color': Colors.blue},
    {'icon': Icons.water_drop, 'label': 'Marine', 'color': Colors.teal},
    {'icon': Icons.filter_vintage, 'label': 'Plants', 'color': Colors.green},
    {'icon': Icons.bolt, 'label': 'Equipment', 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'AquaHaven',
                style: GoogleFonts.pacifico(
                  color: Colors.white,
                  fontSize: 28,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // TODO: Implement search functionality
                },
              ),
            ],
          ),
          
          // Main Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to AquaHaven',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Find everything for your aquarium',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Categories Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                
                // Categories Grid
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: HomeScreen.categories.length,
                    itemBuilder: (context, index) {
                      final category = HomeScreen.categories[index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () {
                              // TODO: Navigate to category
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  category['icon'] as IconData,
                                  size: 32,
                                  color: category['color'] as Color,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  category['label'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Trending Fish Section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending Now',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Trending Fish List
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // Sample count
                    itemBuilder: (context, index) {
                      final fishNames = [
                        'Neon Tetra',
                        'Betta Fish',
                        'Guppy',
                        'Angelfish',
                        'Goldfish'
                      ];
                      final fishPrices = [
                        '\$4.99',
                        '\$9.99',
                        '\$3.99',
                        '\$12.99',
                        '\$2.99'
                      ];
                      
                      final fish = Fish(
                        id: 'fish_$index',
                        name: fishNames[index],
                        scientificName: 'Scientific $index',
                        description: 'A beautiful ${fishNames[index].toLowerCase()} that thrives in community tanks.',
                        size: '${index + 2} inches',
                        temperature: '72-82°F',
                        phRange: '6.5-7.5',
                        temperament: index % 3 == 0 ? 'Peaceful' : 'Semi-aggressive',
                        price: double.parse(fishPrices[index].replaceAll(RegExp(r'[^0-9.]'), '')),
                        origin: 'South America',
                        lifespan: '3-5 years',
                        careLevel: Difficulty.values[index % 3],
                        diet: 'Omnivore',
                        tankSize: '10+ gallons',
                        compatibleFish: ['Tetras', 'Guppies', 'Corydoras'],
                        images: [],
                      );
                      
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FishDetailScreen(fish: fish),
                            ),
                          );
                        },
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Fish Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12.0),
                                  ),
                                  child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    color: Colors.blue[50],
                                    child: Icon(
                                      Icons.pets,
                                      size: 40,
                                      color: Colors.blue[300],
                                    ),
                                  ),
                                ),
                                // Fish Info
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fish.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${fish.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Special Offer Banner
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Special Offer!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Get 20% off on your first purchase',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to shop
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                          ),
                          child: const Text(
                            'Shop Now',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Add some bottom padding
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
