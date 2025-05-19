import 'package:flutter/foundation.dart';
import '../models/fish.dart';
import '../data/dummy_data.dart';

class FishProvider with ChangeNotifier {
  List<Fish> _fishList = [];
  List<Fish> _filteredFish = [];
  String _searchQuery = '';
  Difficulty? _selectedDifficulty;

  FishProvider() {
    // Initialize with all fish
    _fishList = List.from(dummyFish);
    _filteredFish = List.from(_fishList);
  }

  // Getters
  List<Fish> get fishList => _filteredFish;
  List<Fish> get featuredFish => dummyFish.take(3).toList();
  String get searchQuery => _searchQuery;
  Difficulty? get selectedDifficulty => _selectedDifficulty;

  // Get fish by ID
  Fish getFishById(String id) {
    return _fishList.firstWhere((fish) => fish.id == id);
  }

  // Search fish by name or scientific name
  void searchFish(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  // Filter by care level
  void filterByDifficulty(Difficulty? difficulty) {
    _selectedDifficulty = difficulty;
    _applyFilters();
  }

  // Apply all active filters
  void _applyFilters() {
    _filteredFish = List.from(_fishList);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      _filteredFish = _filteredFish.where((fish) {
        return fish.name.toLowerCase().contains(_searchQuery) ||
               fish.scientificName.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply difficulty filter
    if (_selectedDifficulty != null) {
      _filteredFish = _filteredFish
          .where((fish) => fish.careLevel == _selectedDifficulty)
          .toList();
    }

    notifyListeners();
  }

  // Reset all filters
  void resetFilters() {
    _searchQuery = '';
    _selectedDifficulty = null;
    _filteredFish = List.from(_fishList);
    notifyListeners();
  }

  // Get fish by care level
  List<Fish> getFishByCareLevel(Difficulty level) {
    return _fishList.where((fish) => fish.careLevel == level).toList();
  }

  // Check if any filters are active
  bool get areFiltersActive => _searchQuery.isNotEmpty || _selectedDifficulty != null;
}
