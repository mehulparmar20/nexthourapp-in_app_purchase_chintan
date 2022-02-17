import 'package:flutter/material.dart';
import '/common/apipath.dart';
import '/common/route_paths.dart';
import '/models/episode.dart';
import '/providers/movie_tv_provider.dart';
import '/ui/screens/video_detail_screen.dart';
import '/ui/shared/appbar.dart';
import 'package:provider/provider.dart';

class TopGridView extends StatefulWidget {
  @override
  _TopGridViewState createState() => _TopGridViewState();
}

class _TopGridViewState extends State<TopGridView> {
  late List<Widget> videoList;

  @override
  Widget build(BuildContext context) {
    var topVideosList = Provider.of<MovieTVProvider>(context).topVideoList;
    videoList = List.generate(topVideosList.length, (index) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
        child: Material(
          borderRadius: new BorderRadius.circular(5.0),
          child: InkWell(
            borderRadius: new BorderRadius.circular(5.0),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(5.0),
              child: topVideosList[index].thumbnail == null
                  ? Image.asset(
                      "assets/placeholder_box.jpg",
                      fit: BoxFit.cover,
                    )
                  : FadeInImage.assetNetwork(
                      image: topVideosList[index].type == DatumType.T
                          ? "${APIData.tvImageUriTv}${topVideosList[index].thumbnail}"
                          : "${APIData.movieImageUri}${topVideosList[index].thumbnail}",
                      placeholder: "assets/placeholder_box.jpg",
                      imageScale: 1.0,
                      fit: BoxFit.cover,
                    ),
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.videoDetail,
                  arguments: VideoDetailScreen(topVideosList[index]));
            },
          ),
        ),
      );
    });

    return Scaffold(
      appBar: customAppBar(context, "Top Movies & TV Series")
          as PreferredSizeWidget?,
      body: GridView.count(
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 5 / 4,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          children: videoList),
    );
  }
}
