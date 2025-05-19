import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aquahaven/theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            right: 20,
            top: 20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.waves,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 40,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.water_drop,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with gradient text
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Colors.white, Color(0xFFE6F7FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  'Welcome to AquaHaven',
                  style: GoogleFonts.pacifico(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                'Discover the beauty of aquarium fish and create your own underwater paradise',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // CTA Buttons
              Row(
                children: [
                  // Primary CTA
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to fish list
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.explore, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Explore Fish',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Secondary CTA
                  OutlinedButton(
                    onPressed: () {
                      // Navigate to learn more
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Learn More',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Stats/Highlights
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('100+', 'Fish Species'),
                  _buildStatItem('24/7', 'Support'),
                  _buildStatItem('4.9', 'Rating'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
