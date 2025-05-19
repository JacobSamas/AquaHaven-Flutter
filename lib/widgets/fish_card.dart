import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/fish.dart';

// Define theme colors
class AppColors {
  static const primaryColor = Color(0xFF00B4D8);
  static const secondaryTextColor = Color(0xFFCAF0F8);
  static const cardBackground = Color(0x99000000);
  static const shimmerBase = Color(0x1AFFFFFF);
  static const shimmerHighlight = Color(0x33FFFFFF);
}

class FishCard extends StatefulWidget {
  final Fish fish;
  final VoidCallback onTap;
  final bool isFavorite;
  final Function(bool)? onFavoriteToggle;
  
  const FishCard({
    Key? key, 
    required this.fish, 
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<FishCard> createState() => _FishCardState();
}

class _FishCardState extends State<FishCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isFavorite = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleFavoriteTap() {
    setState(() {
      _isFavorite = !_isFavorite;
      if (_isFavorite) {
        _animationController.forward();
      }
    });
    widget.onFavoriteToggle?.call(_isFavorite);
  }


  // Helper method to get color based on care level
  Color _getDifficultyColor(Difficulty? difficulty) {
    if (difficulty == null) return Colors.grey;
    
    switch (difficulty) {
      case Difficulty.beginner:
        return const Color(0xFF4CAF50); // Green
      case Difficulty.intermediate:
        return const Color(0xFFFFA000); // Amber
      case Difficulty.expert:
        return const Color(0xFFF44336); // Red
    }
  }
  
  Widget _buildGlassBadge(String text, Color color) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 60, // Minimum width for the badge
      ),
      child: GlassmorphicContainer(
        width: 60, // Default width, will be expanded by content
        height: 28,
        borderRadius: 14,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            color.withOpacity(0.7),
            color.withOpacity(0.3),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: _handleFavoriteTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: _isFavorite
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 20,
                  ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAddToTankButton() {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 80,
      ),
      child: GestureDetector(
        onTap: () {
          // Handle add to tank
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF00B4D8),
                Color(0xFF0077B6),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'Add to Tank',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ).animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        ).shimmer(
          duration: 2000.ms,
          color: Colors.white.withOpacity(0.2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 320,
            borderRadius: 24,
            blur: 20,
            alignment: Alignment.bottomCenter,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.cardBackground.withOpacity(0.6),
                AppColors.cardBackground.withOpacity(0.3),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image with Floating Animation
                Expanded(
                  child: Stack(
                    children: [
                      // Fish Image with floating animation
                      Positioned.fill(
                        child: Hero(
                          tag: 'fish-${widget.fish.id}-image',
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                            child: (widget.fish.imageUrl != null && widget.fish.imageUrl!.isNotEmpty)
                                ? Image.network(
                                    widget.fish.imageUrl!,
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
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.error, color: Colors.red, size: 40),
                                    ),
                                  ).animate(
                                    onPlay: (controller) => controller.repeat(),
                                  ).moveY(
                                    begin: -10,
                                    end: 10,
                                    duration: 4000.ms,
                                    curve: Curves.easeInOut,
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                  ),
                          ),
                        ),
                      ),
                      
                      // Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Care Level Badge
                      Positioned(
                        top: 16,
                        right: 16,
                        child: _buildGlassBadge(
                          widget.fish.careLevelText,
                          _getDifficultyColor(widget.fish.careLevel),
                        ),
                      ),
                      
                      // Favorite Button
                      Positioned(
                        top: 16,
                        left: 16,
                        child: _buildFavoriteButton(),
                      ),
                    ],
                  ),
                ),
                
                // Fish Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Scientific Name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: Text(
                              widget.fish.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${widget.fish.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      
                      Text(
                        widget.fish.scientificName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Quick Info
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            const SizedBox(width: 4),
                            if (widget.fish.size.isNotEmpty) ...[
                              _buildInfoItem(Icons.straighten, widget.fish.size),
                              const SizedBox(width: 8),
                            ],
                            if (widget.fish.temperature.isNotEmpty) ...[
                              _buildInfoItem(Icons.thermostat, widget.fish.temperature),
                              const SizedBox(width: 8),
                            ],
                            if (widget.fish.phRange.isNotEmpty) ...[
                              _buildInfoItem(Icons.water_drop, widget.fish.phRange),
                              const SizedBox(width: 8),
                            ],
                            if (widget.fish.temperament.isNotEmpty) ...[
                              _buildInfoItem(Icons.pets, widget.fish.temperament.split(' ').first),
                              const SizedBox(width: 4),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Add to Tank Button
                      Row(
                        children: [
                          const Spacer(),
                          Flexible(
                            child: FittedBox(
                              child: _buildAddToTankButton(),
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
        ),
      ),
    );
  }
  


  Widget _buildInfoItem(IconData icon, String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.secondaryTextColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
