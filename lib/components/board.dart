import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tic_tac/components/x.dart';
import 'package:tic_tac/services/board.dart';
import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/theme/theme.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'o.dart';

class Board extends StatefulWidget {
  Board({Key key}) : super(key: key);

  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final boardService = locator<BoardService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<
            MapEntry<List<List<String>>, MapEntry<BoardState, String>>>(
        stream: Observable.combineLatest2(boardService.board$,
            boardService.boardState$, (a, b) => MapEntry(a, b)),
        builder: (context,
            AsyncSnapshot<
                    MapEntry<List<List<String>>, MapEntry<BoardState, String>>>
                snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final List<List<String>> board = snapshot.data.key;
          final MapEntry<BoardState, String> state = snapshot.data.value;

          if (state.key == BoardState.Done) {
            boardService.resetBoard();

            String title = 'Winner';

            if (state.value == null) {
              title = "Draw";
            }

            Widget body = state.value == 'X'
                ? X(50, 20)
                : (state.value == "O"
                    ? O(50, MyTheme.green)
                    : Row(
                        children: <Widget>[X(50, 20), O(50, MyTheme.green)],
                      ));

            var alertStyle = AlertStyle(
              animationType: AnimationType.grow,
              isCloseButton: false,
              isOverlayTapDismiss: true,
              titleStyle: TextStyle(
                  color: Color(0xff111111),
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
              descStyle: TextStyle(fontWeight: FontWeight.bold),
              animationDuration: Duration(milliseconds: 300),
              buttonAreaPadding: EdgeInsets.all(12),
              overlayColor: Colors.black.withOpacity(.7),
              constraints: BoxConstraints(maxHeight: 200, maxWidth: 250),
              alertBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            );
            WidgetsBinding.instance.addPostFrameCallback((_) => {
                  Alert(
                    context: context,
                    title: title,
                    style: alertStyle,
                    buttons: [],
                    content: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[body]),
                  ).show()
                });
          }

          return Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 7.0,
                  spreadRadius: 0.0,
                  color: Color(0x1F000000),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: board
                  .asMap()
                  .map(
                    (i, row) => MapEntry(
                          i,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: row
                                .asMap()
                                .map(
                                  (j, item) => MapEntry(
                                        j,
                                        GestureDetector(
                                          onTap: () {
                                            if (board[i][j] != ' ') return;
                                            boardService.newMove(i, j);
                                          },
                                          child: _buildBox(i, j, item),
                                        ),
                                      ),
                                )
                                .values
                                .toList(),
                          ),
                        ),
                  )
                  .values
                  .toList(),
            ),
          );
        });
  }

  Widget _buildBox(int i, int j, item) {
    BoxBorder border = Border();
    BorderSide borderStyle = BorderSide(width: 1, color: Colors.black26);
    double height;
    double width;
    if (j == 1) {
      border = Border(right: borderStyle, left: borderStyle);
      height = width = 80;
    } else {
      height = 80;
      width = 60;
    }
    if (i == 1) {
      border = Border(top: borderStyle, bottom: borderStyle);
    }
    if (i == 1 && j == 1) {
      border = Border(
          top: borderStyle,
          bottom: borderStyle,
          left: borderStyle,
          right: borderStyle);
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: border,
      ),
      height: height,
      width: width,
      child: Center(
        child:
            item == ' ' ? null : item == 'X' ? X(50, 13) : O(50, MyTheme.green),
      ),
    );
  }
}
