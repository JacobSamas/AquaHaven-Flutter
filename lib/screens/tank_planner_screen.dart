import 'package:flutter/material.dart';
import 'package:aquahaven/models/fish.dart';
import 'package:google_fonts/google_fonts.dart';

class TankPlannerScreen extends StatefulWidget {
  const TankPlannerScreen({super.key});

  @override
  State<TankPlannerScreen> createState() => _TankPlannerScreenState();
}

class _TankPlannerScreenState extends State<TankPlannerScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Tank setup state
  double _tankSize = 20.0; // in gallons
  String _selectedShape = 'Rectangle';
  final List<String> _tankShapes = [
    'Rectangle',
    'Cube',
    'Bow Front',
    'Hexagon',
  ];
  
  // Fish selection state
  final List<Fish> _selectedFish = [];
  
  // Equipment state
  final List<Map<String, String>> _equipment = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSampleData();
  }
  
  void _loadSampleData() {
    // Sample fish
    _selectedFish.addAll([
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
    
    // Sample equipment
    _equipment.addAll([
      {
        'name': 'Canister Filter',
        'brand': 'Fluval',
        'size': 'For up to 75 gallons',
      },
      {
        'name': 'Heater',
        'brand': 'Eheim',
        'size': '200W',
      },
    ]);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // Build the Setup tab
  Widget _buildSetupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tank Size Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tank Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_tankSize.round()} gallons',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Slider(
                    value: _tankSize,
                    min: 5,
                    max: 200,
                    divisions: 39,
                    label: '${_tankSize.round()} gal',
                    onChanged: _updateTankSize,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5 gal'),
                      Text('200 gal'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tank Shape Selection
          const Text(
            'Tank Shape',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tankShapes.length,
              itemBuilder: (context, index) {
                final shape = _tankShapes[index];
                final isSelected = _selectedShape == shape;
                return GestureDetector(
                  onTap: () => _selectShape(shape),
                  child: Card(
                    color: isSelected 
                        ? Theme.of(context).primaryColor.withOpacity(0.1) 
                        : null,
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getShapeIcon(shape),
                            size: 32,
                            color: isSelected 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            shape,
                            style: TextStyle(
                              color: isSelected 
                                  ? Theme.of(context).primaryColor 
                                  : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
          
          const SizedBox(height: 24),
          
          // Tank Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tank Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryItem('Volume', '${_tankSize.round()} gallons'),
                  _buildSummaryItem('Shape', _selectedShape),
                  _buildSummaryItem('Fish', '${_selectedFish.length} species'),
                  _buildSummaryItem('Equipment', '${_equipment.length} items'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Build the Fish tab
  Widget _buildFishTab() {
    return Column(
      children: [
        Expanded(
          child: _selectedFish.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pets, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No fish added yet'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          _showSnackBar('Adding sample fish');
                          // In a real app, this would open a fish selection screen
                          setState(() {
                            _selectedFish.add(
                              Fish(
                                id: '${_selectedFish.length + 2}',
                                name: 'Guppy',
                                scientificName: 'Poecilia reticulata',
                                description: 'Colorful and easy to breed',
                                size: '1.5-2.5 inches',
                                temperature: '72-82°F',
                                phRange: '6.8-7.8',
                                price: 2.99,
                                temperament: 'Peaceful',
                                categories: [FishCategory.freshwater, FishCategory.community],
                              ),
                            );
                          });
                        },
                        child: const Text('Add Sample Fish'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _selectedFish.length,
                  itemBuilder: (context, index) {
                    final fish = _selectedFish[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: const Icon(Icons.pets, color: Colors.blue),
                        ),
                        title: Text(fish.name),
                        subtitle: Text(fish.scientificName),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedFish.removeAt(index);
                              _showSnackBar('${fish.name} removed');
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  // Build the Equipment tab
  Widget _buildEquipmentTab() {
    return Column(
      children: [
        Expanded(
          child: _equipment.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.build_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No equipment added yet'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          _showSnackBar('Adding sample equipment');
                          // In a real app, this would open an equipment selection screen
                          setState(() {
                            _equipment.add({
                              'name': 'Air Stone',
                              'brand': 'Tetra',
                              'size': '2 inch',
                            });
                          });
                        },
                        child: const Text('Add Sample Equipment'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _equipment.length,
                  itemBuilder: (context, index) {
                    final item = _equipment[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.build),
                        ),
                        title: Text(item['name'] ?? ''),
                        subtitle: Text('${item['brand']} • ${item['size']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _equipment.removeAt(index);
                              _showSnackBar('${item['name']} removed');
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  // Helper method to get icon for tank shape
  IconData _getShapeIcon(String shape) {
    switch (shape) {
      case 'Cube':
        return Icons.crop_square_outlined;
      case 'Bow Front':
        return Icons.curtains_closed_outlined;
      case 'Hexagon':
        return Icons.hexagon_outlined;
      case 'Rectangle':
      default:
        return Icons.rectangle_outlined;
    }
  }
  
  // Helper method to build summary items
  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  void _updateTankSize(double size) {
    setState(() {
      _tankSize = size;
    });
  }
  
  void _selectShape(String shape) {
    setState(() {
      _selectedShape = shape;
    });
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tank Planner'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.build), text: 'Setup'),
            Tab(icon: Icon(Icons.pets), text: 'Fish'),
            Tab(icon: Icon(Icons.settings), text: 'Equipment'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSetupTab(),
          _buildFishTab(),
          _buildEquipmentTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new item based on current tab
          switch (_tabController.index) {
            case 0:
              // Add new tank setup
              break;
            case 1:
              // Add new fish
              break;
            case 2:
              // Add new equipment
              break;
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
