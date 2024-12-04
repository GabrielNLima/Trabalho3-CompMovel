import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trab3/components/my_textfield.dart';
import 'package:trab3/helpers/game_helper.dart';

class GamePage extends StatefulWidget {
  const GamePage({this.game});

  final Game? game;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Game? _editedGame;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _genrelController = TextEditingController();
  final _hoursController = TextEditingController();
  final _nameFocus = FocusNode();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.game == null){
      _editedGame = Game();
    }else{
      _editedGame = Game.fromMap(widget.game!.toMap());
      _nameController.text = _editedGame!.name!;
      _genrelController.text = _editedGame!.genre!;
      _hoursController.text = _editedGame!.hours!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: requestPop,
    child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 112, 13, 129),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_editedGame!.name ?? "Novo Jogo"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_editedGame!.name != null && _editedGame!.name!.isNotEmpty){
            Navigator.pop(context, _editedGame);
          }else{
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: const Icon(Icons.save),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            // GestureDetector(
            //   child: Container(
            //     width: 140.0,
            //     height: 140.0,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       image: DecorationImage(image: _editedGame!.img != null ? FileImage(File(_editedGame!.img!)) : AssetImage("assets/imgs/avatar.png")),
            //     ),
            //   ),
            //   onTap: (){
            //     // ImagePicker.pickImage(source: ImageSource.gallery).then((file){
            //     //   setState(() {
            //     //     _editedGame.img = file.path;
            //     //   });
            //     // });
            //   },
            // ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: "Nome",
              ),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedGame!.name = text;
                });
              },
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _genrelController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: "Gênero",
              ),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedGame!.genre = text;
                });
              },
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: "Horas Jogadas",
              ),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedGame!.hours = text;
                });
              },
            ),
          ],
        ),
      ),
    )
    );
  }

  Future<bool> requestPop(){
    if(_userEdited){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: const Text("Descartar Alterações"),
          content: const Text("Se sair, as alterações serão perdidas"),
          actions: <Widget>[
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("Cancelar"),),
            TextButton(onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }, child: const Text("Sim"),),
          ],
        );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }
}