import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/common/global.dart';
import '/common/route_paths.dart';
import '/common/shimmer-effect.dart';
import '/models/comment.dart';
import '/models/datum.dart';
import '/models/episode.dart';
import '/models/genre_model.dart';
import '/models/seasons.dart';
import '/providers/main_data_provider.dart';
import '/providers/movie_tv_provider.dart';
import '/ui/screens/video_grid_screen.dart';
import 'package:provider/provider.dart';

class HorizontalGenreList extends StatefulWidget {
  HorizontalGenreList({this.loading});
  final loading;
  @override
  _HorizontalGenreListState createState() => _HorizontalGenreListState();
}

class _HorizontalGenreListState extends State<HorizontalGenreList> {
  MainProvider genresProvider = MainProvider();
  var genres;
  List<Datum> genreDataList = [];

  @override
  void initState() {
    super.initState();
    genres = [];
    genresProvider = Provider.of<MainProvider>(context, listen: false);
    genres = shuffle(genresProvider.genreList);
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  getGenreData(id, movieTvList, genreList) {
    var genreList = Provider.of<MainProvider>(context, listen: false).genreList;
    var actorList = Provider.of<MainProvider>(context, listen: false).actorList;
    var directorList =
        Provider.of<MainProvider>(context, listen: false).directorList;
    var audioList = Provider.of<MainProvider>(context, listen: false).audioList;
    genreDataList = [];
    for (int p = 0; p < movieTvList.length; p++) {
      for (int s = 0; s < movieTvList[p].genre.length; s++) {
        if ("${movieTvList[p].genre[s]}" == "$id") {
          var genreData = movieTvList[p].genreId == null
              ? null
              : movieTvList[p].genreId.split(",").toList();
          var actors = movieTvList[p].actorId == null
              ? null
              : movieTvList[p].actorId.split(",").toList();
          var audios = movieTvList[p].aLanguage == null
              ? null
              : movieTvList[p].aLanguage.split(",").toList();
          var directors = movieTvList[p].directorId == null
              ? null
              : movieTvList[p].directorId.split(",").toList();
          genreDataList.add(Datum(
            id: movieTvList[p].id,
            actorId: movieTvList[p].actorId,
            title: movieTvList[p].title,
            trailerUrl: movieTvList[p].trailerUrl,
            status: movieTvList[p].status,
            keyword: movieTvList[p].keyword,
            description: movieTvList[p].description,
            duration: movieTvList[p].duration,
            thumbnail: movieTvList[p].thumbnail,
            poster: movieTvList[p].poster,
            directorId: movieTvList[p].directorId,
            detail: movieTvList[p].detail,
            rating: movieTvList[p].rating,
            maturityRating: movieTvList[p].maturityRating,
            publishYear: movieTvList[p].publishYear,
            released: movieTvList[p].released,
            uploadVideo: movieTvList[p].uploadVideo,
            featured: movieTvList[p].featured,
            series: movieTvList[p].series,
            aLanguage: movieTvList[p].aLanguage,
            live: movieTvList[p].live,
            createdBy: movieTvList[p].createdBy,
            createdAt: movieTvList[p].createdAt,
            updatedAt: movieTvList[p].updatedAt,
            isUpcoming: movieTvList[p].isUpcoming,
            userRating: movieTvList[p].userRating,
            movieSeries: movieTvList[p].movieSeries,
            videoLink: movieTvList[p].videoLink,
            genre: List.generate(genreData == null ? 0 : genreData.length,
                (int genreIndex) {
              return "${genreData[genreIndex]}";
            }),
            genres: List.generate(genreList.length, (int gIndex) {
              var genreId2 = genreList[gIndex].id.toString();
              var genreNameList = List.generate(
                  genreData == null ? 0 : genreData.length, (int nameIndex) {
                return "${genreData[nameIndex]}";
              });
              var isAv2 = 0;
              for (var y in genreNameList) {
                if (genreId2 == y) {
                  isAv2 = 1;
                  break;
                }
              }
              if (isAv2 == 1) {
                if (genreList[gIndex].name == null) {
                  return null;
                } else {
                  return "${genreList[gIndex].name}";
                }
              }
              return null;
            }),
            comments: List.generate(
                movieTvList[p].comments == null
                    ? 0
                    : movieTvList[p].comments.length, (cIndex) {
              return Comment(
                id: movieTvList[p].comments[cIndex].id,
                name: movieTvList[p].comments[cIndex].name,
                email: movieTvList[p].comments[cIndex].email,
                movieId: movieTvList[p].comments[cIndex].movieId,
                tvSeriesId: movieTvList[p].comments[cIndex].tvSeriesId,
                comment: movieTvList[p].comments[cIndex].comment,
                createdAt: movieTvList[p].comments[cIndex].createdAt,
                updatedAt: movieTvList[p].comments[cIndex].updatedAt,
              );
            }),
            actor:
                List.generate(actors == null ? 0 : actors.length, (int aIndex) {
              return "${actors[aIndex]}";
            }),
            actors: List.generate(actorList.length, (actIndex) {
              var actorsId = actorList[actIndex].id.toString();
              var actorsIdList = List.generate(
                  actors == null ? 0 : actors.length, (int idIndex) {
                return "${actors[idIndex]}";
              });
              var isAv2 = 0;
              for (var y in actorsIdList) {
                if (actorsId == y) {
                  isAv2 = 1;
                  break;
                }
              }
              if (isAv2 == 1) {
                if (actorList[actIndex].name == null) {
                  return null;
                } else {
                  return Actor(
                    id: actorList[actIndex].id,
                    name: actorList[actIndex].name,
                    image: actorList[actIndex].image,
                    biography: actorList[actIndex].biography,
                    placeOfBirth: actorList[actIndex].placeOfBirth,
                    dob: actorList[actIndex].dob,
                    createdAt: actorList[actIndex].createdAt,
                    updatedAt: actorList[actIndex].updatedAt,
                  );
                }
              }
              return null;
            }),
            directors: List.generate(directorList.length, (actIndex) {
              var directorsId = directorList[actIndex].id.toString();
              var actorsIdList = List.generate(
                  directors == null ? 0 : directors.length, (int idIndex) {
                return "${directors[idIndex]}";
              });
              var isAv2 = 0;
              for (var y in actorsIdList) {
                if (directorsId == y) {
                  isAv2 = 1;
                  break;
                }
              }
              if (isAv2 == 1) {
                if (directorList[actIndex].name == null) {
                  return null;
                } else {
                  return Director(
                    id: directorList[actIndex].id,
                    name: directorList[actIndex].name,
                    image: directorList[actIndex].image,
                    biography: directorList[actIndex].biography,
                    placeOfBirth: directorList[actIndex].placeOfBirth,
                    dob: directorList[actIndex].dob,
                    createdAt: directorList[actIndex].createdAt,
                    updatedAt: directorList[actIndex].updatedAt,
                  );
                }
              }
              return null;
            }),
            audios: List.generate(audioList.length, (actIndex) {
              var actorsId = audioList[actIndex].id.toString();
              var audioIdList = List.generate(
                  audios == null ? 0 : audios.length, (int idIndex) {
                return "${audios[idIndex]}";
              });
              var isAv2 = 0;
              for (var y in audioIdList) {
                if (actorsId == y) {
                  isAv2 = 1;
                  break;
                }
              }
              if (isAv2 == 1) {
                if (audioList[actIndex].language == null) {
                  return null;
                } else {
                  return "${audioList[actIndex].language}";
                }
              }
              return null;
            }),
            episodeRuntime: movieTvList[p].episodeRuntime,
            genreId: movieTvList[p].genreId,
            type: movieTvList[p].type,
            seasons: List.generate(
                movieTvList[p].seasons == null
                    ? 0
                    : movieTvList[p].seasons.length, (sIndex) {
              var seasonActors = movieTvList[p].seasons[sIndex].actorId == "" ||
                      movieTvList[p].seasons[sIndex].actorId == null
                  ? null
                  : movieTvList[p].seasons[sIndex].actorId.split(",").toList();
              var audioLang = movieTvList[p].seasons[sIndex].aLanguage == "" ||
                      movieTvList[p].seasons[sIndex].aLanguage == null
                  ? null
                  : movieTvList[p]
                      .seasons[sIndex]
                      .aLanguage
                      .split(",")
                      .toList();
              return Season(
                id: movieTvList[p].seasons[sIndex].id,
                thumbnail: movieTvList[p].seasons[sIndex].thumbnail,
                poster: movieTvList[p].seasons[sIndex].poster,
                seasonNo: movieTvList[p].seasons[sIndex].seasonNo,
                tvSeriesId: movieTvList[p].seasons[sIndex].tvSeriesId,
                publishYear: movieTvList[p].seasons[sIndex].publishYear,
                episodes: List.generate(
                    movieTvList[p].seasons[sIndex].episodes == null
                        ? 0
                        : movieTvList[p].seasons[sIndex].episodes.length,
                    (eIndex) {
                  return Episode(
                    id: movieTvList[p].seasons[sIndex].episodes[eIndex].id,
                    thumbnail: movieTvList[p]
                        .seasons[sIndex]
                        .episodes[eIndex]
                        .thumbnail,
                    title:
                        movieTvList[p].seasons[sIndex].episodes[eIndex].title,
                    detail:
                        movieTvList[p].seasons[sIndex].episodes[eIndex].detail,
                    duration: movieTvList[p]
                        .seasons[sIndex]
                        .episodes[eIndex]
                        .duration,
                    createdAt: movieTvList[p]
                        .seasons[sIndex]
                        .episodes[eIndex]
                        .createdAt,
                    updatedAt: movieTvList[p]
                        .seasons[sIndex]
                        .episodes[eIndex]
                        .updatedAt,
                    episodeNo: movieTvList[p]
                        .seasons[sIndex]
                        .episodes[eIndex]
                        .episodeNo,
                    aLanguage: movieTvList[p]
                        .seasons[sIndex]
                        .episodes[eIndex]
                        .aLanguage,
                    released: movieTvList[p]
                        .seasons[sIndex]
                        .episodes[eIndex]
                        .released,
                    seasonsId: movieTvList[p]
                        .seasons[sIndex]
                        .episodes[eIndex]
                        .seasonsId,
                    videoLink: movieTvList[p]
                        .seasons[sIndex]
                        .episodes[eIndex]
                        .videoLink,
                  );
                }),
                actorId: movieTvList[p].seasons[sIndex].actorId,
                actorList: List.generate(actorList.length, (actIndex) {
                  var actorsId = actorList[actIndex].id.toString();
                  var actorsIdList = List.generate(
                      seasonActors == null ? 0 : seasonActors.length,
                      (int idIndex) {
                    return "${seasonActors[idIndex]}";
                  });
                  var isAv2 = 0;
                  for (var y in actorsIdList) {
                    if (actorsId == y) {
                      isAv2 = 1;
                      break;
                    }
                  }
                  if (isAv2 == 1) {
                    if (actorList[actIndex].name == null) {
                      return null;
                    } else {
                      return Actor(
                        id: actorList[actIndex].id,
                        name: actorList[actIndex].name,
                        image: actorList[actIndex].image,
                        biography: actorList[actIndex].biography,
                        placeOfBirth: actorList[actIndex].placeOfBirth,
                        dob: actorList[actIndex].dob,
                        createdAt: actorList[actIndex].createdAt,
                        updatedAt: actorList[actIndex].updatedAt,
                      );
                    }
                  }
                  return null;
                }),
                audiosList: List.generate(audioList.length, (actIndex) {
                  var actorsId = audioList[actIndex].id.toString();
                  var audioIdList = List.generate(
                      audioLang == null ? 0 : audioLang.length, (int idIndex) {
                    return "${audioLang[idIndex]}";
                  });
                  var isAv2 = 0;
                  for (var y in audioIdList) {
                    if (actorsId == y) {
                      isAv2 = 1;
                      break;
                    }
                  }
                  if (isAv2 == 1) {
                    return "${audioList[actIndex].language}";
                  }
                  return null;
                }),
                aLanguage: movieTvList[p].seasons[sIndex].aLanguage,
                createdAt: movieTvList[p].seasons[sIndex].createdAt,
                updatedAt: movieTvList[p].seasons[sIndex].updatedAt,
                featured: movieTvList[p].seasons[sIndex].featured,
                tmdb: movieTvList[p].seasons[sIndex].tmdb,
                tmdbId: movieTvList[p].seasons[sIndex].tmdbId,
                subtitle: movieTvList[p].seasons[sIndex].subtitle,
                subtitleList: movieTvList[p].seasons[sIndex].subtitleList,
              );
            }),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // genres = Provider.of<MainProvider>(context, listen: false).genreList;

    var movieTvList = Provider.of<MovieTVProvider>(context).movieTvList;
    return widget.loading == true
        ? Container(
            height: Constants.genreListHeight,
            child: ListView.builder(
                padding: EdgeInsets.only(left: 15.0, right: 5.0),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin:
                        EdgeInsets.only(right: Constants.genreItemRightMargin),
                    width: Constants.genreItemWidth,
                    height: Constants.genreItemHeight,
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(5.0),
                        child: Image.asset(
                          "assets/placeholder_cover.jpg",
                          height: Constants.genreListHeight,
                          // width: 120.0,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  );
                }),
          )
        : Container(
            height: Constants.genreListHeight,
            child: ListView.builder(
                padding: EdgeInsets.only(left: 15.0, right: 5.0),
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin:
                        EdgeInsets.only(right: Constants.genreItemRightMargin),
                    width: Constants.genreItemWidth,
                    height: Constants.genreItemHeight,
                    child: Material(
                      shadowColor: Colors.black,
                      child: InkWell(
                        onTap: () {
                          getGenreData(genres[index].id, movieTvList, genres);
                          Navigator.pushNamed(context, RoutePaths.genreVideos,
                              arguments: VideoGridScreen(genres[index].id,
                                  genres[index].name, genreDataList));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "${genres[index].name}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16.0),
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: Constants.gradientColors[Random()
                              .nextInt(Constants.gradientColors.length)],
                        )),
                  );
                }),
          );
  }
}
