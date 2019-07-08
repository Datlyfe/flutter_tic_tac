import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/components/board.dart';
import 'package:tic_tac/components/o.dart';
import 'package:tic_tac/components/x.dart';
import 'package:tic_tac/services/board.dart';
import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/theme/theme.dart';

class GamePage extends StatefulWidget {
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  final boardService = locator<BoardService>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        boardService.newGame();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: StreamBuilder<MapEntry<int, int>>(
              stream: boardService.score$,
              builder: (context, AsyncSnapshot<MapEntry<int, int>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final int xScore = snapshot.data.key;
                final int oScore = snapshot.data.value;

                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: double.infinity,
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 30,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0,
                                      color: Color(0x1F000000),
                                    ),
                                  ],
                                ),
                                child: Center(
                                    child: Text(
                                  "$xScore",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                )),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              X(35, 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Player",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 4,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Board()],
                          )),
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: double.infinity,
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              O(35, MyTheme.green),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Player",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                height: 30,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0,
                                      color: Color(0x1F000000),
                                    ),
                                  ],
                                ),
                                child: Center(
                                    child: Text(
                                  "$oScore",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              IconButton(
                                icon: Icon(Icons.home),
                                onPressed: () {
                                  boardService.newGame();
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                                color: Colors.black87,
                                iconSize: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
