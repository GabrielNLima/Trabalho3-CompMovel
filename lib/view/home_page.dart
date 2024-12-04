import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trab3/helpers/game_helper.dart';
import 'package:trab3/view/game_page.dart';
import 'package:trab3/helpers/game_helper.dart';
import 'package:trab3/view/game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameHelper helper = GameHelper();
  List<dynamic> games = [];

  @override
  void initState(){
    super.initState();
    getAllGames();
  }

  void getAllGames(){
    helper.getAllGames().then((list){
      setState((){
        games = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/jogo.png', 
              fit: BoxFit.contain, 
              height: 45,
              width: 45,
            ),
          ],
        ),
        centerTitle: true,
      ),
      // backgroundColor: const Color.fromARGB(255, 44, 18, 44),
      backgroundColor: Color.fromARGB(255, 112, 13, 129),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showGamePage();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: games.length,
        itemBuilder: (context, index){
          return gameCard(context, index);
        },
      ),
    );
  }

  Widget gameCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              // Container(
              //   width: 80.0,
              //   height: 80.0,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     image: DecorationImage(image: games[index].img != null ? FileImage(File(games[index].img)) : AssetImage("assets/imgs/avatar.png")),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${games[index].name}",
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 112, 13, 129))
                    ),
                    Text(
                      "Gênero: ${games[index].genre}" ?? "",
                      style: TextStyle(fontSize: 22.0)
                    ),
                    Text(
                      "Horas Jogadas: ${games[index].hours}" ?? "",
                      style: TextStyle(fontSize: 22.0)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        // ShowOptions(context, index);
      }
    );
  }

  void showGamePage({Game? game}) async{
    final recGame = await Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(game: game)));
    if(recGame != null){
      if(game != null){
        await helper.updateGame(recGame);
      }else{
        await helper.saveGame(recGame);
      }
      getAllGames();
      getAllGames();
    }
  }

}