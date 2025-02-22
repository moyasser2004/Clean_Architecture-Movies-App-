import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/shared/core/enum.dart';
import 'package:movie/tv/presentation/manager/tv_manager_state.dart';

import '../../../shared/const/const.dart';
import '../manager/tv_manager_bloc.dart';
import '../pages/tv_details_screen.dart';

class PlayNowTvComponent extends StatelessWidget {
  const PlayNowTvComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvManagerBloc, TvManagerState>(
      buildWhen: (previous, current) =>
          previous.getNowPlayingState != current.getNowPlayingState,
      builder: (context, state) {
        switch (state.getNowPlayingState) {
          case RequestStates.loading:
            return const SizedBox(
              height: 370,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.lime,
                ),
              ),
            );
          case RequestStates.loaded:
            return FadeIn(
              duration: const Duration(milliseconds: 500),
              child: CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration:
                      const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 1.0,
                  height: 370,
                ),
                items: state.getNowPlayingTv.map(
                  (item) {
                    return GestureDetector(
                      key: const Key('openMovieMinimalDetail'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TvDetailScreen(
                                  id: item.id,
                                )));
                      },
                      child: Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black,
                                  Colors.black,
                                  Colors.transparent,
                                ],
                                stops: [0, 0.3, 0.5, 1],
                              ).createShader(
                                Rect.fromLTRB(
                                    0, 0, rect.width, rect.height),
                              );
                            },
                            blendMode: BlendMode.dstIn,
                            child: CachedNetworkImage(
                              height: 370.0,
                              imageUrl: AppLinks.imageUrl(
                                  item.backdropPath!),
                              fit: BoxFit.fill,
                              errorWidget:
                                  (context, imageUrl, error) =>
                                      const Center(
                                child: Icon(
                                  Icons.error,
                                  size: 60,
                                  color: Colors.lime,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 14.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: Colors.redAccent,
                                        size: 14.0,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        'Now Playing '.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors
                                              .amberAccent.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0),
                                  child: Text(
                                    item.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            );
          case RequestStates.error:
            return SizedBox(
              height: 400,
              child: Center(
                child: Text(state.getNowPlayingMessage),
              ),
            );
        }
      },
    );
  }
}
