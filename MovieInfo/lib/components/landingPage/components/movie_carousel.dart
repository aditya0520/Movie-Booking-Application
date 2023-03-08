import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:sampleapplication/components/Movie.dart';
import 'package:sampleapplication/components/landingPage/components/body.dart';
import 'package:sampleapplication/components/landingPage/landing_page.dart';
import '../../../constants.dart';
import 'movie_card.dart';

class MovieCarousel extends StatefulWidget {
  final List<Movie> movies;
  const MovieCarousel(this.movies, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  MovieCarouselState createState() => MovieCarouselState();
}

class MovieCarouselState extends State<MovieCarousel> {
  // ignore: prefer_final_fields
  static late PageController pageController;
  static double value = 0;
  static int initialPage = 0;
  // ignore: prefer_final_fields

  @override
  void initState() {
    pageController = PageController(
      // so that we can have small portion shown on left and right side
      viewportFraction: 0.8,
      // by default our movie poster
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageController = PageController(
      // so that we can have small portion shown on left and right side
      viewportFraction: 0.8,
      // by default our movie poster
      initialPage: 0,
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: Movie.movies.isEmpty
            ? Column(
                children: [
                  Positioned(
                    top: 24,
                    bottom: 50,
                    left: 24,
                    right: 24,
                    child: Container(
                      child: Image.asset('assets/images/noResult.png'),
                    ),
                  ),
                  Positioned(
                    top: 75,
                    bottom: 0,
                    left: 24,
                    right: 24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No Video Found!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xff2f3640),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    initialPage = value;
                    print("Value is $value");
                  });
                },
                controller: pageController,
                physics: ClampingScrollPhysics(),
                itemCount: widget.movies.length, // we have 3 demo movies
                itemBuilder: (context, index) => buildMovieSlider(index),
              ),
      ),
    );
  }

  Widget buildMovieSlider(int index) => AnimatedBuilder(
        animation: pageController,
        builder: (context, child) {
          print(pageController);
          if (pageController.position.haveDimensions) {
            value = index - pageController.page!;
            // We use 0.038 because 180*0.038 = 7 almost and we need to rotate our poster 7 degree
            // we use clamp so that our value vary from -1 to 1
            value = (value * 0.038).clamp(-1, 1);
          }
          print(pageController.keepPage);
          // print("VALUE is $value");
          print("INDEX IS $index and initial page  = $initialPage");
          print("MOVIE LENGTH IS " + widget.movies.length.toString());
          return AnimatedOpacity(
            duration: Duration(milliseconds: 350),
            opacity: initialPage == index ? 1 : 0.4,
            child: Transform.rotate(
              angle: initialPage == 0 ? 0 : math.pi * value,
              child: MovieCard(movie: widget.movies[index]),
            ),
          );
        },
      );
}
