import '../models/fish.dart';

final List<Fish> dummyFish = [
  Fish(
    id: 'f1',
    name: 'Clownfish',
    scientificName: 'Amphiprioninae',
    imageUrl: 'https://images.unsplash.com/photo-1570042225831-98c4fa456379',
    description: 'Clownfish are small, brightly colored fish that are popular in home aquariums. They form a symbiotic relationship with sea anemones and are known for their distinctive orange and white striped pattern.',
    origin: 'Indo-Pacific Ocean',
    size: '3-4 inches',
    lifespan: '6-10 years',
    temperature: '75-82°F (24-28°C)',
    phRange: '8.0-8.4',
    careLevel: Difficulty.beginner,
    temperament: 'Peaceful',
    diet: 'Omnivore - Flakes, pellets, and frozen foods',
    tankSize: '20 gallons minimum',
    compatibleFish: ['Damsels', 'Blennies', 'Gobies'],
    price: 29.99,
    images: [
      'https://images.unsplash.com/photo-1570042225831-98c4fa456379',
      'https://images.unsplash.com/photo-1583692713727-754a7f1ad2c5',
      'https://images.unsplash.com/photo-1552089123-2d1b5bcd1916',
    ],
  ),
  Fish(
    id: 'f2',
    name: 'Betta',
    scientificName: 'Betta splendens',
    imageUrl: 'https://images.unsplash.com/photo-1583692713727-754a7f1ad2c5',
    description: 'Bettas, also known as Siamese fighting fish, are known for their vibrant colors and long, flowing fins. They are territorial and should be kept alone or with peaceful tank mates.',
    origin: 'Southeast Asia',
    size: '2.5-3 inches',
    lifespan: '3-5 years',
    temperature: '76-82°F (24-28°C)',
    phRange: '6.5-7.5',
    careLevel: Difficulty.beginner,
    temperament: 'Can be aggressive',
    diet: 'Carnivore - Pellets, flakes, and live/frozen foods',
    tankSize: '5 gallons minimum',
    compatibleFish: ['Snails', 'Shrimp', 'Corydoras'],
    price: 12.99,
    images: [
      'https://source.unsplash.com/400x300/?betta',
      'https://source.unsplash.com/400x300/?fish',
      'https://source.unsplash.com/400x300/?aquarium',
    ],
  ),
  Fish(
    id: 'f3',
    name: 'Neon Tetra',
    scientificName: 'Paracheirodon innesi',
    imageUrl: 'https://source.unsplash.com/400x300/?neon-tetra',
    description: 'Neon Tetras are small, peaceful schooling fish known for their bright blue and red stripes. They do best in groups of 6 or more and add vibrant color to any community tank.',
    origin: 'South America',
    size: '1.5 inches',
    lifespan: '5-8 years',
    temperature: '70-81°F (21-27°C)',
    phRange: '6.0-7.0',
    careLevel: Difficulty.beginner,
    temperament: 'Peaceful, schooling',
    diet: 'Omnivore - Flakes, small pellets, and frozen foods',
    tankSize: '10 gallons minimum',
    compatibleFish: ['Guppies', 'Platies', 'Corydoras'],
    price: 3.99,
    images: [
      'https://source.unsplash.com/400x300/?neon-tetra',
      'https://source.unsplash.com/400x300/?fish',
      'https://source.unsplash.com/400x300/?aquarium',
    ],
  ),
  Fish(
    id: 'f4',
    name: 'Angelfish',
    scientificName: 'Pterophyllum',
    imageUrl: 'https://source.unsplash.com/400x300/?angelfish',
    description: 'Angelfish are elegant, disc-shaped fish with long, flowing fins. They are a popular choice for community aquariums but can be semi-aggressive, especially during breeding.',
    origin: 'Amazon Basin, South America',
    size: '6 inches (height up to 8 inches)',
    lifespan: '10+ years',
    temperature: '75-82°F (24-28°C)',
    phRange: '6.0-7.5',
    careLevel: Difficulty.intermediate,
    temperament: 'Semi-aggressive',
    diet: 'Omnivore - Flakes, pellets, and live/frozen foods',
    tankSize: '30 gallons minimum',
    compatibleFish: ['Gouramis', 'Larger Tetras', 'Corydoras'],
    price: 24.99,
    images: [
      'https://source.unsplash.com/400x300/?angelfish',
      'https://source.unsplash.com/400x300/?fish',
      'https://source.unsplash.com/400x300/?aquarium',
    ],
  ),
  Fish(
    id: 'f5',
    name: 'Discus',
    scientificName: 'Symphysodon',
    imageUrl: 'https://source.unsplash.com/400x300/?discus',
    description: 'Discus are known for their vibrant colors and distinctive disc-shaped bodies. They require pristine water conditions and a well-maintained tank, making them suitable for experienced aquarists.',
    origin: 'Amazon River Basin',
    size: '6-8 inches',
    lifespan: '10-15 years',
    temperature: '82-88°F (28-31°C)',
    phRange: '6.0-7.0',
    careLevel: Difficulty.expert,
    temperament: 'Peaceful but sensitive',
    diet: 'Carnivore - High-protein foods, frozen, and live foods',
    tankSize: '55 gallons minimum',
    compatibleFish: ['Angelfish', 'Cardinal Tetras', 'Corydoras'],
    price: 49.99,
    images: [
      'https://images.unsplash.com/photo-1544551784-9a9a0e2da9c3',
      'https://images.unsplash.com/photo-1552089123-2d1b5bcd1916',
      'https://images.unsplash.com/photo-1583692713727-754a7f1ad2c5',
    ],
  ),
];

// Helper function to get a fish by ID
Fish getFishById(String id) {
  return dummyFish.firstWhere((fish) => fish.id == id);
}

// Get featured fish (first 3 for example)
List<Fish> get featuredFish => dummyFish.take(3).toList();

// Get fish by care level
List<Fish> getFishByCareLevel(Difficulty level) {
  return dummyFish.where((fish) => fish.careLevel == level).toList();
}

// Search fish by name or scientific name
List<Fish> searchFish(String query) {
  if (query.isEmpty) return [];
  final lowerQuery = query.toLowerCase();
  return dummyFish.where((fish) {
    return fish.name.toLowerCase().contains(lowerQuery) ||
           fish.scientificName.toLowerCase().contains(lowerQuery);
  }).toList();
}
