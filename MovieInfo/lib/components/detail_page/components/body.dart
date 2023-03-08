import 'package:flutter/material.dart';
import 'package:sampleapplication/components/Movie.dart';
import 'package:sampleapplication/constants.dart';

import 'backdrop_rating.dart';
import 'cast_and_crew.dart';
import 'genres.dart';
import 'title_duration_and_fav_btn.dart';

class Body extends StatelessWidget {
  final Movie movie;

  const Body({Key? key, required this.movie}) : super(key: key);

  Future callAsyncFetch() => Future.delayed(Duration(seconds: 2));

  @override
  Widget build(BuildContext context) {
    // it will provide us total height and width
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: callAsyncFetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BackdropAndRating(size: size, movie: movie),
                  SizedBox(height: kDefaultPadding / 2),
                  TitleDurationAndFabBtn(movie: movie),
                  Genres(movie: movie),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: kDefaultPadding / 2,
                      horizontal: kDefaultPadding,
                    ),
                    child: Text(
                      "Plot Summary",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Text(
                      movie.plot,
                      style: TextStyle(
                        color: Color(0xFF737599),
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
