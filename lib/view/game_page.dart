import 'package:flutter/material.dart';
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
  final _dateController = TextEditingController();
  final _ratingController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.game == null) {
      _editedGame = Game();
    } else {
      _editedGame = Game.fromMap(widget.game!.toMap());
      _nameController.text = _editedGame!.name ?? "";
      _genrelController.text = _editedGame!.genre ?? "";
      _hoursController.text = _editedGame!.hours ?? "";
      _ratingController.text = _editedGame!.rating?.toString() ?? "";
      _dateController.text = _editedGame!.purchaseDate ?? "";
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
          onPressed: () {
            if (_editedGame!.validate()) {
              Navigator.pop(context, _editedGame);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Erro de validação"),
                    content: const Text(
                        "Por favor, preencha todos os campos corretamente antes de salvar."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Icon(Icons.save),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Nome",
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedGame!.name = text;
                  });
                },
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _genrelController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Gênero",
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedGame!.genre = text;
                  });
                },
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _hoursController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Horas Jogadas",
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedGame!.hours = text;
                  });
                },
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _ratingController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Rating (0-10)",
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedGame!.rating = double.tryParse(text); // Atualiza o rating
                  });
                },
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                      _editedGame!.purchaseDate = _dateController.text;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: "Data de Compra",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Descartar alterações?"),
            content: const Text("Se sair, as alterações serão perdidas."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Sim"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancelar"),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
