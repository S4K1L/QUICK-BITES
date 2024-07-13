// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import '../../../User_Panel/User_HomePage/Details_Model/manu_model.dart';
import '../../../User_Panel/User_HomePage/post_details/components/custom_app_bar.dart';
import 'chef_carouselImages.dart';
import 'chef_menu_details.dart';


class ChefDetailsScreen extends StatefulWidget {
  final MenuModel menu;

  const ChefDetailsScreen({super.key, required this.menu});

  @override
  _ChefDetailsScreenState createState() => _ChefDetailsScreenState();
}

class _ChefDetailsScreenState extends State<ChefDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ChefCarouselImages(widget.menu.moreImagesUrl),
              const CustomAppBar(),
            ],
          ),
          //Categories(),
          Expanded(child: ChefMenuDetails(widget.menu)),
        ],
      ),
    );
  }
}
