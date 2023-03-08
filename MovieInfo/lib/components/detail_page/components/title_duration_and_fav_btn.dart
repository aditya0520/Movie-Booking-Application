import 'package:flutter/material.dart';
import 'package:sampleapplication/components/Movie.dart';

import '../../../constants.dart';

class TitleDurationAndFabBtn extends StatelessWidget {
  const TitleDurationAndFabBtn({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          bottom: kDefaultPadding),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              movie.title,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: kDefaultPadding / 2),
            Row(
              children: <Widget>[
                Text(
                  '${movie.year}',
                  style: TextStyle(color: kTextLightColor, fontSize: 16),
                ),
                SizedBox(width: kDefaultPadding),
                Text(
                  "English",
                  style: TextStyle(color: kTextLightColor, fontSize: 16),
                ),
                SizedBox(width: kDefaultPadding),
                Text(
                  "2h 32min",
                  style: TextStyle(color: kTextLightColor, fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
