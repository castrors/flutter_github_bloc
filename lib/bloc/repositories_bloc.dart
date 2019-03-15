import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_github_bloc/model/repository.dart';
import 'package:flutter_github_bloc/repositories/github_repository.dart';
import 'package:meta/meta.dart';
import './blocs.dart';

class RepositoriesBloc extends Bloc<RepositoriesEvent, RepositoriesState> {
  final GithubRepository githubRepository;

  RepositoriesBloc({@required this.githubRepository})
      : assert(githubRepository != null);

  @override
  RepositoriesState get initialState => RepositoriesEmpty();

  @override
  Stream<RepositoriesState> mapEventToState(
    RepositoriesState currentState,
    RepositoriesEvent event,
  ) async* {
    if (event is FetchRepositories && !_hasReachedMax(currentState)) {
      try {
        if (currentState is RepositoriesEmpty) {
          final repositories = await githubRepository.getRepositories();
          yield RepositoriesLoaded(
              repositories: repositories, hasReachedMax: false);
        }
        if (currentState is RepositoriesLoaded) {
          final repositories = await githubRepository.getRepositories();
          yield repositories.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : RepositoriesLoaded(
                  repositories: currentState.repositories + repositories,
                  hasReachedMax: false);
        }
      } catch (_) {
        yield RepositoriesError();
      }
    }
  }

  bool _hasReachedMax(RepositoriesState state) =>
      state is RepositoriesLoaded && state.hasReachedMax;
}
