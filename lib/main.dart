import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_bloc/bloc/blocs.dart';
import 'package:flutter_github_bloc/repositories/github_api_client.dart';
import 'package:flutter_github_bloc/repositories/github_repository.dart';
import 'package:flutter_github_bloc/widgets/repository_widget.dart';
import 'package:http/http.dart' as http;

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();

  final GithubRepository githubRepository = GithubRepository(
      githubApiClient: GithubApiClient(httpClient: http.Client()));

  runApp(App(githubRepository: githubRepository));
}

class App extends StatelessWidget {
  final GithubRepository githubRepository;

  App({Key key, @required this.githubRepository})
      : assert(githubRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github Repositories',
      home: RepositoriesList(
        githubRepository: githubRepository,
      ),
    );
  }
}

class RepositoriesList extends StatefulWidget {
  final GithubRepository githubRepository;

  RepositoriesList({Key key, @required this.githubRepository})
      : assert(githubRepository != null),
        super(key: key);

  @override
  State<RepositoriesList> createState() => _RepositoriesListState();
}

class _RepositoriesListState extends State<RepositoriesList> {
  RepositoriesBloc _repositoriesBloc;

  @override
  void initState() {
    super.initState();
    _repositoriesBloc =
        RepositoriesBloc(githubRepository: widget.githubRepository);
    _repositoriesBloc.dispatch(FetchRepositories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Github Repositories'),
      ),
      body: Center(
        child: BlocBuilder(
            bloc: _repositoriesBloc,
            builder: (_, RepositoriesState state) {
              if (state is RepositoriesEmpty) {
                return Center(
                    child: Text('There is no repository to show. :('));
              }
              if (state is RepositoriesLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is RepositoriesLoaded) {
                final repositories = state.repositories;

                return ListView.builder(
                  itemCount: repositories.length,
                  itemBuilder: (context, index) =>
                      RepositoryWidget(repositories[index]),
                );
              }
              if (state is RepositoriesError) {
                return Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                );
              }
            }),
      ),
    );
  }

  @override
  void dispose() {
    _repositoriesBloc.dispose();
    super.dispose();
  }
}
