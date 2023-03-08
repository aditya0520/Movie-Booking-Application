import 'package:flutter/material.dart';
import 'package:sampleapplication/components/Movie.dart';
import 'package:sampleapplication/components/detail_page/components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Movie movie;

  const DetailsScreen({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(movie: movie),
    );
  }
}
