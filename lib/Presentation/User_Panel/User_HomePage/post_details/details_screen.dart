// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Details_Model/manu_model.dart';
import 'components/carousel_images.dart';
import 'components/custom_app_bar.dart';
import 'components/menu_details.dart';


class DetailsScreen extends StatefulWidget {
  final MenuModel menu;

  const DetailsScreen({super.key, required this.menu});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              CarouselImages(widget.menu.moreImagesUrl),
              const CustomAppBar(),
            ],
          ),
          //Categories(),
          Expanded(child: MenuDetails(widget.menu)),
        ],
      ),
    );
  }
}
