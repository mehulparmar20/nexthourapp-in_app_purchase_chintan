import 'package:flutter/material.dart';
import '/models/episode.dart';
import '/ui/shared/actors_horizontal_list.dart';
import '/ui/shared/heading1.dart';
import '/ui/screens/horizental_genre_list.dart';
import '/ui/screens/horizontal_movies_list.dart';
import '/ui/screens/horizontal_tvseries_list.dart';
import '/ui/screens/top_video_list.dart';

class HomeScreenShimmer extends StatefulWidget {
  HomeScreenShimmer({Key? key, this.loading}) : super(key: key);
  final loading;

  @override
  _HomeScreenShimmerState createState() => _HomeScreenShimmerState();
}

class _HomeScreenShimmerState extends State<HomeScreenShimmer>
    with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  // late AnimationController animation2;
  // late Animation<double> _fadeInFadeOut2;
  // late AnimationController animation3;
  // late Animation<double> _fadeInFadeOut3;

  ScrollController controller = ScrollController(initialScrollOffset: 0.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.2, end: 0.8).animate(animation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation.forward();
      }
    });
    animation.forward();
    // animation2 = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 1500),
    // );
    // _fadeInFadeOut2 = Tween<double>(begin: 0.2, end: 0.8).animate(animation2);

    // animation3 = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 1500),
    // );
    // _fadeInFadeOut3 = Tween<double>(begin: 0.2, end: 0.8).animate(animation3);

    // Future.delayed(Duration(milliseconds: 100), () {
    //   animation2.addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       animation2.reverse();
    //     } else if (status == AnimationStatus.dismissed) {
    //       animation2.forward();
    //     }
    //   });
    //   animation2.forward();
    // });

    // Future.delayed(Duration(milliseconds: 200), () {
    //   animation3.addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       animation3.reverse();
    //     } else if (status == AnimationStatus.dismissed) {
    //       animation3.forward();
    //     }
    //   });
    //   animation3.forward();
    // });

    // controller = ScrollController(initialScrollOffset: 50.0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        // controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ImageSlider(),
            SizedBox(
              height: 20.0,
            ),
            FadeTransition(
              opacity: _fadeInFadeOut,
              child: HorizontalGenreList(
                loading: widget.loading,
              ),
            ),
            // HorizontalGenreList(
            //   loading: widget.loading,
            // ),
            SizedBox(
              height: 15.0,
            ),
            Heading1("Artist", "Actor", widget.loading),

            SizedBox(
              height: 15.0,
            ),
            FadeTransition(
              opacity: _fadeInFadeOut,
              child: ActorsHorizontalList(loading: widget.loading),
            ),
            // ActorsHorizontalList(loading: widget.loading),
            SizedBox(
              height: 15.0,
            ),

            Heading1("Top Movies & TV Series", "Top", widget.loading),
            SizedBox(
              height: 15.0,
            ),
            FadeTransition(
              opacity: _fadeInFadeOut,
              child: Container(
                height: 350,
                child: TopVideoList(
                  loading: widget.loading,
                ),
              ),
            ),

            Heading1("TV Series", "TV", widget.loading),
            FadeTransition(
              opacity: _fadeInFadeOut,
              child: TvSeriesList(
                type: DatumType.T,
                loading: widget.loading,
                data: [],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Heading1("Movies", "Mov", widget.loading),
            FadeTransition(
              opacity: _fadeInFadeOut,
              child: MoviesList(
                type: DatumType.M,
                loading: widget.loading,
                data: [],
              ),
            ),
            // MoviesList(type: DatumType.M, loading: widget.loading, data: []),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    animation.dispose();
    // animation2.dispose();
    // animation3.dispose();

    super.dispose();
  }
}
