import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:frasedia/main.dart';

class MensagemDia extends StatefulWidget {
  const MensagemDia({super.key});

  @override
  State<MensagemDia> createState() => _MensagemDiaState();
}

class _MensagemDiaState extends State<MensagemDia> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _tocarSom("assets/som.mp3");
    _pegaFraseAleatoria();
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

  String _frase = '';
  String _versiculo = '';

  Future<void> _pegaFraseAleatoria() async {
    try {
      final collection = FirebaseFirestore.instance.collection('frases');
      final snapshot = await collection.get();

      if (snapshot.docs.isNotEmpty) {
        final randomId = Random().nextInt(snapshot.docs.length);
        final randomDoc = snapshot.docs[randomId];

        setState(() {
          _frase = randomDoc['texto'];
          _versiculo = randomDoc['versiculo'];
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Versículos Bíblicos'),
        backgroundColor: Color(0xffe31123),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe31123), Color(0xff710a0a), Color(0xe7040404)],
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
                  key: ValueKey(_frase),
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
                Text(_versiculo,
                  style: TextStyle(
                  fontSize: 24,
                  height: 5,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all(TextStyle(
                      fontSize: 50,
                    )),
                    backgroundColor:
                    WidgetStateProperty.all(Colors.transparent),
                    elevation: WidgetStatePropertyAll(1),
                  ),
                  onPressed: () {
                    player.stop();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                            MeuAplicativo(),


                        transitionsBuilder:
                            (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                            ) {
                          var tween = Tween(
                            begin: 0.0,
                            end: 3.0,
                          ).chain(CurveTween(curve: Curves.easeInBack));
                          return FadeTransition(
                            opacity: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Text("◀️Voltar",
                    style: TextStyle(
                    fontSize: 24,
                    height: 2,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
