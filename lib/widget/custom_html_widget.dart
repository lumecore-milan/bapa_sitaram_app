import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomHtmlWidget extends StatefulWidget {
  const CustomHtmlWidget({super.key,this.showHtml=false, required this.content,required this.title,required this.image, this.fontColor,this.fontWeight=FontWeight.bold});

  final String content,title,image;
  final Color? fontColor;
  final FontWeight fontWeight;
  final bool showHtml;

  @override
  State<CustomHtmlWidget> createState() => _CustomHtmlWidgetState();
}

class _CustomHtmlWidgetState extends State<CustomHtmlWidget> {
  late final WebViewController controller;
  String mainContent='';
  RxBool showPage=false.obs;
@override
  void initState() {
  // 1. Google Font Link
  String googleFontLink = '<link href="https://fonts.googleapis.com/css2?family=Hind+Vadodara:wght@400;700&display=swap" rel="stylesheet">';

// 2. Image and Title Variables
  String imageUrl =widget.image;
  String titleText = widget.title;

// 3. Updated Style (Mobile Responsive)
  String responsiveStyle = """
  <style type="text/css">
    * {
      box-sizing: border-box; /* Important: Padding width me count hogi */
    }
    body {
      font-family: 'Hind Vadodara', sans-serif;
      margin: 0;
      padding: 16px; /* Side me thodi jagah */
      width: 100vw; /* Screen ki full width */
      overflow-x: hidden; /* Horizontal scroll force disable */
      color: #000000;
      line-height: 1.5;
    }
    
    /* Image ko screen ke andar rakhne ke liye */
    .image-title { 
      max-width: 100% !important; 
      height: auto; 
      border-radius: 8px; 
      display: block;
      margin: 0 auto;
    }

    /* Title Styling */
    .header-title {
      font-size: 22px;
      font-weight: 700;
      margin-top: 12px;
      margin-bottom: 8px;
      text-align: center;
      color: #333;
    }
    
    /* HTML Data Content Styling */
    .content-body {
      font-size: 16px;
      text-align: left;
    }
  </style>
""";



  /*
// 4. Full HTML Assembly
  String fullHtml = """
  <!DOCTYPE html>
  <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      $googleFontLink
      $responsiveStyle
    </head>
    <body>
    
      <div>
         <img src="$imageUrl" alt="Cover Image" class="image-title"/>
      </div>

      <div class="header-title">
        $titleText
      </div>

      <div class="content-body">
        ${widget.content}
      </div>
      
    </body>
  </html>
""";

  */

  String fullHtml = """
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    $googleFontLink
    $responsiveStyle
  </head>
  <body>
""";

// Add image only if URL is not empty
  if (imageUrl.isNotEmpty) {
    fullHtml += """
    <div>
      <img src="$imageUrl" alt="Cover Image" class="image-title"/>
    </div>
  """;
  }

// Add title only if not empty
  if (titleText.trim().isNotEmpty) {
    fullHtml += """
    <div class="header-title">
      $titleText
    </div>
  """;
  }

// Always add content
  fullHtml += """
    <div class="content-body">
      ${widget.content}
    </div>
  </body>
</html>
""";



  controller = WebViewController()
    ..loadHtmlString(fullHtml)..setJavaScriptMode(JavaScriptMode.unrestricted);

   if(widget.image.isNotEmpty) {
     Future.delayed(Duration(seconds: 1)).then((t) {
       showPage.value = true;
     });
   }else{
     showPage.value = true;
   }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showHtml==false ?
          Obx(()=>

          showPage.value==false ? ShimmerDemo(count: 10):
              WebViewWidget(controller: controller)):
      Html(
      data: widget.content,
      style: {
        "p": Style(
          fontSize: FontSize(18),
          color:widget.fontColor?? CustomColors().black,
          fontWeight: widget.fontWeight,
          textAlign: TextAlign.left,
          lineHeight: LineHeight(1),
          fontFamily: "Hind Vadodara",
          padding: HtmlPaddings.zero,
          margin: Margins.zero,
        ),
        "h4": Style(
          fontFamily: "Hind Vadodara",
          fontSize: FontSize(18),
          fontWeight: widget.fontWeight,
          textAlign: TextAlign.left,
          padding: HtmlPaddings.zero,
          margin: Margins.zero,
          color:widget.fontColor?? CustomColors().black,
        ),
        "div": Style(
            padding: HtmlPaddings.zero,
            margin: Margins.zero,
            fontWeight: widget.fontWeight,
            textAlign: TextAlign.left, fontFamily: "Hind Vadodara",color:widget.fontColor?? CustomColors().black),
        "span": Style(
            padding: HtmlPaddings.zero,
            margin: Margins.zero,
            fontWeight: widget.fontWeight,
            fontSize: FontSize(18,), fontFamily: "Hind Vadodara",color:widget.fontColor?? CustomColors().black),
      },
    );
  }
}
