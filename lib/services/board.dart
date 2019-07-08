import 'package:rxdart/rxdart.dart';
import 'dart:math' as math;

import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/services/sound.dart';

final soundService = locator<SoundService>();

enum BoardState { Done, Play }
enum GameMode { Solo, Multi }

class BoardService {
  BehaviorSubject<List<List<String>>> _board$;
  BehaviorSubject<List<List<String>>> get board$ => _board$;

  BehaviorSubject<String> _player$;
  BehaviorSubject<String> get player$ => _player$;

  BehaviorSubject<MapEntry<BoardState, String>> _boardState$;
  BehaviorSubject<MapEntry<BoardState, String>> get boardState$ => _boardState$;

  BehaviorSubject<GameMode> _gameMode$;
  BehaviorSubject<GameMode> get gameMode$ => _gameMode$;

  BehaviorSubject<MapEntry<int, int>> _score$;
  BehaviorSubject<MapEntry<int, int>> get score$ => _score$;

  String _start;

  BoardService() {
    _initStreams();
  }

  void newMove(int i, int j) {
    String player = _player$.value;
    List<List<String>> currentBoard = _board$.value;

    currentBoard[i][j] = player;
    _playMoveSound(player);
    _board$.add(currentBoard);
    switchPlayer(player);

    bool isWinner = _checkWinner(i, j);

    if (isWinner) {
      _updateScore(player);
      _boardState$.add(MapEntry(BoardState.Done, player));
      return;
    } else if (isBoardFull()) {
      _boardState$.add(MapEntry(BoardState.Done, null));
    } else if (_gameMode$.value == GameMode.Solo) {
      botMove();
    }
  }

  botMove() {
    String player = _player$.value;
    List<List<String>> currentBoard = _board$.value;
    List<List<int>> temp = List<List<int>>();
    for (var i = 0; i < currentBoard.length; i++) {
      for (var j = 0; j < currentBoard[i].length; j++) {
        if (currentBoard[i][j] == " ") {
          temp.add([i, j]);
        }
      }
    }

    math.Random rnd = new math.Random();
    int r = rnd.nextInt(temp.length);
    int i = temp[r][0];
    int j = temp[r][1];

    currentBoard[i][j] = player;
    _board$.add(currentBoard);
    switchPlayer(player);

    bool isWinner = _checkWinner(i, j);

    if (isWinner) {
      _updateScore(player);
      _boardState$.add(MapEntry(BoardState.Done, player));
      return;
    } else if (isBoardFull()) {
      _boardState$.add(MapEntry(BoardState.Done, null));
    }
  }

  _updateScore(String winner) {
    if (winner == "O") {
      _score$.add(MapEntry(_score$.value.key, _score$.value.value + 1));
    } else if (winner == "X") {
      _score$.add(MapEntry(_score$.value.key + 1, _score$.value.value));
    }
  }

  _playMoveSound(player) {
    if (player == "X") {
      soundService.playSound('x');
    } else {
      soundService.playSound('o');
    }
  }

  bool _checkWinner(int x, int y) {
    var currentBoard = _board$.value;

    var col = 0, row = 0, diag = 0, rdiag = 0;
    var n = currentBoard.length - 1;
    var player = currentBoard[x][y];

    for (int i = 0; i < currentBoard.length; i++) {
      if (currentBoard[x][i] == player) col++;
      if (currentBoard[i][y] == player) row++;
      if (currentBoard[i][i] == player) diag++;
      if (currentBoard[i][n - i] == player) rdiag++;
    }
    if (row == n + 1 || col == n + 1 || diag == n + 1 || rdiag == n + 1) {
      return true;
    }
    return false;
  }

  void setStart(String e) {
    _start = e;
  }

  void switchPlayer(String player) {
    if (player == 'X') {
      _player$.add('O');
    } else {
      _player$.add('X');
    }
  }

  bool isBoardFull() {
    List<List<String>> board = _board$.value;
    int count = 0;
    for (var i = 0; i < board.length; i++) {
      for (var j = 0; j < board[i].length; j++) {
        if (board[i][j] == ' ') count = count + 1;
      }
    }
    if (count == 0) return true;

    return false;
  }

  void resetBoard() {
    _board$.add([
      [' ', ' ', ' '],
      [' ', ' ', ' '],
      [' ', ' ', ' ']
    ]);
    _player$.add(_start);
    _boardState$.add(MapEntry(BoardState.Play, ""));
    if (_player$.value == "O") {
      _player$.add("X");
    }
  }

  void newGame() {
    resetBoard();
    _score$.add(MapEntry(0, 0));
  }

  void _initStreams() {
    _board$ = BehaviorSubject<List<List<String>>>.seeded([
      [' ', ' ', ' '],
      [' ', ' ', ' '],
      [' ', ' ', ' ']
    ]);
    _player$ = BehaviorSubject<String>.seeded("X");
    _boardState$ = BehaviorSubject<MapEntry<BoardState, String>>.seeded(
      MapEntry(BoardState.Play, ""),
    );
    _gameMode$ = BehaviorSubject<GameMode>.seeded(GameMode.Solo);
    _score$ = BehaviorSubject<MapEntry<int, int>>.seeded(MapEntry(0, 0));
    _start = 'X';
  }
}
