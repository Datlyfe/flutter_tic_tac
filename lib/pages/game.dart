import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      child: SafeArea(
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
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Material(
                                        elevation: 5,
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Center(
                                            child: Text(
                                          "$xScore",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    X(35, 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        "Player",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[Board()],
                              )),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    O(35, MyTheme.green),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        "Player",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Material(
                                        elevation: 5,
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Center(
                                            child: Text(
                                          "$oScore",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 20),
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
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
