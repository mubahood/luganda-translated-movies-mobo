import "package:flutter/material.dart";

import "../../../../../core/styles.dart";
import 'package:html/parser.dart' as html_parser;
class PhotoItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String createdBy;
  final String postedAt;

  const PhotoItemWidget({super.key,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.postedAt,
  });
  String extractDateFromDateTimeString(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final formattedDate = "${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}";
      return formattedDate;
    } catch (e) {
      // Return the original string if parsing fails
      return dateTimeString;
    }
  }
  @override
  Widget build(BuildContext context) {
    String textInsidePTags = html_parser.parse(description).body!.text;
    return Card(
      color: AppStyles.backgroundWhite,
      surfaceTintColor: AppStyles.backgroundWhite,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Image.network(
                'https://unified.m-omulimisa.com/storage/images/logo.png', // Replace with your photo URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.googleFontMontserrat.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  textInsidePTags,
                  style: AppStyles.googleFontMontserrat.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(extractDateFromDateTimeString(postedAt), style: AppStyles.googleFontMontserrat.copyWith(color: Colors.black)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



