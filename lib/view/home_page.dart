import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 112, 13, 129),
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
      backgroundColor: const Color.fromARGB(255, 44, 18, 44),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 112, 13, 129),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
        ),
      ),
    );
  }

  void showGamePage({Game contact}) async{
    final recContact = await Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      }else{
        await helper.saveContact(recContact);
      }
      getAllContacts();
    }
  }

}