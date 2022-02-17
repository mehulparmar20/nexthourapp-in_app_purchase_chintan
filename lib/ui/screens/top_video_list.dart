import 'package:flutter/material.dart';
import '/common/apipath.dart';
import '/common/route_paths.dart';
import '/models/episode.dart';
import '/providers/movie_tv_provider.dart';
import '/ui/screens/video_detail_screen.dart';
import 'package:provider/provider.dart';

class TopVideoList extends StatelessWidget {
  final loading;
  TopVideoList({this.loading});
  @override
  Widget build(BuildContext context) {
    var topMovieTV =
        Provider.of<MovieTVProvider>(context, listen: false).topVideoList;
    return loading == true
        ? ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(left: 15.0),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(right: 20.0),
                height: 350,
                width: 200.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColorDark.withOpacity(0.1),
                        Theme.of(context).primaryColorDark.withOpacity(0.7),
                        Theme.of(context).primaryColorDark.withOpacity(0.95),
                        Theme.of(context).primaryColorDark
                      ],
                      stops: [
                        0.3,
                        0.65,
                        0.85,
                        1.0
                      ]),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: new BorderRadius.circular(5.0),
                        child: Image.asset(
                          "assets/placeholder_box.jpg",
                          height: 350,
                          width: 200.5,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
              );
            })
        : ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(left: 15.0),
            scrollDirection: Axis.horizontal,
            itemCount: topMovieTV.length,
            itemBuilder: (BuildContext context, int index) {
              final split = topMovieTV[index].title!.split(' ');
              var values = <Widget>[];
              for (int i = 0; i < split.length; i++) {
                print(split[i]);
                if (i == 0) {
                  values.add(Text(
                    '${split[i]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ));
                } else {
                  values.add(Text(
                    '${split[i]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 28.0,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ));
                }
              }

              return Container(
                margin: EdgeInsets.only(right: 20.0),
                height: 350,
                width: 200.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColorDark.withOpacity(0.1),
                        Theme.of(context).primaryColorDark.withOpacity(0.7),
                        Theme.of(context).primaryColorDark.withOpacity(0.95),
                        Theme.of(context).primaryColorDark
                      ],
                      stops: [
                        0.3,
                        0.65,
                        0.85,
                        1.0
                      ]),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: new BorderRadius.circular(5.0),
                      child: topMovieTV[index].thumbnail == null
                          ? Image.asset(
                              "assets/placeholder_box.jpg",
                              height: 350,
                              width: 200.5,
                              fit: BoxFit.cover,
                            )
                          : FadeInImage.assetNetwork(
                              image: topMovieTV[index].type == DatumType.T
                                  ? "${APIData.tvImageUriTv}${topMovieTV[index].thumbnail}"
                                  : "${APIData.movieImageUri}${topMovieTV[index].thumbnail}",
                              placeholder: "assets/placeholder_box.jpg",
                              height: 350,
                              width: 200.5,
                              imageScale: 1.0,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/placeholder_box.jpg",
                                  height: 350,
                                  width: 200.5,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                    ),
                    new Material(
                      type: MaterialType.transparency,
                      child: new ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            visualDensity: VisualDensity(
                                vertical: VisualDensity.maximumDensity),
                            elevation: 0.0,
                            animationDuration: Duration(seconds: 50),
                            onPrimary: Colors.white),
                        child: Container(
                          alignment: Alignment.center,
                          height: 350,
                          width: 200.5,
                          padding: EdgeInsets.all(0.0),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutePaths.videoDetail,
                              arguments: VideoDetailScreen(topMovieTV[index]));
                        },
                        onLongPress: () {
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              );
            });
  }
}
