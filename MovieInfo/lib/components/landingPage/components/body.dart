import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sampleapplication/constants.dart';
import 'package:sampleapplication/components/Movie.dart';
import 'dart:math' as math;

import 'categories.dart';
import 'movie_card.dart';
import 'movie_carousel.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // it enable scroll on small device
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Categorylist(),
          SizedBox(height: kDefaultPadding),
          // MovieCarousel(Movie.movies),
        ],
      ),
    );
  }
}
