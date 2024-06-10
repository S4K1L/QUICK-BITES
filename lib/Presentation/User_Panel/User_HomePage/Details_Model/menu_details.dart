import 'package:flutter/material.dart';

import '../../../../Theme/constant.dart';
import '../manu_model.dart';


class MenuDetails extends StatefulWidget {
  final MenuModel menu;
  const MenuDetails(this.menu, {super.key});

  @override
  _MenuDetailsState createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      detailsWidgets(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column detailsWidgets(BuildContext context) {
    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width/2,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: sSecondaryColor
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 4),
                              child: Expanded(
                                child: Text(
                                  widget.menu.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: MediaQuery.of(context).size.width/4,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: sOrangeColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${widget.menu.calories} Calories',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: MediaQuery.of(context).size.width/4,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: sOrangeColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${widget.menu.sugar} Sugar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Ingredient',
                            style: TextStyle(
                                fontSize: 12
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Expanded(
                            child: Text(
                              widget.menu.details,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
  }
}
