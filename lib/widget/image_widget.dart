import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../utils/svg_helper/svg.dart';

final class FileList {
  FileList({required this.url, this.storedFileName = ''});

  final String url;
  String storedFileName;
}

sealed class CachedFile {
  static List<FileList> cacheList = List.empty(growable: true);
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({
    required this.url,
    this.height,
    this.width,
    super.key,
    this.color,
    this.fit,
    this.downloadCacheDirectory,
    this.cached = true,
    this.loadIndicatorHeight = 24,
    this.loadIndicatorWidth=24,
  });

  final String url;
  final double? height, width;
  final Color? color;
  final BoxFit? fit;
  final Directory? downloadCacheDirectory;
  final bool cached;
  final double loadIndicatorHeight, loadIndicatorWidth;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool get _isUrl =>
      Uri.tryParse(widget.url) != null &&
      (Uri.tryParse(widget.url)!.scheme.isNotEmpty);

  bool get _isAssets => widget.url.toLowerCase().startsWith('assets/');

  bool get _isSvg => widget.url.toLowerCase().endsWith('.svg');

  String _existingPath = '';

  Future<bool> _isLocalPath() async {
    bool fileExist = false;
    try {
      if (kIsWeb) {
        return fileExist;
      }
      if (_isUrl == false && _isAssets == false) {
        fileExist = await File(widget.url).exists();
      }
    } catch (e) {
      //
    }
    return fileExist;
  }
  @override
  void initState() {
    super.initState();

    if (_isUrl) {
      if (kIsWeb) {
      } else if (widget.url.toLowerCase().endsWith('.svg') == false) {
      } else if (CachedFile.cacheList.indexWhere((t) => t.url == widget.url) >=
          0) {
        _existingPath = CachedFile.cacheList
            .firstWhere((t) => t.url == widget.url)
            .storedFileName;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_existingPath.isNotEmpty) {
      return _localImage(isSvg: _isSvg);
    } else if (_isAssets) {
      return _assetImage(isSvg: _isSvg);
    } else if (_isUrl) {
      return _networkImage(isSvg: _isSvg);
    } else {

      return _localImage(isSvg: _isSvg);
    }
  }

  Widget _assetImage({required bool isSvg}) {
    if (_isSvg) {
      return SvgPicture.asset(
        widget.url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit ?? BoxFit.cover,
        colorFilter: widget.color != null
            ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) => SizedBox(
          width: widget.width,
          height: widget.height,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.error, color: Colors.red, size: widget.height),
      );
    } else {
      return Image.asset(
        widget.url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.error, color: Colors.red, size: widget.height),
      );
    }
  }

  Widget _networkImage({required bool isSvg}) {
    if (_isSvg) {
      return SvgPicture.network(
        widget.url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit ?? BoxFit.cover,
        colorFilter: widget.color != null
            ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) => SizedBox(
          width: widget.loadIndicatorWidth,
          height: widget.loadIndicatorHeight,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.error, color: Colors.red, size: widget.height),
      );
    } else {
      return widget.cached
          ? CachedNetworkImage(
              imageUrl: widget.url,
              width: widget.width,
              height: widget.height,
              fit: widget.fit ?? BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) => SizedBox(
                width: widget.loadIndicatorWidth,
                height: widget.loadIndicatorHeight,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Icon(
                size: widget.height != null ? widget.height! / 2 : 50,
                Icons.error,
                color: Colors.red,
              ),
            )
          : Image.network(
              widget.url,
              width: widget.width,
              height: widget.height,
              fit: widget.fit ?? BoxFit.cover,
              loadingBuilder: (context, url, progress) => SizedBox(
                width: widget.loadIndicatorWidth,
                height: widget.loadIndicatorHeight,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.error, color: Colors.red, size: widget.height),
            );
    }
  }

  Widget _localImage({required bool isSvg}) {
    return FutureBuilder(
      future: _isLocalPath(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Icon(
            Icons.access_time,
            color: Colors.red,
            size: widget.height,
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == true) {

          if(isSvg==false) {
            return Image.file(

              File(widget.url),
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
            );
          }
          return LocalImageFactory.getInstance(
            isSvg: _isSvg,
            width: widget.width,
            height: widget.height,
            fit: widget.fit ?? BoxFit.cover,
            url: widget.url,
          );
        } else {
          return Icon(Icons.error, color: Colors.red, size: widget.height);
        }
      },
    );
  }
}
