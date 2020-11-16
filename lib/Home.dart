import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com";
  Future<List<Post>> _repuperarPostagens() async {
    http.Response response = await http.get(_urlBase + "/posts");
    var dadosJson = json.decode(response.body);
    List<Post> postagens = List();
    for (var post in dadosJson) {
    //  print("post:" + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }
    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Itens"),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Post>>(
        future: _repuperarPostagens(),
        // ignore: missing_return
        builder: (context, snapshot) {
           switch (snapshot.connectionState) {
            case ConnectionState.none:
              print("conexão none");
              break;
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
              print("conexão active");
              break;
            case ConnectionState.done:
              print("conexão done");
              if (snapshot.hasError) {
                print( "Erro ao carregar dados");
              } else {
                print("lista: Carregou!");
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List<Post> lista = snapshot.data;
                    Post post = lista[index];
                    return ListTile(
                      title: Text(post.id.toString()),
                      subtitle: Text(post.title),
                    );
                  },
                );
              }
              break;
          }
        },
      ),
    );
  }
}
