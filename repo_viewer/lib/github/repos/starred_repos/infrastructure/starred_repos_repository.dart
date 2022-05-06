import 'package:dartz/dartz.dart';
import 'package:repo_viewer/core/domain/fresh.dart';
import 'package:repo_viewer/core/infrastructure/network_exceptions.dart';
import 'package:repo_viewer/github/core/domain/github_failure.dart';
import 'package:repo_viewer/github/core/domain/github_repo.dart';
import 'package:repo_viewer/github/core/infrastructure/github_repo_dto.dart';
import 'package:repo_viewer/github/repos/starred_repos/infrastructure/starred_repos_local_service.dart';
import 'package:repo_viewer/github/repos/starred_repos/infrastructure/starred_repos_remote_service.dart';

class StarredReposRepository {
  final StarredReposRemoteService _remoteService;
  final StarredReposLocalService _localService;

  StarredReposRepository(this._remoteService, this._localService);

  Future<Either<GithubFailure, Fresh<List<GithubRepo>>>> getStarredReposPage(
    int page,
  ) async {
    try {
      final remotePageItems = await _remoteService.getStarredReposPage(page);
      return right(
        await remotePageItems.when(
            noConnection: (maxPage) async => Fresh.no(
                  await _localService.getPage(page).then((_) => _.toDomain()),
                  isNextPageAvailable: maxPage > page,
                ),
            notModified: (maxPage) async => Fresh.yes(
                  await _localService.getPage(page).then((_) => _.toDomain()),
                  isNextPageAvailable: maxPage > page,
                ),
            withNewData: (data, maxPage) async {
              await _localService.upsertPage(data, page);
              return Fresh.yes(
                data.toDomain(),
                isNextPageAvailable: maxPage > page,
              );
            }),
      );
    } on RestApiException catch (e) {
      return Left(GithubFailure.api(e.errorCode));
    }
  }
}

extension DTOListToDomainList on List<GithubRepoDTO> {
  List<GithubRepo> toDomain() => map((e) => e.toDomain()).toList();
}
