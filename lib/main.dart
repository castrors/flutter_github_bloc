import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_bloc/bloc/blocs.dart';
import 'package:flutter_github_bloc/repositories/github_api_client.dart';
import 'package:flutter_github_bloc/repositories/github_repository.dart';
import 'package:flutter_github_bloc/widgets/bottom_loader.dart';
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
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github Repositories',
      home: RepositoriesList(),
    );
  }
}

class RepositoriesList extends StatefulWidget {

  @override
  State<RepositoriesList> createState() => _RepositoriesListState();
}

class _RepositoriesListState extends State<RepositoriesList> {
  
  final RepositoriesBloc _repositoriesBloc = RepositoriesBloc(githubRepository: GithubRepository(
      githubApiClient: GithubApiClient(httpClient: http.Client())));
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  _RepositoriesListState() {
    _scrollController.addListener(_onScroll);
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
                return Center(child: CircularProgressIndicator());
              }
              if (state is RepositoriesError) {
                return Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                );
              }
              if (state is RepositoriesLoaded) {
                if (state.repositories.isEmpty) {
                  return Center(
                    child: Text('no post'),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return index >= state.repositories.length
                        ? BottomLoader()
                        : RepositoryWidget(state.repositories[index]);
                  },
                  itemCount: state.hasReachedMax
                      ? state.repositories.length
                      : state.repositories.length + 1,
                  controller: _scrollController,
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

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _repositoriesBloc.dispatch(FetchRepositories());
    }
  }
}
