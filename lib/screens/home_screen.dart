import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aquahaven/models/fish.dart';
import 'package:aquahaven/screens/fish_detail_screen.dart';

extension StringExtensions on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }
  
  String pascalToTitleCase() {
    if (isEmpty) return this;
    return replaceAllMapped(
      RegExp(r'^([a-z])|[A-Z]'),
      (Match m) => m[1] == null ? m[0]! : ' ${m[0]!}',
    ).trim();
  }
}

class FishSearchDelegate extends SearchDelegate<Fish?> {
  final List<Fish> fishes;
  
  FishSearchDelegate(this.fishes);
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    final results = fishes.where((fish) {
      final queryLower = query.toLowerCase();
      return fish.name.toLowerCase().contains(queryLower) ||
             fish.scientificName.toLowerCase().contains(queryLower) ||
             fish.description.toLowerCase().contains(queryLower);
    }).toList();
    
    return _buildSearchResults(results);
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Start typing to search for fish'),
      );
    }
    
    final results = fishes.where((fish) {
      final queryLower = query.toLowerCase();
      return fish.name.toLowerCase().contains(queryLower) ||
             fish.scientificName.toLowerCase().contains(queryLower);
    }).toList();
    
    return _buildSearchResults(results);
  }
  
  Widget _buildSearchResults(List<Fish> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text('No fish found matching your search'),
      );
    }
    
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final fish = results[index];
        return ListTile(
          leading: fish.imageUrl != null
              ? Image.network(
                  fish.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.pets, size: 50),
          title: Text(fish.name),
          subtitle: Text(fish.scientificName),
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
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  // Search and filter state
  String? _selectedCategory;
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.waves, 'label': 'Freshwater', 'color': Colors.blue, 'value': 'freshwater'},
    {'icon': Icons.water_drop, 'label': 'Marine', 'color': Colors.teal, 'value': 'saltwater'},
    {'icon': Icons.filter_vintage, 'label': 'Plants', 'color': Colors.green, 'value': 'plant'},
    {'icon': Icons.bolt, 'label': 'Equipment', 'color': Colors.orange, 'value': 'equipment'},
  ];
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Fish> get _filteredFish {
    // Using a sample list for now - in a real app, this would come from an API or database
    final sampleFish = [
      Fish(
        id: '1',
        name: 'Neon Tetra',
        scientificName: 'Paracheirodon innesi',
        description: 'A small, colorful freshwater fish popular in community aquariums.',
        size: '1.5 inches',
        temperature: '70-81°F',
        phRange: '6.0-7.0',
        price: 2.99,
        temperament: 'Peaceful',
        categories: [FishCategory.freshwater, FishCategory.community],
      ),
      Fish(
        id: '2',
        name: 'Betta Fish',
        scientificName: 'Betta splendens',
        description: 'A colorful and popular freshwater fish known for its flowing fins and vibrant colors.',
        size: '2.5 inches',
        temperature: '76-82°F',
        phRange: '6.5-7.5',
        price: 4.99,
        temperament: 'Aggressive',
        categories: [FishCategory.freshwater],
      ),
      Fish(
        id: '3',
        name: 'Clownfish',
        scientificName: 'Amphiprioninae',
        description: 'A colorful saltwater fish that lives in symbiosis with sea anemones.',
        size: '3 inches',
        temperature: '75-82°F',
        phRange: '8.0-8.4',
        price: 29.99,
        temperament: 'Semi-aggressive',
        categories: [FishCategory.saltwater],
      ),
      Fish(
        id: '4',
        name: 'Java Fern',
        scientificName: 'Microsorum pteropus',
        description: 'A hardy aquatic plant that is great for beginners.',
        size: '8-12 inches',
        temperature: '68-82°F',
        phRange: '6.0-7.5',
        price: 5.99,
        temperament: 'Peaceful',
        categories: [FishCategory.plant],
      ),
    ];
    
    // Apply search query filter
    Iterable<Fish> filtered = sampleFish;
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      // Try to parse the query as a number to handle price searches
      final queryNumber = double.tryParse(query.replaceAll(RegExp(r'[^0-9.]'), ''));
      
      filtered = filtered.where((fish) {
        // Check name, scientific name, and description
        if (fish.name.toLowerCase().contains(query) ||
            fish.scientificName.toLowerCase().contains(query) ||
            fish.description.toLowerCase().contains(query)) {
          return true;
        }
        
        // Check if the query can be parsed as a number and matches the price
        if (queryNumber != null) {
          return fish.price == queryNumber ||
                 fish.price.toStringAsFixed(2).contains(query);
        }
        
        return false;
      });
    }
    
    // Apply category filter if selected
    if (_selectedCategory != null) {
      filtered = filtered.where((fish) => 
        fish.categories.any((category) => 
          category.toString().toLowerCase().contains(_selectedCategory!.toLowerCase())
        )
      );
    }
    
    return filtered.toList();
  }
  
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = null;
      _searchController.clear();
    });
  }
  
  // Build a chip to show active filters
  Widget _buildActiveFilterChip(String label, VoidCallback onDeleted) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.blue[100],
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDeleted,
      ),
    );
  }
  
  void _onSearchTap() {
    showSearch(
      context: context,
      delegate: FishSearchDelegate(_filteredFish),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Get filtered fish based on search query
    final displayedFish = _filteredFish;
    
    // Show empty state if no fish match the search
    if (displayedFish.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AquaHaven'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _onSearchTap,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'No fish found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Try a different search term'),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear filters'),
              ),
            ],
          ),
        ),
      );
    }
    
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
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
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
                onPressed: _onSearchTap,
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
                
                // Active Filters
                if (_selectedCategory != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Active Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          children: [
                            _buildActiveFilterChip(
                              '${_selectedCategory![0].toUpperCase()}${_selectedCategory!.substring(1)}',
                              () {
                                setState(() {
                                  _selectedCategory = null;
                                });
                              },
                            ),
                          ],
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
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: _selectedCategory == category['value'] 
                              ? (category['color'] as Color).withOpacity(0.2)
                              : null,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () {
                              setState(() {
                                _selectedCategory = _selectedCategory == category['value'] 
                                    ? null 
                                    : category['value'] as String?;
                              });
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
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: _selectedCategory == category['value'] 
                                        ? FontWeight.bold 
                                        : FontWeight.w500,
                                    color: _selectedCategory == category['value']
                                        ? (category['color'] as Color)
                                        : Colors.blueGrey,
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
                        4.99,
                        9.99,
                        3.99,
                        12.99,
                        2.99
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
                        price: fishPrices[index],
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
