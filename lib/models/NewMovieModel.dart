import '../utils/Utilities.dart';
import 'RespondModel.dart';

class NewMovieModel {
  static String end_point = "movies";
  static String tableName = "movie_models";

  String get_series_name() {
    String episode = "";
    episode = title;
    if (title.toLowerCase().contains('episode')) {
      episode = title.split("Episode").first.trim();
      episode = episode.trim();
    }
    if (title.toLowerCase().contains('-')) {
      episode = title.split("-").first.trim();
      episode = episode.trim();
    }
    return episode;
  }

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String title = "";
  String external_url = "";
  String url = "";
  String image_url = "";
  String thumbnail_url = "";
  String description = "";
  String year = "";
  String rating = "";
  String duration = "";
  String size = "";
  String genre = "";
  String director = "";
  String stars = "";
  String country = "";
  String language = "";
  String imdb_url = "";
  String imdb_rating = "";
  String imdb_votes = "";
  String imdb_id = "";
  String type = "";
  String status = "";
  String error = "";
  String error_message = "";
  String downloads_count = "";
  String views_count = "";
  String likes_count = "";
  String dislikes_count = "";
  String comments_count = "";
  String comments = "";
  String video_is_downloaded_to_server = "";
  String video_downloaded_to_server_start_time = "";
  String video_downloaded_to_server_end_time = "";
  String video_downloaded_to_server_duration = "";
  String video_is_downloaded_to_server_status = "";
  String video_is_downloaded_to_server_error_message = "";
  String category = "";
  String category_id = "";
  String is_processed = "";
  String downloaded_from_google = "";
  String uploaded_to_from_google = "";
  String local_video_link = "";
  String plays_on_google = "";
  String downloaded_to_new_server = "";
  String new_server_path = "";
  String server_fail_reason = "";
  String actor = "";
  String vj = "";
  String content_type = "";
  String content_is_video = "";
  String content_type_processed = "";
  String content_type_processed_time = "";
  String is_premium = "";
  String episode_number = "";

  // Additional fields for view progress:
  String watch_progress = "";
  String max_progress = "";
  String watch_status = "";
  String watched_movie = "";

  NewMovieModel();

  String getThumbnail() {
    return thumbnail_url;
    if (thumbnail_url.isNotEmpty) {
      return thumbnail_url;
    } else if (image_url.isNotEmpty) {
      return image_url;
    } else {
      return "";
    }
  }

  String video_url = "";

  String get_video_url() {
    video_url = url;
    return url;
  }

  factory NewMovieModel.fromJson(Map<String, dynamic> json) {
    NewMovieModel obj = NewMovieModel();
    obj.id = Utils.int_parse(json['id']);
    obj.created_at = Utils.to_str(json['created_at'], '');
    obj.updated_at = Utils.to_str(json['updated_at'], '');
    obj.title = Utils.to_str(json['title'], '');
    obj.external_url = Utils.to_str(json['external_url'], '');
    obj.url = Utils.to_str(json['url'], '');
    obj.image_url = Utils.to_str(json['image_url'], '');
    obj.thumbnail_url = Utils.to_str(json['thumbnail_url'], '');
    obj.description = Utils.to_str(json['description'], '');
    obj.year = Utils.to_str(json['year'], '');
    obj.rating = Utils.to_str(json['rating'], '');
    obj.duration = Utils.to_str(json['duration'], '');
    obj.size = Utils.to_str(json['size'], '');
    obj.genre = Utils.to_str(json['genre'], '');
    obj.director = Utils.to_str(json['director'], '');
    obj.stars = Utils.to_str(json['stars'], '');
    obj.country = Utils.to_str(json['country'], '');
    obj.language = Utils.to_str(json['language'], '');
    obj.imdb_url = Utils.to_str(json['imdb_url'], '');
    obj.imdb_rating = Utils.to_str(json['imdb_rating'], '');
    obj.imdb_votes = Utils.to_str(json['imdb_votes'], '');
    obj.imdb_id = Utils.to_str(json['imdb_id'], '');
    obj.type = Utils.to_str(json['type'], '');
    obj.status = Utils.to_str(json['status'], '');
    obj.error = Utils.to_str(json['error'], '');
    obj.error_message = Utils.to_str(json['error_message'], '');
    obj.downloads_count = Utils.to_str(json['downloads_count'], '');
    obj.views_count = Utils.to_str(json['views_count'], '');
    obj.likes_count = Utils.to_str(json['likes_count'], '');
    obj.dislikes_count = Utils.to_str(json['dislikes_count'], '');
    obj.comments_count = Utils.to_str(json['comments_count'], '');
    obj.comments = Utils.to_str(json['comments'], '');
    obj.video_is_downloaded_to_server =
        Utils.to_str(json['video_is_downloaded_to_server'], '');
    obj.video_downloaded_to_server_start_time =
        Utils.to_str(json['video_downloaded_to_server_start_time'], '');
    obj.video_downloaded_to_server_end_time =
        Utils.to_str(json['video_downloaded_to_server_end_time'], '');
    obj.video_downloaded_to_server_duration =
        Utils.to_str(json['video_downloaded_to_server_duration'], '');
    obj.video_is_downloaded_to_server_status =
        Utils.to_str(json['video_is_downloaded_to_server_status'], '');
    obj.video_is_downloaded_to_server_error_message =
        Utils.to_str(json['video_is_downloaded_to_server_error_message'], '');
    obj.category = Utils.to_str(json['category'], '');
    obj.category_id = Utils.to_str(json['category_id'], '');
    obj.is_processed = Utils.to_str(json['is_processed'], '');
    obj.downloaded_from_google =
        Utils.to_str(json['downloaded_from_google'], '');
    obj.uploaded_to_from_google =
        Utils.to_str(json['uploaded_to_from_google'], '');
    obj.local_video_link = Utils.to_str(json['local_video_link'], '');
    obj.plays_on_google = Utils.to_str(json['plays_on_google'], '');
    obj.downloaded_to_new_server =
        Utils.to_str(json['downloaded_to_new_server'], '');
    obj.new_server_path = Utils.to_str(json['new_server_path'], '');
    obj.server_fail_reason = Utils.to_str(json['server_fail_reason'], '');
    obj.actor = Utils.to_str(json['actor'], '');
    obj.vj = Utils.to_str(json['vj'], '');
    obj.content_type = Utils.to_str(json['content_type'], '');
    obj.content_is_video = Utils.to_str(json['content_is_video'], '');
    obj.content_type_processed =
        Utils.to_str(json['content_type_processed'], '');
    obj.content_type_processed_time =
        Utils.to_str(json['content_type_processed_time'], '');
    obj.is_premium = Utils.to_str(json['is_premium'], '');
    obj.episode_number = Utils.to_str(json['episode_number'], '');
    obj.watch_progress = Utils.to_str(json['watch_progress'], '');
    obj.max_progress = Utils.to_str(json['max_progress'], '');
    obj.watch_status = Utils.to_str(json['watch_status'], '');
    obj.watched_movie = Utils.to_str(json['watched_movie'], '');
    return obj;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'title': title,
      'external_url': external_url,
      'url': url,
      'image_url': image_url,
      'thumbnail_url': thumbnail_url,
      'description': description,
      'year': year,
      'rating': rating,
      'duration': duration,
      'size': size,
      'genre': genre,
      'director': director,
      'stars': stars,
      'country': country,
      'language': language,
      'imdb_url': imdb_url,
      'imdb_rating': imdb_rating,
      'imdb_votes': imdb_votes,
      'imdb_id': imdb_id,
      'type': type,
      'status': status,
      'error': error,
      'error_message': error_message,
      'downloads_count': downloads_count,
      'views_count': views_count,
      'likes_count': likes_count,
      'dislikes_count': dislikes_count,
      'comments_count': comments_count,
      'comments': comments,
      'video_is_downloaded_to_server': video_is_downloaded_to_server,
      'video_downloaded_to_server_start_time':
          video_downloaded_to_server_start_time,
      'video_downloaded_to_server_end_time':
          video_downloaded_to_server_end_time,
      'video_downloaded_to_server_duration':
          video_downloaded_to_server_duration,
      'video_is_downloaded_to_server_status':
          video_is_downloaded_to_server_status,
      'video_is_downloaded_to_server_error_message':
          video_is_downloaded_to_server_error_message,
      'category': category,
      'category_id': category_id,
      'is_processed': is_processed,
      'downloaded_from_google': downloaded_from_google,
      'uploaded_to_from_google': uploaded_to_from_google,
      'local_video_link': local_video_link,
      'plays_on_google': plays_on_google,
      'downloaded_to_new_server': downloaded_to_new_server,
      'new_server_path': new_server_path,
      'server_fail_reason': server_fail_reason,
      'actor': actor,
      'vj': vj,
      'content_type': content_type,
      'content_is_video': content_is_video,
      'content_type_processed': content_type_processed,
      'content_type_processed_time': content_type_processed_time,
      'is_premium': is_premium,
      'episode_number': episode_number,
      'watch_progress': watch_progress,
      'max_progress': max_progress,
      'watch_status': watch_status,
      'watched_movie': watched_movie,
    };
  }

  Future submitViewProgress(int progress, int maxProgress,
      {String status = 'Active'}) async {
    // Update instance fields with new view progress data.
    watch_progress = progress.toString();
    max_progress = maxProgress.toString();
    watch_status = status;
    watched_movie = 'Yes';

    RespondModel resp =
        RespondModel(await Utils.http_post('save-view-progress', {
      'movie_id': id.toString(),
      'progress': progress.toString(),
      'max_progress': maxProgress.toString(),
      'status': status,
    }));
    if (resp.code != 1) {
      Utils.toast(resp.message);
      return;
    }
  }

  /// Example of searching the dynamic-list endpoint
  /// with 'title_like', 'page', and 'per_page'.
  static Future<List<NewMovieModel>> searchMoviesOnline({
    required String query,
    required int page,
    required int perPage,
  }) async {
    try {
      // Query your 'dynamic-list' endpoint with filters
      // 'model=movie' indicates we are searching the movies table
      final Map<String, dynamic> params = {
        'model': 'MovieModel',
        'title_like': query,
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      // Make the GET request using Utils.http_get or your helper method
      final rawResp = await Utils.http_get('dynamic-list', params);
      // Wrap it into a RespondModel for consistent structure
      final resp = RespondModel(rawResp);

      // If the code != 1, it indicates an error or empty data
      if (resp.code != 1 || resp.data == null) {
        return [];
      }

      // Data structure: resp.data is expected to have { items: [...], pagination: {...} }
      // So parse the 'items' array
      final items = resp.data['items'];
      if (items == null || items is! List) {
        return [];
      }

      // Convert each json object in the list to a NewMovieModel
      List<NewMovieModel> results = [];
      for (var jsonItem in items) {
        results.add(NewMovieModel.fromJson(jsonItem));
      }
      return results;
    } catch (e) {
      // Log or handle the error
      Utils.log('searchMoviesOnline error: $e');
      return [];
    }
  }

  static Future<List<NewMovieModel>> getMoviesOnline({
    required int page,
    required int perPage,
    String? vjFilter,
    String? genreFilter,
    String? typeFilter,
    String? categoryIdFilter,
    String? isFirstEpisode,
  }) async {
    // Construct query parameters for the dynamic-list API
    final Map<String, dynamic> params = {
      "model": "MovieModel",
      // or whatever your model name is in your dynamic-list
      "page": page.toString(),
      "per_page": perPage.toString(),
    };
    // If user selected a VJ, we can do a 'vj_like' or direct filter
    if (vjFilter != null && vjFilter.isNotEmpty) {
      // If your API expects vj_like, or vj=, adjust accordingly
      params["vj_like"] = vjFilter;
    }

    if (categoryIdFilter != null && categoryIdFilter.isNotEmpty) {
      // If your API expects vj_like, or vj=, adjust accordingly
      params["category_id"] = categoryIdFilter;
    }

    if (typeFilter != null && typeFilter.isNotEmpty) {
      // If your API expects vj_like, or vj=, adjust accordingly
      params["type"] = typeFilter;
    }
    // If user selected a Genre, we can do the same
    if (genreFilter != null && genreFilter.isNotEmpty) {
      // If your API expects genre_like, or genre=, adjust accordingly
      params["genre_like"] = genreFilter;
    } // If user selected a Genre, we can do the same
    if (isFirstEpisode != null && isFirstEpisode.isNotEmpty) {
      // If your API expects genre_like, or genre=, adjust accordingly
      params["is_first_episode"] = 'Yes';
    }

    // Now call your dynamic-list endpoint
    final resp = await Utils.http_get("dynamic-list", params);

    // If there's an error or no data => return empty
    if (resp == null || resp["code"] != 1) {
      return [];
    }

    final data = resp["data"];
    if (data == null) {
      return [];
    }

    // Grab the list of items
    final items = data["items"] as List<dynamic>? ?? [];
    // Convert each item to a NewMovieModel
    List<NewMovieModel> results = items.map((item) {
      return NewMovieModel.fromJson(item);
    }).toList();

    return results;
  }
}
