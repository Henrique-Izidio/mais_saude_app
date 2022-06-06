import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Caroussel extends StatelessWidget {
  
  var listSlide = [
    Colors.blue,
    Colors.green,
    Colors.red
  ];

  Caroussel({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        CarouselSlider(
          options: CarouselOptions(height: 175),
          items: [0, 1, 2].map((currentSlide) {
            return Builder(builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: listSlide[currentSlide],
                ),
              );
            });
          }).toList(),
        )
      ]),
    );
  }
}
