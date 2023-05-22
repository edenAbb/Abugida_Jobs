class JNotification {
  String id;
  String title;
  String body;
  String date;
  int status;//1 unseen, 2 seen
  int type;
  JNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.date,
      required this.status,
      required this.type});
  factory JNotification.fromJson(Map<String, dynamic> json) {
    return JNotification(
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
class Notifications{
  List<JNotification> notifications = [];
  Notifications.fromJson(List<dynamic> parsedJson) {
    notifications = parsedJson.map((i) => JNotification.fromJson(i)).toList();
  }
  Notifications.fromNotification(this.notifications);
}
