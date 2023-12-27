import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class AppNetworkImage extends StatelessWidget {
  final String src;
  const AppNetworkImage({Key? key, required this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src,
      height: 100, width: 100, fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
