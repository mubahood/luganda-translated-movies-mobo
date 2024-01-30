import "package:flutter/material.dart";

import "../../../../../core/styles.dart";
class DocumentItemWidget extends StatefulWidget {
   String filePath;


   DocumentItemWidget({super.key,
    required this.filePath
  });

  @override
  State<DocumentItemWidget> createState() => _DocumentItemWidgetState();
}

class _DocumentItemWidgetState extends State<DocumentItemWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: AppStyles.textHighlightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.insert_drive_file, size: 60, color: Colors.white),
          ),

        ],
      ),
    );

  }
}

