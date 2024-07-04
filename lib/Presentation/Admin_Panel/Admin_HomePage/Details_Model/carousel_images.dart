// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CarouselImages extends StatefulWidget {
  final List<String> imagesListUrl;

  const CarouselImages(this.imagesListUrl, {super.key});

  @override
  _CarouselImagesState createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
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
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: size.height * 0.30,
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
        ),
        const SizedBox(height: 10),
      ],
    );
  }

}
