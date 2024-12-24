class Bill {
  double? amount;
  String? category;
  String? type;
  String? date;
  String? note;

  Bill({this.amount, this.category, this.type, this.date, this.note});

  Bill.fromJson(Map<String, dynamic> json) {
    if (json["amount"] is double) {
      amount = json["amount"];
    }
    if (json["category"] is String) {
      category = json["category"];
    }
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["date"] is String) {
      date = json["date"];
    }
    if (json["note"] is String) {
      note = json["note"];
    }
  }

  static List<Bill> fromList(List<Map<String, dynamic>> list) {
    return list.map(Bill.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["amount"] = amount;
    _data["category"] = category;
    _data["type"] = type;
    _data["date"] = date;
    _data["note"] = note;
    return _data;
  }
}
