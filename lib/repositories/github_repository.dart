import 'package:flutter_github_bloc/model/repository.dart';
import 'package:flutter_github_bloc/repositories/github_api_client.dart';
import 'package:meta/meta.dart';

class GithubRepository {
  final GithubApiClient githubApiClient;

  GithubRepository({@required this.githubApiClient}) : assert(githubApiClient != null);

  Future<List<Repository>> getRepositories() async {
    return await githubApiClient.getRepositories();
  }
}