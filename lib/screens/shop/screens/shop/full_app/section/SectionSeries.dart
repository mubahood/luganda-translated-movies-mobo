import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutx/flutx.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:ugflix/models/NewMovieModel.dart';
import 'package:ugflix/screens/shop/screens/shop/movies/MovieDetailScreen.dart';
import 'package:ugflix/utils/CustomTheme.dart';

import '../../../../../auth/login_screen.dart';

class SectionSeries extends StatefulWidget {
  const SectionSeries({Key? key}) : super(key: key);

  @override
  _SectionSeriesState createState() => _SectionSeriesState();
}

class _SectionSeriesState extends State<SectionSeries> {
  static const int _perPage = 50;
  static const double _itemHeight = 180.0;

  final ScrollController _ctrl = ScrollController();
  final List<NewMovieModel> _all = [];

  bool _loading = false;
  bool _initial = true;
  bool _hasMore = true;
  int _page = 1;
  String? _error;

  late Color _accent, _primary, _shimmerBase, _shimmerHighlight;

  @override
  void initState() {
    super.initState();
    _accent = CustomTheme.accent;
    _primary = CustomTheme.primary;
    _shimmerBase = Colors.grey[850]!;
    _shimmerHighlight = Colors.grey[800]!;
    _fetch(refresh: true);
    _ctrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_loading &&
        _hasMore &&
        _ctrl.position.pixels > _ctrl.position.maxScrollExtent - 300) {
      _fetch();
    }
  }

  Future<void> _fetch({bool refresh = false}) async {
    checkForUpdate();
    if (_loading) return;
    setState(() {
      _loading = true;
      if (refresh) {
        _initial = true;
        _page = 1;
        _hasMore = true;
        _all.clear();
        _error = null;
      }
    });

    try {
      final fetched = await NewMovieModel.getMoviesOnline(
        page: _page,
        perPage: _perPage,
        typeFilter: 'Series',
      );

      if (!mounted) return;

      // dedupe by category_id
      final map = {for (var m in _all) m.category_id: m};
      for (var m in fetched) {
        map.putIfAbsent(m.category_id, () => m);
      }

      setState(() {
        _all
          ..clear()
          ..addAll(map.values);
        if (fetched.length < _perPage)
          _hasMore = false;
        else
          _page++;
      });
    } catch (e) {
      _error = "Couldn’t load series.";
      Get.snackbar("Error", _error!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      if (mounted)
        setState(() {
          _loading = false;
          _initial = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: _primary,
      appBar: AppBar(
        backgroundColor: _primary,
        title: FxText.titleLarge("Series", color: _accent, fontWeight: 800),
        elevation: 1,
      ),
      body: RefreshIndicator(
        color: _accent,
        onRefresh: () => _fetch(refresh: true),
        child: _body(txt),
      ),
    );
  }

  Widget _body(TextTheme txt) {
    if (_initial) return _shimmerList();
    if (_error != null && _all.isEmpty) return _errorView();
    if (!_loading && _all.isEmpty) return _emptyView();

    return ListView.builder(
      controller: _ctrl,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: _all.length + (_hasMore ? 1 : 0),
      itemBuilder: (c, i) {
        if (i == _all.length) return _bottomLoader();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _seriesCard(_all[i], txt),
        );
      },
    );
  }

  Widget _seriesCard(NewMovieModel m, TextTheme txt) {
    return SizedBox(
      height: _itemHeight,
      child: Material(
        elevation: 4,
        shadowColor: Colors.black45,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.to(() => MovieDetailScreen({'movie': m})),
          child: Stack(fit: StackFit.expand, children: [
            CachedNetworkImage(
              imageUrl: m.getThumbnail(),
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: _shimmerBase),
              errorWidget: (_, __, ___) => Container(color: _shimmerBase),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    _accent.withOpacity(0.6),
                    _accent.withOpacity(0.9),
                  ],
                  stops: const [0.4, 0.7, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(children: [
                Expanded(
                  child: FxText.bodyLarge(
                    m.title,
                    color: Colors.black,
                    fontWeight: 700,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(FeatherIcons.play, size: 18, color: _accent),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _shimmerList() {
    return Shimmer.fromColors(
      baseColor: _shimmerBase,
      highlightColor: _shimmerHighlight,
      child: ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: _itemHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomLoader() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(color: _accent, strokeWidth: 3.5),
          ),
        ),
      );

  Widget _errorView() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(FeatherIcons.alertCircle,
                color: Colors.redAccent, size: 50),
            const SizedBox(height: 16),
            FxText.titleMedium("Oops!", color: _accent, fontWeight: 700),
            const SizedBox(height: 8),
            FxText(_error!, color: Colors.white70, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FxButton.outlined(
              onPressed: () => _fetch(refresh: true),
              borderColor: _accent,
              borderRadiusAll: 8,
              child: FxText("Retry", color: _accent),
            ),
          ]),
        ),
      );

  Widget _emptyView() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(FeatherIcons.film, size: 60, color: Colors.white30),
            const SizedBox(height: 16),
            FxText.titleMedium("No series found",
                color: Colors.white70, fontWeight: 600),
            const SizedBox(height: 8),
            FxText("Check back later!", color: Colors.white54),
            const SizedBox(height: 16),
            FxButton.outlined(
              onPressed: () => _fetch(refresh: true),
              borderColor: _accent,
              borderRadiusAll: 8,
              child: FxText("Refresh", color: _accent),
            ),
          ]),
        ),
      );
}
