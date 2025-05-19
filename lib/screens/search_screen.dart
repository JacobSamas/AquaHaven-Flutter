import 'package:flutter/material.dart';
import 'package:aquahaven/models/fish.dart';
import 'package:aquahaven/screens/fish_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Fish> _recentSearches = [];
  final List<Fish> _popularSearches = [];
  bool _showFilters = false;
  
  // Filter states
  String? _selectedCategory;
  String? _selectedSize;
  String? _selectedDifficulty;
  
  final List<String> _categories = ['Freshwater', 'Marine', 'Plants', 'Equipment'];
  final List<String> _sizes = ['Small', 'Medium', 'Large'];
  final List<String> _difficulties = ['Easy', 'Moderate', 'Hard'];

  @override
  void initState() {
    super.initState();
    // TODO: Load recent and popular searches from local storage
    _loadSampleData();
  }
  
  void _loadSampleData() {
    // Sample data - in a real app, this would come from an API
    setState(() {
      _recentSearches.addAll([
        Fish(
          id: '1',
          name: 'Neon Tetra',
          scientificName: 'Paracheirodon innesi',
          description: 'Peaceful community fish',
          size: '1.5 inches',
          temperature: '72-80°F',
          phRange: '6.0-7.0',
          price: 3.99,
          temperament: 'Peaceful',
          categories: [FishCategory.freshwater, FishCategory.community],
        ),
      ]);
      
      _popularSearches.addAll([
        Fish(
          id: '2',
          name: 'Betta Fish',
          scientificName: 'Betta splendens',
          description: 'Colorful and popular aquarium fish',
          size: '2.5 inches',
          temperature: '76-82°F',
          phRange: '6.5-7.5',
          price: 7.99,
          temperament: 'Semi-aggressive',
          categories: [FishCategory.freshwater],
        ),
      ]);
    });
  }
  
  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      // TODO: Implement search logic
      // For now, just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Searching for: $query')),
      );
    }
  }
  
  void _onFishTap(Fish fish) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FishDetailScreen(fish: fish),
      ),
    );
  }
  
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _showFilters = false;
    });
  }
  
  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }
  
  void _applyFilters() {
    // TODO: Apply filters and search
    _toggleFilters();
  }
  
  void _resetFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedSize = null;
      _selectedDifficulty = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _toggleFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search fish, plants, equipment...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[200]
                    : Colors.grey[800],
              ),
              onSubmitted: _onSearchSubmitted,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          
          // Filters (conditionally shown)
          if (_showFilters) _buildFilterSection(),
          
          // Search results or suggestions
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildSuggestions()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Category filter
            _buildFilterDropdown(
              'Category',
              _categories,
              _selectedCategory,
              (value) => setState(() => _selectedCategory = value),
            ),
            
            // Size filter
            _buildFilterDropdown(
              'Size',
              _sizes,
              _selectedSize,
              (value) => setState(() => _selectedSize = value),
            ),
            
            // Difficulty filter
            _buildFilterDropdown(
              'Care Level',
              _difficulties,
              _selectedDifficulty,
              (value) => setState(() => _selectedDifficulty = value),
            ),
            
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text('Any $label'),
              ),
              ...items.map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  )),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          _buildSectionHeader('Recent Searches'),
          const SizedBox(height: 8),
          ..._buildFishList(_recentSearches),
          const SizedBox(height: 24),
        ],
        
        _buildSectionHeader('Popular Searches'),
        const SizedBox(height: 8),
        ..._buildFishList(_popularSearches),
      ],
    );
  }
  
  Widget _buildSearchResults() {
    // In a real app, this would show actual search results
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No results for "${_searchController.text}"',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Try a different search term'),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }
  
  List<Widget> _buildFishList(List<Fish> fishes) {
    return fishes.map((fish) => Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.pets, color: Colors.blue),
        ),
        title: Text(fish.name),
        subtitle: Text(fish.scientificName),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _onFishTap(fish),
      ),
    )).toList();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
