import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/shared/const/const.dart';
import 'package:movie/shared/core/enum.dart';
import 'package:movie/tv/presentation/manager/tv_manager_bloc.dart';
import 'package:movie/tv/presentation/manager/tv_manager_state.dart';
import 'package:movie/tv/presentation/pages/tv_details_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../shared/utiles/services_local.dart';

class SeeMorePopularTvScreen extends StatelessWidget {
  const SeeMorePopularTvScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.transparent.withOpacity(.1),
          title: const Text(
            "Popular Movies",
            style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: BlocProvider(
          create: (BuildContext context) => sl<TvManagerBloc>(),
          child: BlocBuilder<TvManagerBloc, TvManagerState>(
            buildWhen: (previous, current) =>
                previous.getPopularState != current.getPopularState,
            builder: (context, state) {
              switch (state.getPopularState) {
                case RequestStates.loading:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.lime,
                    ),
                  );
                case RequestStates.loaded:
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(5),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final movie = state.getPopularTv[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TvDetailScreen(
                                        id: movie.id,
                                      )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(5),
                          height: 140,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  clipBehavior:
                                      Clip.antiAliasWithSaveLayer,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  child: CachedNetworkImage(
                                    height: 120,
                                    fit: BoxFit.cover,
                                    imageUrl: AppLinks.imageUrl(
                                        movie.backdropPath!),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[850]!,
                                      highlightColor:
                                          Colors.grey[800]!,
                                      child: Container(
                                        height: 120.0,
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10.0),
                                        ),
                                      ),
                                    ),
                                    errorWidget:
                                        (context, url, error) =>
                                            const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      movie.name,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    5),
                                            color: Colors.red,
                                          ),
                                          child: Text(
                                              movie.dateTime.year
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      Colors.white)),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Icon(
                                          Icons.star_outlined,
                                          color: Colors.yellowAccent,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${movie.voteAverage}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      movie.overview,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          fontWeight:
                                              FontWeight.w500),
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: state.getPopularTv.length,
                  );
                case RequestStates.error:
                  return Center(
                    child: Text(state.getNowPlayingMessage),
                  );
              }
            },
          ),
        ));
  }
}
