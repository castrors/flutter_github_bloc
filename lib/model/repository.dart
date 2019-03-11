import 'package:equatable/equatable.dart';

class Repository extends Equatable {
  final String name;
  final String description;
  final int forksCount;
  final int stargazersCount;
  final String ownerAvatar;
  final String ownerLogin;

  Repository(
      {this.name,
      this.description,
      this.forksCount,
      this.stargazersCount,
      this.ownerAvatar,
      this.ownerLogin})
      : super([
          name,
          description,
          forksCount,
          stargazersCount,
          ownerAvatar,
          ownerLogin
        ]);

  static Repository fromJson(dynamic json) {
    return Repository(
        name: json['name'],
        description: json['description'],
        forksCount: json['forks_count'],
        stargazersCount: json['stargazers_count'],
        ownerAvatar: json['owner']['avatar_url'],
        ownerLogin: json['owner']['login']);
  }

  String toString() => 'Repository: $name';
}
