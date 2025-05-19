enum Difficulty { beginner, intermediate, expert }

class Fish {
  final String id;
  final String name;
  final String scientificName;
  final String? imageUrl;
  final String description;
  final String? origin;
  final String size;
  final String? lifespan;
  final String temperature;
  final String phRange;
  final double price;
  final Difficulty? careLevel;
  final String temperament;
  final String? diet;
  final String? tankSize;
  final List<String>? compatibleFish;
  final List<String>? images;

  const Fish({
    required this.id,
    required this.name,
    required this.scientificName,
    this.imageUrl,
    required this.description,
    this.origin,
    required this.size,
    this.lifespan,
    required this.temperature,
    required this.phRange,
    required this.price,
    this.careLevel,
    required this.temperament,
    this.diet,
    this.tankSize,
    this.compatibleFish,
    this.images,
  });

  String get careLevelText {
    if (careLevel == null) return 'Not specified';
    
    final level = careLevel!;
    if (level == Difficulty.beginner) return 'Beginner';
    if (level == Difficulty.intermediate) return 'Intermediate';
    if (level == Difficulty.expert) return 'Expert';
    
    return 'Not specified';
  }

  // Helper method to get a short description for the fish card
  String get shortDescription {
    final maxLength = 100;
    if (description.length <= maxLength) return description;
    return '${description.substring(0, maxLength)}...';
  }

  // Convert Fish object to a map for easy serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'imageUrl': imageUrl,
      'description': description,
      'origin': origin,
      'size': size,
      'lifespan': lifespan,
      'temperature': temperature,
      'phRange': phRange,
      'price': price,
      'careLevel': careLevel.toString(),
      'temperament': temperament,
      'diet': diet,
      'tankSize': tankSize,
      'compatibleFish': compatibleFish,
      'images': images,
    };
  }

  // Create a Fish object from a map
  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientificName'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      origin: json['origin'],
      size: json['size'],
      lifespan: json['lifespan'],
      temperature: json['temperature'],
      phRange: json['phRange'],
      price: (json['price'] as num).toDouble(),
      careLevel: Difficulty.values.firstWhere(
        (e) => e.toString() == json['careLevel'],
        orElse: () => Difficulty.beginner,
      ),
      temperament: json['temperament'],
      diet: json['diet'],
      tankSize: json['tankSize'],
      compatibleFish: List<String>.from(json['compatibleFish'] ?? []),
      images: List<String>.from(json['images'] ?? []),
    );
  }

  // Create a copy of the fish with optional overrides
  Fish copyWith({
    String? id,
    String? name,
    String? scientificName,
    String? imageUrl,
    String? description,
    String? origin,
    String? size,
    String? lifespan,
    String? temperature,
    String? phRange,
    double? price,
    Difficulty? careLevel,
    String? temperament,
    String? diet,
    String? tankSize,
    List<String>? compatibleFish,
    List<String>? images,
  }) {
    return Fish(
      id: id ?? this.id,
      name: name ?? this.name,
      scientificName: scientificName ?? this.scientificName,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      origin: origin ?? this.origin,
      size: size ?? this.size,
      lifespan: lifespan ?? this.lifespan,
      temperature: temperature ?? this.temperature,
      phRange: phRange ?? this.phRange,
      price: price ?? this.price,
      careLevel: careLevel ?? this.careLevel,
      temperament: temperament ?? this.temperament,
      diet: diet ?? this.diet,
      tankSize: tankSize ?? this.tankSize,
      compatibleFish: compatibleFish ?? this.compatibleFish,
      images: images ?? this.images,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Fish && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Fish(id: $id, name: $name)';
  }
  String get careLevelEmoji {
    if (careLevel == null) return '';
    
    switch (careLevel!) {
      case Difficulty.beginner:
        return '⭐';
      case Difficulty.intermediate:
        return '⭐⭐';
      case Difficulty.expert:
        return '⭐⭐⭐';
    }
  }
}
