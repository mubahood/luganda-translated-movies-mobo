import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutx/flutx.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:ugflix/models/MovieModel.dart';
import 'package:ugflix/controllers/MainController.dart';
import 'package:ugflix/utils/CustomTheme.dart';
import 'package:ugflix/utils/Utilities.dart';
import 'package:ugflix/utils/my_colors.dart';
import 'package:ugflix/screens/gardens/VideoPlayerScreen.dart';

class SectionResume extends StatefulWidget {
  @override
  _SectionResumeState createState() => _SectionResumeState();
}

class _SectionResumeState extends State<SectionResume> {
  final MainController _mc = Get.find<MainController>();
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      await _mc.getWatchedMovies();
      _error = null;
    } catch (e) {
      _error = 'Failed to load watched movies.';
      Get.snackbar('Error', _error!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: Utils.overlay(),
        elevation: 1,
        title: Row(
          children: [
            const FxContainer(
                width: 12, height: 25, color: CustomTheme.secondary),
            const SizedBox(width: 10),
            FxText.titleLarge('Watched Movies',
                color: CustomTheme.accent, fontWeight: 900),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: CustomTheme.accent,
        backgroundColor: MyColors.primary,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    if (_loading) return _shimmerList();
    final list = _mc.watchedMovies;
    if (list.isEmpty) {
      return _emptyView();
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _movieCard(list[i]),
    );
  }

  Widget _movieCard(MovieModel m) {
    final progress = m.getProgress();
    final rating = m.imdb_rating.isNotEmpty
        ? double.tryParse(m.imdb_rating) ?? 0
        : Random().nextDouble() * 5;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 3,
        shadowColor: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.to(() => VideoPlayerScreen({'video_item': m})),
          child: SizedBox(
            height: 120,
            child: Row(children: [
              // Thumbnail
              CachedNetworkImage(
                imageUrl: m.getThumbnail(),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[800]),
                errorWidget: (_, __, ___) => Container(color: Colors.grey[700]),
              ),

              // Details
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      FxText.bodyLarge(
                        m.title,
                        color: Colors.white,
                        fontWeight: 700,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Progress bar
                      FxProgressBar(
                        progress: progress,
                        activeColor: CustomTheme.accent,
                        inactiveColor: CustomTheme.color3,
                        height: 6,
                      ),
                      const SizedBox(height: 6),

                      // Rating & VJ tag
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: rating,
                            itemBuilder: (_, __) =>
                                const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 20,
                            direction: Axis.horizontal,
                          ),
                          const Spacer(),
                          FxContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            borderRadiusAll: 6,
                            color: CustomTheme.accent,
                            child: FxText.bodySmall(
                              'VJ: ${m.genre}',
                              color: CustomTheme.primary,
                              fontWeight: 700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _shimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[700]!,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(FeatherIcons.film, color: Colors.white30, size: 60),
          const SizedBox(height: 16),
          FxText.titleMedium('No watched movies',
              color: Colors.white70, fontWeight: 600),
          const SizedBox(height: 8),
          FxText('Watch something and it’ll appear here!',
              color: Colors.white54, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FxButton.outlined(
            onPressed: _load,
            borderColor: CustomTheme.accent,
            borderRadiusAll: 8,
            child: FxText('Refresh', color: CustomTheme.accent),
          )
        ]),
      ),
    );
  }
}
