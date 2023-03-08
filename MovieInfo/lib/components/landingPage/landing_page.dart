import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sampleapplication/components/landingPage/components/SearchBuildMovie.dart';
import 'package:sampleapplication/components/landingPage/components/movie_carousel.dart';
import 'package:sampleapplication/constants.dart';
import 'package:sampleapplication/components/Movie.dart';
import 'package:sampleapplication/components/landingPage/components/body.dart';
import 'package:sampleapplication/components/landingPage/components/categories.dart';

import '../../main.dart';

// ignore: non_constant_identifier_names
final List<Movie> temp = Movie.movies;

class LandingPage extends StatefulWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  // Future _callAsyncFetch() {
  //   print("HEY!");
  //   return Future.delayed(Duration(seconds: 2));
  // }
  static int selectedGenre = 0;
  static List<String> genres = [
    "All",
    "Action",
    "Crime",
    "Comedy",
    "Drama",
    "Horror",
    "Animation"
  ];
  static Future callAsyncFetch() {
    print("HEY $selectedGenre");
    return Future.delayed(Duration(seconds: 0));
  }

  bool _LoadingScreen = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: callAsyncFetch(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: const Color(0xffEEF1F3),
                  appBar: buildAppBar(context),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Categorylist(),
                        SafeArea(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: kDefaultPadding / 2),
                                height: 36,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: genres.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          // _LoadingScreen = true;
                                          selectedGenre = index;
                                        });
                                        // await Future.delayed(
                                        //     Duration(seconds: 2));
                                        print("LENGTH OF TEMP IS " +
                                            temp.length.toString());
                                        List<Movie> FilteredList = [];
                                        if (genres[selectedGenre] != 'All') {
                                          for (var movie in temp) {
                                            if (movie.genre.contains(
                                                genres[selectedGenre])) {
                                              FilteredList.add(movie);
                                            }
                                          }
                                          setState(() {
                                            print("SET FIRST");
                                            // _LoadingScreen = false;
                                            if (MovieCarouselState
                                                .pageController.hasClients) {
                                              MovieCarouselState.pageController
                                                  .jumpTo(0);
                                              MovieCarouselState.initialPage =
                                                  0;
                                            }
                                            Movie.movies = FilteredList;
                                          });
                                        } else {
                                          setState(() {
                                            print("SET FIRST");
                                            // _LoadingScreen = false;
                                            if (MovieCarouselState
                                                .pageController.hasClients) {
                                              MovieCarouselState.pageController
                                                  .jumpTo(0);
                                              MovieCarouselState.initialPage =
                                                  0;
                                            }
                                            Movie.movies = temp;
                                          });
                                        }
                                        print("LENGTH OF FILTERED IS " +
                                            Movie.movies.length.toString());
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 10),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding,
                                          vertical: kDefaultPadding /
                                              4, // 5 padding top and bottom
                                        ),
                                        decoration: BoxDecoration(
                                          color: index == selectedGenre
                                              ? Colors.black38
                                              : Colors.transparent,
                                          border:
                                              Border.all(color: Colors.black45),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          genres[index],
                                          style: TextStyle(
                                              color: index == selectedGenre
                                                  ? Colors.white
                                                  : Colors.black
                                                      .withOpacity(0.8),
                                              fontSize: 16),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              MovieCarousel(Movie.movies)
                            ],
                          ),
                        ),
                        SizedBox(height: kDefaultPadding),
                        // MovieCarousel(Movie.movies),
                      ],
                    ),
                  ),
                ),
                if (_LoadingScreen == true)
                  const Opacity(
                    opacity: 0.8,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                if (_LoadingScreen == true)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          } else {
            return Scaffold(
                backgroundColor: const Color(0xffEEF1F3),
                body: Center(
                  child: CircularProgressIndicator(),
                ));
          }
        }));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffEEF1F3),
      elevation: 0,
      leading: IconButton(
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
      actions: <Widget>[
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {
            showSearch(context: context, delegate: MySearchDelegate());
          },
        ),
      ],
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query == '' ? close(context, null) : query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Movie> Filteredmovies = [];
    print("SIZE of final var = " + allMovies.length.toString());
    for (var movie in allMovies) {
      // print("QUERY IS $query and Title is " + movie.title);
      if (movie.title.toLowerCase().contains(query.toLowerCase())) {
        Filteredmovies.add(movie);
        print(true);
      }
    }
    MovieSearchBuildState.pageController = PageController(
      // so that we can have small portion shown on left and right side
      viewportFraction: 0.8,
      // by default our movie poster
      initialPage: 0,
    );
    MovieSearchBuildState.initialPage = 0;
    return Scaffold(
      backgroundColor: const Color(0xffEEF1F3),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100),
            // ignore: unnecessary_null_comparison
            Filteredmovies.isEmpty || query.isEmpty
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
                              'No result found for "$query"',
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
                : MovieSearchBuild(Filteredmovies)
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Movie> Filteredmovies = [];
    print("ALL MOVIE LENGTH IS " + allMovies.length.toString());
    for (var movie in allMovies) {
      if (query.isNotEmpty &&
          movie.title.toLowerCase().contains(query.toLowerCase())) {
        Filteredmovies.add(movie);
      }
    }
    print(Filteredmovies.length);
    return Scaffold(
        body: SafeArea(
            child: ListView.builder(
      itemCount: Filteredmovies.length,
      itemBuilder: (context, index) => Card(
        elevation: 6,
        margin: const EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            child: Text(Filteredmovies[index].title[0]),
          ),
          title: Text(Filteredmovies[index].title),
          subtitle: Text(Filteredmovies[index].genre.join(',')),
        ),
      ),
    )));
  }
}
