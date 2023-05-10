class Transaction {
  String id;
  String title;
  String body;
  String date;
  int status;
  int type;
  Transaction(
      {required this.id,
      required this.title,
      required this.body,
      required this.date,
      required this.status,
      required this.type});
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        id: json.containsKey('id') ? json["id"] : "",
        title: json.containsKey('title') ? json["title"] : "",
        body: json.containsKey('body') ? json["body"] : "",
        date: json.containsKey('date') ? json["date"] : "",
        status: json.containsKey('status') ? json["status"] : "",
        type: json.containsKey('type') ? json["type"] : "",
    );
  }
  @override
  String toString() => 'Notification {'
      'id: $id,'
      'title: $title,'
      'body: $body,'
      'date: $date,'
      'status: $status,'
      'type: $type,'
      '}';
}
class Transactions{
  List<Transaction> transactions = [];
  Transactions.fromJson(List<dynamic> parsedJson) {
    transactions = parsedJson.map((i) => Transaction.fromJson(i)).toList();
  }
  Transactions.fromTransactions(this.transactions);
}
