import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fish.dart';
import '../widgets/fish_card.dart';
import '../providers/fish_provider.dart';

// Define theme colors
class AppColors {
  static const primaryColor = Color(0xFF1976D2);
  static const backgroundColor = Color(0xFFF5F5F5);
  static const textColor = Colors.black87;
  static const secondaryTextColor = Color(0xFF757575);
  
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
  );
}

class FishListScreen extends StatefulWidget {
  const FishListScreen({Key? key}) : super(key: key);

  @override
  State<FishListScreen> createState() => _FishListScreenState();
}

class _FishListScreenState extends State<FishListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedDifficulty = 'All';
  String _selectedType = 'All';

  final List<String> _difficultyLevels = ['All', '0', '1', '2']; // 0: Beginner, 1: Intermediate, 2: Expert
  final List<String> _fishTypes = ['All', 'Freshwater', 'Saltwater', 'Brackish'];

  List<Fish> get _filteredFish {
    final fishProvider = Provider.of<FishProvider>(context, listen: false);
    return fishProvider.fishList.where((fish) {
      final nameMatches = fish.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          fish.scientificName.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final difficultyMatches = _selectedDifficulty == 'All' || 
          (fish.careLevel != null && fish.careLevel!.index.toString() == _selectedDifficulty);
      
      // This is a simplified type filter - in a real app, you'd want to have a type property on your Fish model
      final typeMatches = _selectedType == 'All' || true; 
      
      return nameMatches && difficultyMatches && typeMatches;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Aquarium Fish',
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  fontFamily: 'Poppins',
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search fish...',
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Filter Chips
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFilterChip('Difficulty: $_selectedDifficulty', Icons.flag, () {
                            _showDifficultyFilter();
                          }),
                          const SizedBox(width: 8),
                          _buildFilterChip('Type: $_selectedType', Icons.water_drop, () {
                            _showTypeFilter();
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Fish List
          _filteredFish.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Text('No fish found. Try adjusting your filters.', style: TextStyle(color: AppColors.textColor)),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final fish = _filteredFish[index];
                        return FishCard(
                          fish: fish,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text(fish.name),
                              ),
                              body: Center(
                                child: Text('Fish details for ${fish.name}'),
                              ),
                            ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _filteredFish.length,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement add fish functionality
        },
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Fish', style: TextStyle(color: AppColors.textColor)),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primaryColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDifficultyFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Filter by Difficulty',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ..._difficultyLevels.map((level) {
              return RadioListTile<String>(
                title: Text(level == '0' ? 'Beginner' : 
                                       level == '1' ? 'Intermediate' : 
                                       level == '2' ? 'Expert' : 'All'),
                value: level,
                groupValue: _selectedDifficulty,
                onChanged: (value) {
                  setState(() {
                    _selectedDifficulty = value!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  void _showTypeFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Filter by Type',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ..._fishTypes.map((type) {
              return RadioListTile<String>(
                title: Text(type),
                value: type,
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
