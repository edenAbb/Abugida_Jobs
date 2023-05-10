class Report {
  String id;
  String title;
  VacancyReport vacancyReport;
  UserReport userReport;
  TransactionReport transactionReport;
  int type;
  Report(
      {required this.id,
      required this.title,
      required this.vacancyReport,
      required this.userReport,
      required this.transactionReport,
      required this.type});
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        id: json.containsKey('id') ? json["id"] : "",
        title: json.containsKey('title') ? json["title"] : "",
        vacancyReport: json.containsKey('vacancy') ? json["vacancy"] : "",
        userReport: json.containsKey('user') ? json["user"] : "",
        transactionReport: json.containsKey('transaction') ? json["transaction"] : "",
        type: json.containsKey('type') ? json["type"] : "",
    );
  }
  @override
  String toString() => 'Report {'
      'id: $id,'
      'title: $title,'
      'body: $vacancyReport,'
      'date: $userReport,'
      'status: $transactionReport,'
      'type: $type'
      '}';
}
class VacancyReport{
  String title;
  String open;
  String close;
  String ongoing;
  String completed;
  String archived;
  VacancyReport({
    required this.title,
    required this.open,
    required this.close,
    required this.ongoing,
    required this.completed,
    required this.archived,
});
  factory VacancyReport.fromJson(Map<String, dynamic> json) {
    return VacancyReport(
      title: json.containsKey('title') ? json["title"] : "",
      open: json.containsKey('open') ? json["open"] : "",
      close: json.containsKey('close') ? json["close"] : "",
      ongoing: json.containsKey('status') ? json["ongoing"] : "",
      completed: json.containsKey('completed') ? json["completed"] : "",
      archived: json.containsKey('archived') ? json["archived"] : ""
    );
  }
  @override
  String toString() => 'VacancyReport {'
      'title: $title,'
      'open: $open,'
      'close: $close,'
      'ongoing: $ongoing,'
      'completed: $completed,'
      'archived: $archived'
      '}';
}
class UserReport{
  String title;
  String employee;
  String employer;
  String admin;
  UserReport({
    required this.title,
    required this.employee,
    required this.employer,
    required this.admin
});
  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
        title: json.containsKey('title') ? json["title"] : "",
        employee: json.containsKey('employee') ? json["employee"] : "",
        employer: json.containsKey('employer') ? json["employer"] : "",
        admin: json.containsKey('admin') ? json["admin"] : ""
    );
  }

  @override
  String toString() => 'UserReport {'
      'title: $title,'
      'employee: $employee,'
      'employer: $employer,'
      'admin: $admin'
      '}';
}
class TransactionReport{
  String title;
  String total;
  String paid;
  String fee;
  TransactionReport({
    required this.title,
    required this.total,
    required this.paid,
    required this.fee
  });
  factory TransactionReport.fromJson(Map<String, dynamic> json) {
    return TransactionReport(
        title: json.containsKey('title') ? json["title"] : "",
        total: json.containsKey('total') ? json["total"] : "",
        paid: json.containsKey('paid') ? json["paid"] : "",
        fee: json.containsKey('fee') ? json["fee"] : ""
    );
  }

  @override
  String toString() => 'TransactionReport {'
      'title: $title,'
      'total: $total,'
      'paid: $paid,'
      'fee: $fee'
      '}';
}
