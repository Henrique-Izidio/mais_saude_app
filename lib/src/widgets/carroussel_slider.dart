import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Caroussel extends StatelessWidget {
  var listSlide = [
    'assets/images/banner-1.png',
    'assets/images/banner-2.png',
    'assets/images/banner-3.png',
  ];

  Caroussel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wSize = MediaQuery.of(context).size.width;
    double hSize = wSize <= 300 ? 175 : wSize / 3.5;
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: CarouselSlider(
            options: CarouselOptions(height: hSize),
            items: [0, 1, 2].map((currentSlide) {
              return Builder(builder: (context) {
                return Container(
                  width: wSize,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Image(
                    image: AssetImage(listSlide[currentSlide]),
                    fit: BoxFit.fill,
                  ),
                );
              });
            }).toList(),
          ),
        )
      ]),
    );
  }
}
