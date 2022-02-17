// ignore: must_be_immutable
import 'package:flutter/material.dart';
import '/providers/menu_data_provider.dart';
import '/ui/shared/appbar.dart';
import '/ui/shared/grid_video_container.dart';
import 'package:provider/provider.dart';

class GridMovieTV extends StatelessWidget {
  final String type;
  GridMovieTV(this.type);
  var moviesList = [];
  var tvSeriesList = [];
  var newList = [];
  var upcomingList = [];
  List<Widget> videoList = [];
  @override
  Widget build(BuildContext context) {
    moviesList = Provider.of<MenuDataProvider>(context).menuCatMoviesList;
    tvSeriesList = Provider.of<MenuDataProvider>(context).menuCatTvSeriesList;
    newList = new List.from(moviesList)..addAll(tvSeriesList);
    var featuredList = List.from(
        newList.where((item) => item.featured == "1" || item.featured == 1));
    upcomingList = List.from(newList
        .where((item) => item.isUpcoming == "1" || item.isUpcoming == 1));
    videoList.clear();
    videoList = List.generate(
        type == "M"
            ? moviesList.length
            : type == 'T'
                ? tvSeriesList.length
                : type == "U"
                    ? upcomingList.length
                    : featuredList.length, (index) {
      return type == "M"
          ? GridVideoContainer(context, moviesList[index])
          : type == 'T'
              ? GridVideoContainer(context, tvSeriesList[index])
              : type == 'U'
                  ? GridVideoContainer(context, upcomingList[index])
                  : GridVideoContainer(context, featuredList[index]);
    });

    return Scaffold(
      appBar: customAppBar(
          context,
          type == "M"
              ? "Movies"
              : type == 'T'
                  ? "TV Series"
                  : type == 'U'
                      ? "Coming Soon"
                      : "Featured") as PreferredSizeWidget?,
      body: GridView.count(
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 18 / 28,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 8.0,
          children: videoList),
    );
  }
}
