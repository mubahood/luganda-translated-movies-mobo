import 'package:ugflix/models/NewMovieModel.dart';
import 'package:ugflix/utils/Utilities.dart';

class ManifestModel {
  final List<NewMovieModel> top_movie = [];
  final List<String> vj = [];
  final List<String> genres = [];
  final List<MovieCategoryList> lists = [];

  ManifestModel();

  factory ManifestModel.fromJson(Map<String, dynamic> json) {
    // Parse top movies
    List<NewMovieModel> topMovies = [];
    if (json['top_movie'] != null && json['top_movie'] is List) {
      topMovies = (json['top_movie'] as List)
          .map((e) => NewMovieModel.fromJson(e))
          .toList();
    }
    // Parse vj list
    List<String> vjList = [];
    if (json['vj'] != null && json['vj'] is List) {
      vjList = List<String>.from(json['vj']);
    }
    // Parse genres list
    List<String> genresList = [];
    if (json['genres'] != null && json['genres'] is List) {
      genresList = List<String>.from(json['genres']);
    }
    // Parse categorized movie lists
    List<MovieCategoryList> categoryLists = [];
    if (json['lists'] != null && json['lists'] is List) {
      categoryLists = (json['lists'] as List)
          .map((e) => MovieCategoryList.fromJson(e))
          .toList();
    }
    ManifestModel m = ManifestModel();
    m.top_movie.addAll(topMovies);
    m.vj.addAll(vjList);
    m.genres.addAll(genresList);
    m.lists.addAll(categoryLists);
    return m;
  }
}

class MovieCategoryList {
  final String title;
  final List<NewMovieModel> movies;

  MovieCategoryList({
    required this.title,
    required this.movies,
  });

  factory MovieCategoryList.fromJson(Map<String, dynamic> json) {
    String title = Utils.to_str(json['title'], "");
    List<NewMovieModel> moviesList = [];

    // The "movies" field might be a List or a Map
    if (json['movies'] is List) {
      moviesList = (json['movies'] as List)
          .map((m) => NewMovieModel.fromJson(m))
          .toList();
    } else if (json['movies'] is Map) {
      moviesList = (json['movies'] as Map)
          .values
          .map((m) => NewMovieModel.fromJson(m))
          .toList();
    }
    return MovieCategoryList(title: title, movies: moviesList);
  }
}
