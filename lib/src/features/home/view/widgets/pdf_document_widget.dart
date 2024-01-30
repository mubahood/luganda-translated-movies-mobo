
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter/material.dart';
class PDFScreen extends StatefulWidget {
  final String path;

  const PDFScreen({Key? key, required this.path}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:200,
        child: const PDF().cachedFromUrl(
          'https://unified.m-omulimisa.com/storage/${widget.path}',
          maxAgeCacheObject:const Duration(days: 30), //duration of cache
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text(error.toString())),
        )
    );
  }
}



