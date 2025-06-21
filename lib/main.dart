import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:animated_text_kit/animated_text_kit.dart';



// O ponto de entrada principal para a aplicação.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Inicializa os widgets antes do firebase
  await Firebase.initializeApp(); //Inicializa o FireBase
  runApp(const MeuAplicativo());
}

class MeuAplicativo extends StatefulWidget {
  const MeuAplicativo({super.key});

  @override
  State<MeuAplicativo> createState() => _MeuAplicativoState();
}


class _MeuAplicativoState extends State<MeuAplicativo> {
  late AudioPlayer player;
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    _tocarSom("assets/som.mp3");
  }
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
  void _tocarSom(String caminho) async {
    try {
      await player.stop();
      await player.setAsset(caminho);
      player.play();
    } catch (e) {
      print('Erro ao tocar som: $e');
    }
  }
  String _frase = 'Precione a Bíblia para receber uma mensagem de Deus! 👇🏾';


  Future<void> _pegaFraseAleatoria() async {
    _tocarSom("assets/som.mp3");
    try {

      final collection = FirebaseFirestore.instance.collection('frases');
      final snapshot = await collection.get();


      if (snapshot.docs.isNotEmpty) {

        final randomId = Random().nextInt(snapshot.docs.length);
        final randomDoc = snapshot.docs[randomId];

        setState(() {
          _frase = randomDoc['texto'];
        });
      } else {
        setState(() {
          _frase = 'Nenhuma frase encontrada. Adicione frases ao Firestore.';
        });
      }
    } catch (e) {
      setState(() {
        _frase = 'Ocorreu um erro ao buscar a frase.';
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Versículos Bíblicos'),
          backgroundColor: Color(0xffe31123),
          titleTextStyle: TextStyle(
            color: Color(0xffffffff),
            fontSize: 25,
          ),
          centerTitle: true,
        ),

        body: Container(// Corpo da tela principal
          decoration: BoxDecoration(
            //exemplo de Gradiente
            gradient: LinearGradient(
              colors: [Color(0xffe31123),Color(0xff710a0a), Color(0xe7040404)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  AnimatedTextKit(
                    key: ValueKey(_frase), // força a recriação com a nova frase
                    animatedTexts: [
                      TypewriterAnimatedText(
                        _frase,
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                        speed: Duration(milliseconds: 40),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: Duration(milliseconds: 500),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),

                  SizedBox(height: 40),
                  ElevatedButton( // Botão com o ícone da bola de cristal.
                    child: Text("📖"),
                    style: ButtonStyle(
                      textStyle: WidgetStateProperty.all(TextStyle(
                        fontSize: 90,
                      )),
                      backgroundColor: WidgetStateProperty.all(Colors.transparent),
                      //elevation: WidgetStatePropertyAll(0),
                    ),
                    onPressed: _pegaFraseAleatoria,
                  ),
                ],
              ),
            ),
          ),
        ),


      ),
    );
  }
}
