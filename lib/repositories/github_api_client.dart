import 'dart:convert';

import 'package:flutter_github_bloc/model/repository.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class GithubApiClient {
  static const baseUrl = 'https://api.github.com/search/repositories?q=language:Java&sort=stars';
  final http.Client httpClient;

  GithubApiClient({@required this.httpClient}) :assert(httpClient !=null);

  Future<List<Repository>> getRepositories () async {
    final repositoriesResponse =await this.httpClient.get(baseUrl);

    if(repositoriesResponse.statusCode != 200){
      throw Exception('error getting repositories');
    }

    final data = json.decode(repositoriesResponse.body)['items'] as List;
    return data.map((rawRepository) => Repository.fromJson(rawRepository)).toList();
  }
}