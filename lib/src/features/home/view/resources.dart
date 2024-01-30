// import "package:flutter/material.dart";
// import "package:get/get.dart";
// import "package:omulimisa2/src/features/home/view/widgets/video_item_widget.dart";
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import "../../../../core/styles.dart";
// import "../controller/resource_controller.dart";
// import "package:omulimisa2/src/features/home/view/widgets/photo_item_widget.dart";
// import "package:omulimisa2/src/features/home/view/widgets/document_card.dart";
// class ResourceScreen extends StatefulWidget {
//   const ResourceScreen({super.key});
//
//   @override State<ResourceScreen> createState() => _ResourceScreenState();
// }
//
// class _ResourceScreenState extends State<ResourceScreen> {
//   final ResourceController _resourceController = Get.put(ResourceController());
//
//   @override
//   void initState() {
//     super.initState();
//     _resourceController.fetchResources();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Obx(
//               () {
//             final state = _resourceController.state.value;
//             if (state == ResourceState.loading) {
//               return _buildSkeletonList(); // Show the skeleton effect
//             } else if (state == ResourceState.loaded) {
//               return _buildResourceList(); // Show the actual resource list
//             } else {
//               return _buildErrorScreen(); // Show error message
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSkeletonList() {
//     // Return a skeleton effect or shimmer widget while loading
//     // You can use any package that provides shimmer effect, like `shimmer` package
//    return  Center(
//       child: LoadingAnimationWidget.threeRotatingDots(
//         color: AppStyles.secondaryColor,
//         size: 30,
//       ),
//     );
//   }
//
//   Widget _buildResourceList() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment:MainAxisAlignment.start,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   // Handle back button press here
//                  Get.back();
//                 },
//               ),
//         const SizedBox(width:50),
//              Text(
//                "Resources",
//                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//              ),
//             ],
//           ),
//
//
//           Expanded(
//             child: ListView.builder(
//               itemCount: _resourceController.resources.length,
//               itemBuilder: (context, index) {
//                 final resource = _resourceController.resources[index];
//
//                 // Check which field is not null among file, photo, video, and audio
//                 if (resource.file != null) {
//                   final fileExtension = _getFileExtension(resource.file!);
//                   switch (fileExtension) {
//                     case 'docx':
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom:25),
//                         child: DocumentItemWidget(
//                           title: resource.heading,
//                           description: resource.body,
//                           postedAt: resource.createdAt,
//                           createdBy: resource.userId,
//                         ),
//                       );
//                   // Add other document extensions as needed (pdf, pptx, etc.)
//                   // case 'pdf':
//                   // case 'pptx':
//                   //   return DocumentItemWidget(...);
//                     default:
//                       return Container(); // Handle other document types as needed
//                   }
//                 } else if (resource.photo != null) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom:25),
//                     child: PhotoItemWidget(
//                       title: resource.heading,
//                       description: resource.body,
//                       postedAt: resource.createdAt,
//                       createdBy: resource.userId,
//                     ),
//                   );
//                 } else if (resource.video != null) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom:25),
//                     child: VideoItemWidget(
//                       title: resource.heading,
//                       description: resource.body,
//                       postedAt: resource.createdAt,
//                     ),
//                   );
//                 } else if (resource.audio != null) {
//                   return Container();
//                 } else {
//                   return Container(); // Handle other resource types as needed
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   String _getFileExtension(String filePath) {
//     final fileName = filePath.split('/').last;
//     final dotIndex = fileName.lastIndexOf('.');
//     if (dotIndex >= 0 && dotIndex < fileName.length - 1) {
//       return fileName.substring(dotIndex + 1);
//     }
//     return '';
//   }
//
//
//   Widget _buildErrorScreen() {
//     // Show error message UI when an error occurs
//     return Center(
//       child: Text('Error loading resources'),
//     );
//   }
// }
