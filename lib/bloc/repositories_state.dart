import 'package:equatable/equatable.dart';
import 'package:flutter_github_bloc/model/repository.dart';

abstract class RepositoriesState extends Equatable {
  RepositoriesState([List props = const []]) : super(props);
}

class RepositoriesEmpty extends RepositoriesState {}

class RepositoriesLoading extends RepositoriesState {}

class RepositoriesLoaded extends RepositoriesState {
  final List<Repository> repositories;
  final bool hasReachedMax;

  RepositoriesLoaded({this.repositories, this.hasReachedMax})
      : super([repositories, hasReachedMax]);

  RepositoriesLoaded copyWith({
    List<Repository> repositories,
    bool hasReachedMax,
  }) {
    return RepositoriesLoaded(
      repositories: repositories ?? this.repositories,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'RepositoriesLoaded { repositories: ${repositories.length}, hasReachedMax: $hasReachedMax }';
}

class RepositoriesError extends RepositoriesState {}
