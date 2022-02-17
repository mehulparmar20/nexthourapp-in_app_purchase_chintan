import 'package:flutter/material.dart';
import '../../models/datum.dart';
import '../../providers/menu_data_provider.dart';
import '../../ui/shared/grid_video_container.dart';
import 'package:provider/provider.dart';
import '../../models/episode.dart';

class GenreWiseMoviesList extends StatefulWidget {
  final int? id;
  final String? title;
  final List<Datum> genreDataList;
  final DatumType type;

  GenreWiseMoviesList(this.id, this.title, this.genreDataList, this.type);

  @override
  _GenreWiseMoviesListState createState() => _GenreWiseMoviesListState();
}

class _GenreWiseMoviesListState extends State<GenreWiseMoviesList> {
  late List<Widget> videoList;

  @override
  Widget build(BuildContext context) {
    videoList = List.generate(
        widget.genreDataList == null ? 0 : widget.genreDataList.length,
        (index) {
      print("type: ${widget.genreDataList[index].type}");
      if (widget.type == widget.genreDataList[index].type) {
        return GridVideoContainer(context, widget.genreDataList[index]);
      } else {
        return SizedBox.shrink();
      }
    });
    videoList.removeWhere((value) => value == null);
    var menuByCat =
        Provider.of<MenuDataProvider>(context, listen: false).menuCatMoviesList;
    return menuByCat.length == 0
        ? SizedBox.shrink()
        : GridView.count(
            padding: EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 18 / 28,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 8.0,
            children: videoList);
    // Container(
    //     height: 170,
    //     margin: EdgeInsets.only(top: 15.0),
    //     child:
    //      ListView.builder(
    //         shrinkWrap: true,
    //         physics: ClampingScrollPhysics(),
    //         padding: EdgeInsets.only(left: 15.0),
    //         scrollDirection: Axis.horizontal,
    //         itemCount: menuByCat.length,
    //         itemBuilder: (BuildContext context, int index) {
    //           return menuByCat[index].canview == 1
    //               ? InkWell(
    //                   borderRadius: new BorderRadius.circular(5.0),
    //                   child: Container(
    //                     margin: EdgeInsets.only(right: 15.0),
    //                     child: Material(
    //                       color: Colors.transparent,
    //                       borderRadius: new BorderRadius.circular(5.0),
    //                       child: ClipRRect(
    //                         borderRadius: new BorderRadius.circular(5.0),
    //                         child: menuByCat[index].thumbnail == null
    //                             ? Image.asset(
    //                                 "assets/placeholder_box.jpg",
    //                                 height: 170,
    //                                 width: 120.0,
    //                                 fit: BoxFit.cover,
    //                               )
    //                             : FadeInImage.assetNetwork(
    //                                 image: APIData.movieImageUri +
    //                                     "${menuByCat[index].thumbnail}",
    //                                 placeholder:
    //                                     "assets/placeholder_box.jpg",
    //                                 height: 170,
    //                                 width: 120.0,
    //                                 imageScale: 1.0,
    //                                 fit: BoxFit.cover,
    //                               ),
    //                       ),
    //                     ),
    //                   ),
    //                   onTap: () {
    //                     Navigator.pushNamed(context, RoutePaths.videoDetail,
    //                         arguments: VideoDetailScreen(menuByCat[index]));
    //                   },
    //                 )
    //               : Stack(children: [
    //                   InkWell(
    //                     borderRadius: new BorderRadius.circular(5.0),
    //                     child: Container(
    //                       margin: EdgeInsets.only(right: 15.0),
    //                       child: Material(
    //                         color: Colors.transparent,
    //                         borderRadius: new BorderRadius.circular(5.0),
    //                         child: ClipRRect(
    //                           borderRadius: new BorderRadius.circular(5.0),
    //                           child: menuByCat[index].thumbnail == null
    //                               ? Image.asset(
    //                                   "assets/placeholder_box.jpg",
    //                                   height: 170,
    //                                   width: 120.0,
    //                                   fit: BoxFit.cover,
    //                                 )
    //                               : FadeInImage.assetNetwork(
    //                                   image: APIData.movieImageUri +
    //                                       "${menuByCat[index].thumbnail}",
    //                                   placeholder:
    //                                       "assets/placeholder_box.jpg",
    //                                   height: 170,
    //                                   width: 120.0,
    //                                   imageScale: 1.0,
    //                                   fit: BoxFit.cover,
    //                                 ),
    //                         ),
    //                       ),
    //                     ),
    //                     onTap: () {
    //                       Navigator.pushNamed(
    //                           context, RoutePaths.videoDetail,
    //                           arguments:
    //                               VideoDetailScreen(menuByCat[index]));
    //                     },
    //                   ),
    //                   Positioned(
    //                       bottom: 0,
    //                       child: Icon(
    //                         Icons.lock,
    //                         color: Colors.grey,
    //                       )),
    //                 ]);
    //         }),

    //   );
  }
}
