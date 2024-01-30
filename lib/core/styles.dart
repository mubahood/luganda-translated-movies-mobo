import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppStyles{
    static const primaryColor = Color(0xFF086433);
    static const secondaryColor = Color(0xFF47C757);
    static const lowOpacityColor = Color(0xFFF2F4DF);
    static const textHighlightColor = Color(0xFF227763);
    static const  backgroundWhite = Colors.white;
    static const black = Colors.black;
    static const formFieldsOutlineBorderColor = Color(0xFFB8BCBF);
    static const double  buttonHeight = 60;
    static const double buttonBorderRadius = 50;
    static const double formFieldsOutlineBorderRadius = 30;
    static const double formFieldsHeight = 60;
    static const double formFieldsContentPaddingVertical = 17;
    static const double formFieldsContentPaddingHorizontal = 30;
    static var googleFontMontserrat = GoogleFonts.montserrat();
    static var folderIcon = SvgPicture.string(
        """
        <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 18">
    <path d="M4.09 7.586A1 1 0 0 1 5 7h13V6a2 2 0 0 0-2-2h-4.557L9.043.8a2.009 2.009 0 0 0-1.6-.8H2a2 2 0 0 0-2 2v14c.001.154.02.308.058.457L4.09 7.586Z"/>
    <path d="M6.05 9 2 17.952c.14.031.281.047.424.048h12.95a.992.992 0 0 0 .909-.594L20 9H6.05Z"/>
  </svg>
            """,
        colorFilter: const ColorFilter.mode(backgroundWhite, BlendMode.srcIn),
    );
}
