// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AdminCarouselImages extends StatefulWidget {
  final List<String> imagesListUrl;

  const AdminCarouselImages(this.imagesListUrl, {super.key});

  @override
  _AdminCarouselImagesState createState() => _AdminCarouselImagesState();
}

class _AdminCarouselImagesState extends State<AdminCarouselImages> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: size.height * 0.35,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imagesListUrl.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.imagesListUrl[index],
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ],
    );
  }

}
