import 'package:flutter/material.dart';
import '/models/datum.dart';

class RatingInformation extends StatelessWidget {
  RatingInformation(this.mVideo);

  final Datum? mVideo;

  _buildRatingBar(ThemeData theme) {
    var stars = <Widget>[];
    var vRating;
    if (mVideo!.rating is String) {
      double ra = double.parse(mVideo!.rating);
      vRating = ra / 2;
    } else {
      vRating = mVideo!.rating / 2;
    }
    for (var i = 1; i <= 5; i++) {
      var star;
      if (i + 1 <= vRating + 1) {
        var color = theme.accentColor;
        star = new Icon(
          Icons.star,
          color: color,
        );
      } else {
        if (i + 0.5 <= vRating + 1) {
          var color = theme.accentColor;
          star = new Icon(
            Icons.star_half,
            color: color,
          );
        } else {
          var color = theme.accentColor;
          star = new Icon(
            Icons.star_border,
            color: color,
          );
        }
      }

      stars.add(star);
    }

    return new Flex(direction: Axis.horizontal, children: stars);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var ratingCaptionStyle = textTheme.caption!.copyWith(color: Colors.white70);
    var vRating;
    if (mVideo!.rating is String) {
      double ra = double.parse(mVideo!.rating);
      vRating = ra / 2;
      print("sss");
    } else {
      vRating = mVideo!.rating / 2;
      //  print("sss");
    }
    var numericRating = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        new Text(
          "$vRating",
          style: textTheme.headline6!.copyWith(
            fontWeight: FontWeight.w400,
            color: theme.accentColor,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: new Text(
            'Rating',
            style: ratingCaptionStyle,
          ),
        ),
      ],
    );

    var starRating = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRatingBar(theme),
      ],
    );

    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        numericRating,
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: starRating,
        ),
      ],
    );
  }
}
