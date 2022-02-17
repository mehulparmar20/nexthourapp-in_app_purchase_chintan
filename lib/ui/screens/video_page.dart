import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/my_app.dart';
// import 'package:flutter_translate/flutter_translate.dart';
import '/models/episode.dart';
import '/providers/app_config.dart';
import '/providers/main_data_provider.dart';
import '/providers/menu_data_provider.dart';
import '/providers/movie_tv_provider.dart';
import '/ui/shared/actors_horizontal_list.dart';
import '/ui/shared/heading1.dart';
import '/ui/screens/horizental_genre_list.dart';
import '/ui/screens/horizontal_movies_list.dart';
import '/ui/screens/horizontal_tvseries_list.dart';
import '/ui/screens/top_video_list.dart';
import '/ui/shared/live_video_list.dart';
import '/ui/widgets/blog_view.dart';
import 'package:provider/provider.dart';

import 'featured-list.dart';
import 'home-screen-shimmer.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';

class VideosPage extends StatefulWidget {
  VideosPage({Key? key, this.loading, this.menuId}) : super(key: key);
  final loading;
  final menuId;

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;

  @override
  bool get wantKeepAlive => true;

  GlobalKey _keyRed = GlobalKey();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var meData;
  ScrollController controller = ScrollController(initialScrollOffset: 0.0);
  bool _visible = false;
  var menuDataList;
  var moviesList;
  var tvSeriesList;
  var liveDataList;
  var topVideosList;
  var blogList;
  var actorsList;
  var actorsListLen;
  var topVideosListLen;
  var liveDataListLen;
  var moviesListLen;
  var upComingMovie;
  var upComingMovieLen;
  var tvSeriesListLen;
  var blogListLen;
  var featuredList;
  var featuredListLen;

  MenuDataProvider menuDataProvider = MenuDataProvider();
  MovieTVProvider movieTvDataProvider = MovieTVProvider();
  @override
  void initState() {
    super.initState();

    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.2, end: 1.0).animate(animation);

    animation.forward();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      try {
        menuDataProvider =
            Provider.of<MenuDataProvider>(context, listen: false);
        await menuDataProvider.getMenusData(context, widget.menuId);

        movieTvDataProvider =
            Provider.of<MovieTVProvider>(context, listen: false);

        moviesList = menuDataProvider.menuCatMoviesList;
        tvSeriesList = menuDataProvider.menuCatTvSeriesList;
        liveDataList = menuDataProvider.liveDataList;
        menuDataList = menuDataProvider.menuDataList;
        topVideosList = movieTvDataProvider.topVideoList;
        blogList =
            Provider.of<AppConfig>(context, listen: false).appModel!.blogs;
        actorsList =
            Provider.of<MainProvider>(context, listen: false).actorList;
        moviesList.removeWhere((item) =>
            item.live == '1' || item.live == 1 || item.type != DatumType.M);
        tvSeriesList.removeWhere((item) =>
            item.live == '1' || item.live == 1 || item.type != DatumType.T);
        var newList = new List.from(moviesList)..addAll(tvSeriesList);
        featuredList = List.from(newList
            .where((item) => item.featured == "1" || item.featured == 1));
        upComingMovie = List.from(moviesList
            .where((item) => item.isUpcoming == "1" || item.isUpcoming == 1));
        actorsList = actorsList..shuffle();
        topVideosList = topVideosList..shuffle();
        blogList = blogList..shuffle();
        menuDataList = menuDataList..shuffle();
        moviesList = moviesList..shuffle();
        tvSeriesList = tvSeriesList..shuffle();
        featuredListLen = featuredList.length;
        actorsListLen = actorsList.length;
        topVideosListLen = topVideosList.length;
        liveDataListLen = liveDataList.length;
        moviesListLen = moviesList.length;
        tvSeriesListLen = tvSeriesList.length;
        blogListLen = blogList.length;
        upComingMovieLen = upComingMovie.length;

        if (mounted) {
          setState(() {
            _visible = true;
          });
        }
      } catch (err) {
        return null;
      }
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    getMenuData();
  }

  getMenuData() async {
    try {
      menuDataProvider = Provider.of<MenuDataProvider>(context, listen: false);
      await menuDataProvider.getMenusData(context, widget.menuId);

      movieTvDataProvider =
          Provider.of<MovieTVProvider>(context, listen: false);
      moviesList = menuDataProvider.menuCatMoviesList;

      liveDataList = menuDataProvider.liveDataList;
      menuDataList = menuDataProvider.menuDataList;
      topVideosList = movieTvDataProvider.topVideoList;
      blogList = Provider.of<AppConfig>(context, listen: false).appModel!.blogs;
      actorsList = Provider.of<MainProvider>(context, listen: false).actorList;
      var newList = new List.from(moviesList)..addAll(tvSeriesList);
      featuredList = List.from(
          newList.where((item) => item.featured == "1" || item.featured == 1));
      upComingMovie = List.from(moviesList
          .where((item) => item.isUpcoming == "1" || item.isUpcoming == 1));
      moviesList.removeWhere((item) =>
          item.live == '1' || item.live == 1 || item.type != DatumType.M);
      tvSeriesList = menuDataProvider.menuCatTvSeriesList;

      tvSeriesList.removeWhere((item) =>
          item.live == '1' || item.live == 1 || item.type != DatumType.T);
      print("dta count: ${liveDataList.length}");
      setState(() {
        actorsList = actorsList..shuffle();
        topVideosList = topVideosList..shuffle();
        blogList = blogList..shuffle();
        menuDataList = menuDataList..shuffle();
        moviesList = moviesList..shuffle();
        tvSeriesList = tvSeriesList..shuffle();
        featuredListLen = featuredList.length;
        actorsListLen = actorsList.length;
        topVideosListLen = topVideosList.length;
        liveDataListLen = liveDataList.length;
        moviesListLen = moviesList.length;
        tvSeriesListLen = tvSeriesList.length;
        blogListLen = blogList.length;
        upComingMovieLen = upComingMovie.length;
      });
    } catch (err) {
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: refreshList,
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).primaryColorLight,
        child: FadeTransition(
          opacity: _fadeInFadeOut,
          child: Container(
            child: _visible == false
                ? Center(
                    child: HomeScreenShimmer(
                      loading: true,
                    ),
                  )
                : menuDataList.length == 0
                    ? Center(
                        child: Text(
                          "No data available",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )
                    : Container(
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          // controller: controller,
                          child: Column(
                            key: _keyRed,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // ImageSlider(),
                              SizedBox(
                                height: 20.0,
                              ),
                              HorizontalGenreList(
                                loading: widget.loading,
                              ),

                              SizedBox(height: 15),
                              actorsListLen == 0
                                  ? SizedBox.shrink()
                                  : Heading1("Artist", "Actor", widget.loading),
                              actorsListLen == 0
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              actorsListLen == 0
                                  ? SizedBox.shrink()
                                  : ActorsHorizontalList(
                                      loading: widget.loading),
                              actorsListLen == 0
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              topVideosListLen == 0
                                  ? SizedBox.shrink()
                                  : Heading1("Top Movies & TV Series", "Top",
                                      widget.loading),
                              topVideosListLen == 0
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              topVideosListLen == 0
                                  ? SizedBox.shrink()
                                  : Container(
                                      height: 350,
                                      child: TopVideoList(
                                        loading: widget.loading,
                                      ),
                                    ),
                              liveDataListLen == 0
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              liveDataListLen == 0
                                  ? SizedBox.shrink()
                                  : Heading2("LIVE", "Live"),
                              liveDataListLen == 0
                                  ? SizedBox.shrink()
                                  : LiveVideoList(),
                              liveDataListLen == 0
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              featuredListLen == 0 || featuredList == null
                                  ? SizedBox.shrink()
                                  : Heading1("Featured", "F", widget.loading),
                              featuredListLen == 0 || featuredList == null
                                  ? SizedBox.shrink()
                                  : FeaturedList(menuByCat: featuredList),
                              tvSeriesListLen == 0
                                  ? SizedBox.shrink()
                                  : Heading1("TV Series", "TV", widget.loading),
                              tvSeriesListLen == 0
                                  ? SizedBox.shrink()
                                  : TvSeriesList(
                                      type: DatumType.T,
                                      loading: widget.loading,
                                      data: tvSeriesList),
                              tvSeriesListLen == 0
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              moviesListLen == 0
                                  ? SizedBox.shrink()
                                  : Heading1("Movies", "Mov", widget.loading),
                              moviesListLen == 0
                                  ? SizedBox.shrink()
                                  : MoviesList(
                                      type: DatumType.M,
                                      loading: widget.loading,
                                      data: moviesList),
                              moviesListLen == 0
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              upComingMovieLen == 0 || upComingMovieLen == null
                                  ? SizedBox.shrink()
                                  : Heading1(
                                      "Coming Soon", "U", widget.loading),
                              upComingMovieLen == 0 || upComingMovieLen == null
                                  ? SizedBox.shrink()
                                  : FeaturedList(menuByCat: upComingMovie),
                              blogListLen == 0
                                  ? SizedBox.shrink()
                                  : Heading1(
                                      "Our Blog Posts", "Blog", widget.loading),
                              blogListLen == 0
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              blogListLen == 0 ? SizedBox.shrink() : BlogView(),
                            ],
                          ),
                        ),
                      ),
          ),
        ));
  }

  @override
  void dispose() {
    animation.dispose();
    controller.dispose();
    super.dispose();
  }
}

void showDemoActionSheet(
    {required BuildContext context, required Widget child}) {
  showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child).then((String? value) {
    if (value != null) {
      print("language $value");

      MyApp.of(context)!.setLocale(Locale.fromSubtags(languageCode: value));
      Locale(value);
    }
  });
}

void _onActionSheetPress(BuildContext context) {
  showDemoActionSheet(
    context: context,
    child: CupertinoActionSheet(
      title: Text('language.selection.title'),
      message: Text('language.selection.message'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('language.name.en'),
          onPressed: () => Navigator.pop(context, 'en_US'),
        ),
        CupertinoActionSheetAction(
          child: Text('language.name.es'),
          onPressed: () => Navigator.pop(context, 'es'),
        ),
        CupertinoActionSheetAction(
          child: Text('language.name.fa'),
          onPressed: () => Navigator.pop(context, 'fa'),
        ),
        CupertinoActionSheetAction(
          child: Text('language.name.ar'),
          onPressed: () => Navigator.pop(context, 'ar'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('button.cancel'),
        isDefaultAction: true,
        onPressed: () => Navigator.pop(context, null),
      ),
    ),
  );
}
