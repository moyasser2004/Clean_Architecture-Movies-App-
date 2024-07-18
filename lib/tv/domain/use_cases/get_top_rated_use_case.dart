import 'package:dartz/dartz.dart';
import 'package:movie/tv/domain/repositories/base_repositories.dart';

import '../../../shared/core/failure.dart';
import '../../data/models/tv_model.dart';


class GetTopRatedUseCase {

  final BaseTvRepository baseTvRepository;

  GetTopRatedUseCase(this.baseTvRepository);

  Future<Either<Failure,List<TvModel>>> execute() async {
    return await baseTvRepository.getTopRatedTv();
  }

}
