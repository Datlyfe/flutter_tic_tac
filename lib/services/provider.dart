import 'package:get_it/get_it.dart';
import 'package:tic_tac/services/board.dart';

GetIt locator = new GetIt();

void setupLocator() {
  locator.registerSingleton(BoardService());
}
