class ExpenseOverview {
  String text;

  ExpenseOverview.fromJson(Map<String, dynamic> json)
      : text = json['text'];

  Map<String, dynamic> toJson() => {
    'text': text,
  };
}
