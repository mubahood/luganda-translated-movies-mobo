import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import "package:get/get.dart";
import "package:omulimisa2/src/features/home/view/widgets/document_card.dart";
import "package:omulimisa2/src/features/home/view/widgets/video_item_widget.dart";

import '../../core/styles.dart';
import "../../models/ResourceModel.dart";
import '../../src/features/home/view/widgets/pdf_document_widget.dart';
import '../../src/features/home/view/widgets/youtube_widget.dart';
import '../../utils/AppConfig.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';

class ResourceDetailScreen extends StatelessWidget {
  final ResourceModel resourceModel;

  const ResourceDetailScreen({super.key, required this.resourceModel});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: FxText.titleLarge(
          'Resource Detail',
          color: Colors.white,
        ),
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: CustomTheme.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, ),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: //
                Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildContentWidget(),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top:10),
                  child: Text(
                    resourceModel.heading,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      letterSpacing: .01,
                      height: 1,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Html(
                        data: resourceModel.body,
                        style: {
                          '*': Style(
                            color: Colors.grey.shade700,
                          ),
                          "strong": Style(
                              color: CustomTheme.primary,
                              fontSize: FontSize(18),
                              fontWeight: FontWeight.normal),
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FxContainer(
                        color: CustomTheme.primary,
                        borderRadiusAll: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                downLoadResource();
                              },
                              child: FxText.bodySmall(
                                'Download',
                                fontWeight: 800,
                                fontSize: 10,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(width:5),
                     const   Icon(Icons.save, size:15, color:Colors.white)
                      ],
                    ),
                  ),
                  FxContainer(
                    color: CustomTheme.primary,
                    borderRadiusAll: 0,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: FxText.bodySmall(
                      Utils.to_date(resourceModel.created_at),
                      fontWeight: 800,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void downLoadResource(){
    if (resourceModel.file.isNotEmpty) {
      _downloadDocument(resourceModel.file);
    } else if (resourceModel.photo.isNotEmpty) {
      _downloadDocument(resourceModel.photo);
    } else if (resourceModel.video.isNotEmpty) {
      _downloadDocument(resourceModel.video);
    } else {
      Get.snackbar('No Resource', 'No resource to download.');
    }
  }
  Widget _buildContentWidget() {
    if (resourceModel.type == 'File' && resourceModel.file.isNotEmpty) {
      final fileExtension = resourceModel.file.split('.').last.toLowerCase();
      if (fileExtension == 'pdf') {
        return PDFScreen(
          path: resourceModel.file,
        );
      } else {
        return DocumentItemWidget(
          filePath: '',
        );
      }
    } else if (resourceModel.type == 'Video' && resourceModel.video.isNotEmpty) {
      return VideoItemWidget(
        videoPath: resourceModel.video,
      );
    } else if (resourceModel.type == 'Youtube' && resourceModel.youtube.isNotEmpty) {
      // final youtubeUrl = resourceModel.youtube;
      // final videoId = extractVideoId(youtubeUrl);
      // if (videoId != null) {
      //   return YoutubeVideoWidget(videoId: videoId);
      // }
      return  const YoutubePlayerDemo(videoId: '',);
    } else if (resourceModel.type == 'Photo' && resourceModel.photo.isNotEmpty) {
      final imageUrl = resourceModel.photo;
      if (imageUrl.isEmpty) {
        return const Image(
          image: AssetImage(
            AppConfig.NO_IMAGE,
          ),
          fit: BoxFit.cover,
          height: 200,
        );
      } else {
        return Image.network(
          'https://unified.m-omulimisa.com/storage/$imageUrl',
          fit: BoxFit.cover,
          height: 200,
        );
      }
    }

    // Default widget for empty or unsupported resources
    return _buildDefaultWidget();
  }

  Widget _buildDefaultWidget() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppStyles.primaryColor, // Background color
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Center(
        child: Icon(
          Icons.error_outline,
          size: 64.0,
          color: Colors.white, // Icon color
        ),
      ),
    );
  }

  String? extractVideoId(String youtubeUrl) {
    final Uri uri = Uri.parse(youtubeUrl);

    if (uri.host == 'youtu.be') {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    }

    if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }

      if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'embed') {
        return uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      }
    }

    return null;
  }

}




Future<void> _downloadDocument(String filePathFromResponse) async {
  // Extract the filename from the file path
  final fileName = filePathFromResponse.split('/').last;

  // Join the base URL with the file path to get the full download URL
  const baseUrl = 'https://unified.m-omulimisa.com/storage/';
  final fullUrl = baseUrl + filePathFromResponse;

 /* FileDownloader.downloadFile(
      url: fullUrl,
      name: fileName,
      onProgress: (name, progress) {
      },
      onDownloadCompleted: (path) {
        Utils.toast('File downloaded to: $path', isLong: true);
      },
      onDownloadError: (error) {
        Utils.toast2('Download error: $error',
            background_color: Colors.red, color: Colors.white);
      }).then((file) {
    debugPrint('file path: ${file?.path}');
  });*/

}
