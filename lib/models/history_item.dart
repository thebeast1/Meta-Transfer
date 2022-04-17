import 'package:meta_transfer/db_handler.dart';

class HistoryItem {
  String _name, time;
  int type; // from = 0, to = 1.
  String _amount, sender, receiver;

  String get name => _name;

  String get amount => _amount;

  HistoryItem(String time, String amount, String sender, String receiver) {
    sender == DBHandler.currentUser.email ? type = 0 : type = 1;

    _name = type == 0 ? "To " + receiver : "From " + sender;
    this.time = time;
    this.type = type;
    _amount = type == 0 ? "-\$$amount" : "+\$$amount";
    this.sender = sender;
    this.receiver = receiver;
  }
}
