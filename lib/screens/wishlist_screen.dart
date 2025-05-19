import 'package:flutter/material.dart';
import 'package:aquahaven/models/fish.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample wishlist items
    final wishlistItems = [
      Fish(
        id: '1',
        name: 'Betta Fish',
        scientificName: 'Betta splendens',
        description: 'Colorful and elegant freshwater fish',
        size: '2-3 inches',
        temperature: '75-80°F',
        phRange: '6.5-7.5',
        price: 12.99,
        temperament: 'Semi-aggressive',
        categories: [FishCategory.freshwater],
      ),
      Fish(
        id: '2',
        name: 'Neon Tetra',
        scientificName: 'Paracheirodon innesi',
        description: 'Peaceful schooling fish with bright colors',
        size: '1.5 inches',
        temperature: '72-78°F',
        phRange: '6.0-7.0',
        price: 3.99,
        temperament: 'Peaceful',
        categories: [FishCategory.freshwater, FishCategory.community],
      ),
      Fish(
        id: '3',
        name: 'Java Fern',
        scientificName: 'Microsorum pteropus',
        description: 'Hardy and low-maintenance aquatic plant',
        size: '6-8 inches',
        temperature: '68-82°F',
        phRange: '6.0-7.5',
        price: 8.99,
        temperament: 'Peaceful',
        categories: [FishCategory.plant],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search in wishlist
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: wishlistItems.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                return _buildWishlistItem(context, wishlistItems[index]);
              },
            ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, Fish item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/placeholder_fish.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          // Remove from wishlist
                        },
                      ),
                    ],
                  ),
                  Text(
                    item.scientificName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // View details
                          },
                          child: const Text('View'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add to cart
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Wishlist is Empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save your favorite items here',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to shop
            },
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}
