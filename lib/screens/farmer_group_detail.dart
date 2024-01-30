import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';

import '../models/FarmerGroupModel.dart';
import '../utils/CustomTheme.dart';

class FarmerGroupDetailScreen extends StatelessWidget {
  FarmerGroupDetailScreen({super.key});

  final FarmerGroupModel group = FarmerGroupModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: const [
          Icon(
            FeatherIcons.edit,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(
            width: 15,
          )
        ],
        title: FxText.titleLarge(
          'Farmer Group Details',
          color: Colors.white,
        ),
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: CustomTheme.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(group.photo),
              ),
            ),
            _buildDetailRow('Group Name', group.name),
            _buildDetailRow('Code', group.code),
            _buildDetailRow('Address', group.address),
            _buildDocumentRow('Registration Document'),
          ],
        ),
      ),
    );
  }


  Widget _buildDocumentRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.description, size: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
Widget _buildDetailRow(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
     // A horizontal line separator
      const SizedBox(height: 4.0), // Adding a small space between divider and value
      Text(
        value,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22.0, // Making the value text bigger
        ),
      ),
      const SizedBox(height: 4.0), // Adding a small space between description and value
      const Divider(),
    ],
  );
}