import 'package:flutter/material.dart';
import 'package:flutter_github_bloc/model/repository.dart';

class RepositoryWidget extends StatelessWidget {
  RepositoryWidget(this.repository);

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(repository.name),
        subtitle: new Column(children: <Widget>[
          new Text(repository.description),
          new Row(
            children: <Widget>[
              new Icon(
                Icons.content_copy,
                color: Colors.yellow[700],
              ),
              new Text(repository.forksCount.toString(),
                  style: new TextStyle(color: Colors.yellow[700])),
              new Icon(
                Icons.star,
                color: Colors.yellow[700],
              ),
              new Text(repository.stargazersCount.toString(),
                  style: new TextStyle(color: Colors.yellow[700])),
            ],
          ),
        ]),
        trailing: new Column(children: <Widget>[
          new CircleAvatar(
            backgroundColor: Colors.white,
            child: new Image.network(repository.ownerAvatar,
                fit: BoxFit.cover, width: 64.0, height: 64.0),
          ),
          new Text(repository.ownerLogin)
        ]),
        isThreeLine: true
      );
  }
}