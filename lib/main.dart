import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:frasedia/Frasedodia.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Versículos Bíblicos'),
          backgroundColor: Color(0xffe31123),
          titleTextStyle: TextStyle(color: Color(0xffffffff), fontSize: 25),
          centerTitle: true,
        ),

        body: Builder(
          builder: (context) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffe31123),
                  Color(0xff710a0a),
                  Color(0xe7040404),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.all(32),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MensagemDia()),
                );
              },
              child: Column(
                children: <Widget>[
                  Text(
                    "Precione a Bíblia para receber uma mensagem de Deus! 👇🏾",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Hero(
                    tag: "background_hero.tag",
                    child: Container(
                      child: ElevatedButton(
                        child: Text("📖"),
                        style: ButtonStyle(
                          textStyle: WidgetStateProperty.all(
                            TextStyle(fontSize: 90),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      MensagemDia(),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    var tween = Tween(
                                      begin: 1.0,
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
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
