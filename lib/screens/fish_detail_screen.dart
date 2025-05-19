import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme.dart' show AppColors;
import 'package:aquahaven/models/fish.dart';

class FishDetailScreen extends StatefulWidget {
  final Fish fish;
  
  const FishDetailScreen({Key? key, required this.fish}) : super(key: key);

  @override
  State<FishDetailScreen> createState() => _FishDetailScreenState();
}

class _FishDetailScreenState extends State<FishDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <= 100 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  Future<void> _shareFishDetails() async {
    final box = context.findRenderObject() as RenderBox?;
    
    await Share.share(
      'Check out ${widget.fish.name} (${widget.fish.scientificName}) on AquaHaven!\n\n'
      '📏 Size: ${widget.fish.size}\n'
      '🌡️ Temperature: ${widget.fish.temperature}\n'
      '💧 pH: ${widget.fish.phRange}\n'
      '🐠 Temperament: ${widget.fish.temperament}\n\n'
      'Download AquaHaven to explore more amazing fish!',
      subject: '${widget.fish.name} - AquaHaven',
      sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: _shareFishDetails,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: _showAppBarTitle 
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.fish.name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : null,
              background: Hero(
                tag: 'fish-${widget.fish.id}-image',
                child: widget.fish.imageUrl != null && widget.fish.imageUrl!.isNotEmpty
                    ? Stack(
                        children: [
                          Image.network(
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
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.error, color: Colors.red, size: 50),
                            ),
                          ),
                          // Gradient overlay for better text visibility
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fish Name and Scientific Name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.fish.name,
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.fish.scientificName,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Care Level Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(widget.fish.careLevel).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.fish.careLevelEmoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.fish.careLevelText} Care',
                              style: GoogleFonts.roboto(
                                color: _getDifficultyColor(widget.fish.careLevel),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Quick Facts Grid
                  _buildQuickFacts(),
                  
                  const SizedBox(height: 24),
                  
                  // About Section
                  _buildSectionTitle('About'),
                  const SizedBox(height: 8),
                  Text(
                    widget.fish.description,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Gallery Section
                  if (widget.fish.images?.isNotEmpty ?? false) ...[
                    _buildSectionTitle('Gallery'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.fish.images?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.fish.images?[index] ?? '',
                                width: 160,
                                height: 120,
                                fit: BoxFit.cover,
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
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Habitat & Care Section
                  _buildSectionTitle('Habitat & Care'),
                  const SizedBox(height: 12),
                  if (widget.fish.origin != null) _buildInfoRow('Origin', widget.fish.origin!),
                  if (widget.fish.tankSize != null) _buildInfoRow('Tank Size', widget.fish.tankSize!),
                  if (widget.fish.diet != null) _buildInfoRow('Diet', widget.fish.diet!),
                  _buildInfoRow('Temperament', widget.fish.temperament),
                  if (widget.fish.lifespan != null) _buildInfoRow('Lifespan', widget.fish.lifespan!),
                  _buildInfoRow('pH Range', widget.fish.phRange),
                  _buildInfoRow('Temperature', widget.fish.temperature),
                  
                  // Compatible Fish Section
                  if (widget.fish.compatibleFish?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('Compatible With'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.fish.compatibleFish!
                          .map((fish) => _buildCompatibleFishChip(fish))
                          .toList(),
                    ),
                  ],
                  
                  // Add more sections as needed...
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      // Floating Action Button for adding to favorites or tank
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement add to tank functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added ${widget.fish.name} to your tank!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Add to My Tank'),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickFacts() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickFact('Size', widget.fish.size, Icons.straighten),
            const VerticalDivider(color: Colors.grey, thickness: 0.5, width: 1, indent: 8, endIndent: 8),
            _buildQuickFact('Temperature', widget.fish.temperature, Icons.thermostat),
            const VerticalDivider(color: Colors.grey, thickness: 0.5, width: 1, indent: 8, endIndent: 8),
            _buildQuickFact('pH Level', widget.fish.phRange, Icons.water_drop),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickFact(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
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
  
  Widget _buildCompatibleFishChip(String fishName) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        fishName,
        style: GoogleFonts.roboto(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
