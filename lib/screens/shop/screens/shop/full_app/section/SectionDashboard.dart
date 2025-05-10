import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart'; // Assuming FxButton, FxContainer, FxText are used
import 'package:get/get.dart';
// Assuming these paths are correct - adjust if needed
import 'package:ugflix/controllers/MainController.dart';
import 'package:ugflix/models/ManifestModel.dart';
import 'package:ugflix/models/ManifestService.dart';
import 'package:ugflix/models/NewMovieModel.dart';
import 'package:ugflix/utils/AppConfig.dart'; // Assuming contains checkForUpdate
import 'package:ugflix/utils/CustomTheme.dart';
import 'package:ugflix/utils/app_theme.dart';

import '../../../../../../utils/Utilities.dart';
import '../../MoviesSearchScreen.dart';
import '../../movies/MovieDetailScreen.dart';
import '../../movies/MoviesListingScreen.dart';
import '../AppUpdateScreen.dart' as AppUpdateScreen;

class SectionDashboard extends StatefulWidget {
  const SectionDashboard({super.key});

  @override
  _SectionDashboardState createState() => _SectionDashboardState();
}

class _SectionDashboardState extends State<SectionDashboard>
    with SingleTickerProviderStateMixin {
  // --- State Variables ---
  late ThemeData theme;
  final MainController mainController = Get.find<MainController>();
  final ManifestService manifestService = ManifestService();
  ManifestModel manifestModel = ManifestModel();
  late Future<void> _futureInit;
  String _selectedVjFilter = "";

  // --- Animation ---
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // --- Ads State ---
  // BannerAd? _bannerAd;
  final bool _isBannerAdReady = false;

  // --- Ad Unit IDs (Use Test IDs for Development) ---
  // TODO: Replace with your actual AdMob Ad Unit IDs before publishing!

  // --- Constants ---
  static const double _kHorizontalPadding = 18.0;
  static const double _kVerticalPadding = 14.0;
  static const double _kCardBorderRadius = 14.0;
  static const double _kHeroBorderRadius = 22.0;
  static const double _kChipBorderRadius = 18.0;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme; // Assuming this theme exists

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _loadData();
    _loadBannerAd(); // Load the banner ad on init
  }

  @override
  void dispose() {
    _animationController.dispose();
    // _bannerAd?.dispose(); // Dispose banner ad
    super.dispose();
  }

  // --- Data Loading ---
  void _loadData() {
    // AppConfig.checkForUpdate(); // Assuming this exists and is needed
    _futureInit = _initializeData();
    _futureInit.then((_) {
      if (mounted) {
        _animationController.forward();
      }
    }).catchError((_) {
      // Handle error
    });
  }

  Future<void> _refreshData() async {
    _animationController.reset();
    // Optionally reload banner ad on refresh? Usually not necessary.
    // _loadBannerAd();
    setState(() {
      _futureInit = _initializeData(); // Re-run the initialization future
    });
    await _futureInit; // Wait for refresh to complete
    if (mounted) {
      _animationController.forward();
    }
  }

  Future<void> _initializeData() async {
    try {
      final data = await manifestService.getManifest();
      manifestService.fetchManifestOnline();
      if (mounted) {
        manifestModel = ManifestModel.fromJson(data);
        if (manifestModel.APP_VERSION != 0) {
          if (manifestModel.APP_VERSION > AppConfig.APP_VERSION) {
            Utils.toast("New App Version Available.");
            Get.to(() => AppUpdateScreen.AppUpdateScreen(manifestModel));
          }
        }
      }
      // await mainController.getMovies(); // Consider if needed
    } catch (e) {
      if (mounted) {
        Get.snackbar('Error', 'Failed to load content. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
      rethrow; // Rethrow for FutureBuilder error state
    }
  }

  // --- Ad Loading ---
  void _loadBannerAd() {

  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      body: Column(
        // Main column for Header, Content, and Banner Ad
        children: [
          // --- Header ---
          _buildHeaderBar(),
          // --- Main Content Area ---
          Expanded(
            child: FutureBuilder<void>(
              future: _futureInit,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Use a more thematic shimmer or loading indicator here
                  return _buildContentLoadingIndicator();
                } else if (snapshot.hasError) {
                  return _buildContentErrorView();
                } else {
                  // Content loaded successfully
                  return _buildMainContent();
                }
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildContentLoadingIndicator() {
    // You can replace this with a more elaborate shimmer effect
    // similar to the MovieDetailScreen shimmer if desired.
    return Center(
      child: CircularProgressIndicator(color: Colors.yellowAccent[700]),
    );
  }

  Widget _buildContentErrorView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(FeatherIcons.wifiOff, color: Colors.white30, size: 48),
          const SizedBox(height: 16),
          FxText.bodyLarge('Could not connect', color: Colors.white70),
          FxText.bodySmall('Please check your connection and retry',
              color: Colors.white54),
          const SizedBox(height: 24),
          FxButton.outlined(
            onPressed: _refreshData,
            borderColor: Colors.yellow.shade700,
            splashColor: Colors.yellowAccent[700]?.withOpacity(0.2),
            borderRadiusAll: _kChipBorderRadius,
            child: FxText('Retry', color: Colors.yellowAccent[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    final textTheme = Theme.of(context).textTheme; // Get theme for consistency

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: CustomTheme.primary,
      backgroundColor: Colors.yellowAccent[700] ?? Colors.yellow,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // --- Top Hero Movie ---
          SliverPadding(
            padding: const EdgeInsets.only(
                left: _kHorizontalPadding,
                right: _kHorizontalPadding,
                top: _kVerticalPadding,
                bottom: _kVerticalPadding * 1.5),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildTopMovieHero(
                  manifestModel.top_movie.isNotEmpty
                      ? manifestModel.top_movie[0]
                      : NewMovieModel(), // Handle empty case
                ),
              ),
            ),
          ),
          // --- Genres Section ---
          if (manifestModel.genres.isNotEmpty)
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildGenreSection(manifestModel.genres),
              ),
            ),

          const SliverPadding(padding: EdgeInsets.only(top: _kVerticalPadding)),

          // --- Movie Category Sections ---
          // TODO: Consider inserting Native Ads here periodically
          ...manifestModel.lists
              .where((list) => list.movies.isNotEmpty)
              .map((list) {
            // int index = manifestModel.lists.indexOf(list); // Index for staggering?
            return SliverPadding(
              padding: const EdgeInsets.only(bottom: _kVerticalPadding * 1.8),
              sliver: SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildMovieCategorySection(list, textTheme),
                ),
              ),
            );
          }).toList(),

          // --- Browse All Button ---
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: _kHorizontalPadding * 1.5,
                vertical: _kVerticalPadding * 2),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildBrowseAllButton(textTheme),
              ),
            ),
          ),

          // Add final padding at the very bottom (adjust if banner is present)
          // The SafeArea around the banner handles bottom padding when ad is ready
          // SliverPadding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)),
        ],
      ),
    );
  }

  // --- Header, Search, Hero, Sections, Cards, Buttons (Keep implementations from previous version) ---
  // (Make sure to pass textTheme where appropriate for consistent styling)

  Widget _buildHeaderBar() {
    return Container(
      color: CustomTheme.primary.withOpacity(0.9),
      padding: EdgeInsets.only(
        left: _kHorizontalPadding,
        right: _kHorizontalPadding,
        top: MediaQuery.of(context).padding.top + _kVerticalPadding * 0.8,
        bottom: _kVerticalPadding * 0.8,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchBar(
              hint: 'Search movies, VJs...',
              onTap: () => Get.to(() => const MoviesSearchScreen({})),
            ),
          ),
          const SizedBox(width: 14),
          InkWell(
            onTap: _showVjFilterBottomSheet,
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(FeatherIcons.mic, color: Colors.yellow, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar({required String hint, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: FxContainer(
        color: Colors.white.withOpacity(0.1),
        bordered: false,
        borderRadiusAll: _kChipBorderRadius,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(FeatherIcons.search,
                color: Colors.yellow, size: 20), // Accent search icon
            const SizedBox(width: 10),
            Expanded(
              child: FxText(hint,
                  fontWeight: 400,
                  color: Colors.white70,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMovieHero(NewMovieModel movie) {
    if (movie.id <= 0) {
      // Check for valid movie ID
      return const SizedBox(
          height: 200,
          child: Center(
              child: Text("No featured movie",
                  style: TextStyle(
                      color: Colors.white54)))); // Placeholder or empty state
    }
    return AspectRatio(
      aspectRatio: 16 / 9.5,
      child: FxContainer(
        borderRadiusAll: _kHeroBorderRadius,
        clipBehavior: Clip.antiAlias,
        bordered: true,
        borderColor: Colors.yellow,
        // Subtle accent border
        paddingAll: 0,
        child: InkWell(
          onTap: () => Get.to(() => MovieDetailScreen({'movie': movie})),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                // Ensure image respects border radius
                borderRadius: BorderRadius.circular(_kHeroBorderRadius - 1),
                // Inner radius for image
                child: CachedNetworkImage(
                  imageUrl: movie.getThumbnail(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[900]),
                  errorWidget: (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                          child: Icon(FeatherIcons.image,
                              color: Colors.white24, size: 48))),
                  fadeInDuration: const Duration(milliseconds: 400),
                ),
              ),
              Container(
                // Gradient
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_kHeroBorderRadius - 1),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.7, 1.0],
                    colors: [
                      Colors.black.withOpacity(0.95),
                      Colors.black.withOpacity(0.5),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
              Positioned(
                // Content
                bottom: _kVerticalPadding * 1.2,
                left: _kHorizontalPadding,
                right: _kHorizontalPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FxText.bodyLarge(movie.title,
                        fontWeight: 800,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    if (movie.vj.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(FeatherIcons.mic,
                              color: Colors.yellow, size: 16),
                          const SizedBox(width: 5),
                          FxText.bodyLarge(movie.vj,
                              color: CustomTheme.accent,
                              fontWeight: 700,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    const SizedBox(height: 16),
                    FxButton(
                      onPressed: () =>
                          Get.to(() => MovieDetailScreen({'movie': movie})),
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: Colors.yellow,
                      borderRadiusAll: _kChipBorderRadius,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(FeatherIcons.play,
                              color: Colors.black, size: 18),
                          const SizedBox(width: 8),
                          FxText.bodyMedium("Watch Now",
                              fontWeight: 900, color: Colors.black),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreSection(List<String> genres) {
    return SizedBox(
      height: 38, // Slightly taller chips
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
        itemBuilder: (context, index) {
          String genre = genres[index];
          return Padding(
            padding:
                EdgeInsets.only(right: index < genres.length - 1 ? 10.0 : 0.0),
            child: FxButton.outlined(
              // Use outlined for genres
              onPressed: () =>
                  Get.to(() => MoviesListingScreen({'genre': genre})),
              borderRadiusAll: _kChipBorderRadius,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              borderColor: Colors.yellow.withOpacity(0.6),
              // Accent border
              splashColor: CustomTheme.accent.withOpacity(0.1),
              child: FxText.bodyMedium(genre,
                  color: Colors.yellow, fontWeight: 500), // Accent text
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieCategorySection(
      MovieCategoryList categoryList, TextTheme textTheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding)
              .copyWith(bottom: _kVerticalPadding * 0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FxText(categoryList.title,
                  style: textTheme.titleLarge?.copyWith(
                      color: CustomTheme.accent, fontWeight: FontWeight.w700)),
              // Use theme
              FxButton.text(
                onPressed: () => Get.to(() => MoviesListingScreen({
                      'category': categoryList.title,
                      'movies': categoryList.movies
                    })),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                splashColor: CustomTheme.accent.withOpacity(0.1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FxText('View All', color: Colors.yellow, fontWeight: 600),
                    const SizedBox(width: 4),
                    const Icon(FeatherIcons.arrowRight,
                        color: Colors.yellow, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          // Horizontal Movie List
          height: (Get.width / 2.8) * 1.5 + 10, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryList.movies.length,
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
            itemBuilder: (context, index) {
              NewMovieModel movie = categoryList.movies[index];
              return Padding(
                padding: EdgeInsets.only(
                    right: index < categoryList.movies.length - 1 ? 12.0 : 0.0),
                child: _buildMovieCard(movie, textTheme), // Pass theme
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(NewMovieModel item, TextTheme textTheme) {
    double cardWidth = Get.width / 2.8;
    double cardHeight = cardWidth * 1.5;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: FxContainer(
        borderRadiusAll: _kCardBorderRadius,
        paddingAll: 0,
        child: InkWell(
          onTap: () => Get.to(() => MovieDetailScreen({'movie': item})),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(_kCardBorderRadius),
                child: CachedNetworkImage(
                  imageUrl: item.getThumbnail(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[850]),
                  errorWidget: (context, url, error) => Container(
                      color: Colors.grey[850],
                      child: const Center(
                          child: Icon(FeatherIcons.film,
                              color: Colors.white24, size: 30))),
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
              ),
              Container(
                // Gradient
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_kCardBorderRadius),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    stops: const [0.0, 1.0],
                    colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FxText(item.title,
                        style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.25),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(FeatherIcons.mic, color: Colors.yellow, size: 12),
                        const SizedBox(width: 4),
                        Expanded(
                          child: FxText(
                            item.vj.isNotEmpty
                                ? item.vj
                                : (item.genre.isNotEmpty ? item.genre : '-'),
                            style: textTheme.bodySmall?.copyWith(
                                color: CustomTheme.accent,
                                fontWeight: FontWeight.w700),
                            // Use theme
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildBrowseAllButton(TextTheme textTheme) {
    return FxButton(
      onPressed: () => Get.to(() => const MoviesListingScreen({})),
      elevation: 3,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.yellow,
      borderRadiusAll: _kChipBorderRadius * 1.5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FeatherIcons.film, color: Colors.black, size: 20),
          const SizedBox(width: 10),
          FxText("Browse All Movies",
              style: textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w800, color: Colors.black)),
        ],
      ),
    );
  }

  void _showVjFilterBottomSheet() {
    // Keep implementation from previous version
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(_kHeroBorderRadius),
                    topRight: Radius.circular(_kHeroBorderRadius))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 5,
                    width: 45,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(2.5))),
                _buildFilterBottomSheetHeader(),
                ElevatedButton(
                  onPressed: () {
                    // Upgrader().checkVersion(context: context, showDialog: true),
                  },
                  child: const Text('Check for Updates'),
                ),
                const Divider(color: Colors.white12, height: 1, thickness: 1),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: AppConfig.VJs.length,
                    // Ensure AppConfig.VJs exists
                    itemBuilder: (context, position) {
                      String data = AppConfig.VJs[position];
                      bool isSelected = _selectedVjFilter == data;
                      return ListTile(
                        onTap: () {
                          setModalState(() {
                            _selectedVjFilter = data;
                          });
                          Navigator.pop(context);
                          Get.to(() => MoviesListingScreen({'vj': data}));
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: _kHorizontalPadding + 4),
                        title: FxText.bodyLarge(data,
                            color: isSelected
                                ? CustomTheme.accent
                                : Colors.white.withOpacity(0.8),
                            fontWeight: isSelected ? 700 : 500),
                        trailing: !isSelected
                            ? null
                            : const Icon(FeatherIcons.checkCircle,
                                color: CustomTheme.accent, size: 24),
                        dense: false,
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 5),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildFilterBottomSheetHeader() {
    // Keep implementation from previous version
    return Container(
      padding: const EdgeInsets.only(
          left: _kHorizontalPadding,
          right: _kHorizontalPadding,
          bottom: _kVerticalPadding * 0.8,
          top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FxText.titleLarge('Filter by VJ',
              color: Colors.white, fontWeight: 700),
          InkWell(
              onTap: () => Navigator.pop(context),
              customBorder: const CircleBorder(),
              child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: const Icon(FeatherIcons.x,
                      color: Colors.white70, size: 20))),
        ],
      ),
    );
  }
}
