import 'package:dartz/dartz.dart';
import 'package:repo_viewer/core/domain/fresh.dart';
import 'package:repo_viewer/core/infrastructure/network_exceptions.dart';
import 'package:repo_viewer/github/core/domain/github_failure.dart';
import 'package:repo_viewer/github/core/domain/github_repo.dart';
import 'package:repo_viewer/github/core/infrastructure/github_repo_dto.dart';
import 'package:repo_viewer/github/repos/starred_repos/infrastructure/starred_repos_remote_service.dart';

class StarredReposRepository {
  final StarredReposRemoteService _remoteService;

  StarredReposRepository(this._remoteService);

  Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> getStarredReposPage(
    int page,
  ) async {
    try {
      final remotePageItems = await _remoteService.getStarredReposPage(page);
      return right(
        remotePageItems.when(
          noConnection: (maxPage) => Fresh.no(
            [],
            isNextPageAvailable: maxPage > page,
          ),
          notModified: (maxPage) => Fresh.yes(
            [],
            isNextPageAvailable: maxPage > page,
          ),
          withNewData: (data, maxPage) => Fresh.yes(
            data.toDomain(),
            isNextPageAvailable: maxPage > page,
          ),
        ),
      );
    } on RestApiException catch (e) {
      return Left(GithubFailure.api(e.errorCode));
    }
  }
}

extension DTOListToDomainList on List<GithubRepoDTO> {
  List<GithubRepo> toDomain() => map((e) => e.toDomain()).toList();
}
