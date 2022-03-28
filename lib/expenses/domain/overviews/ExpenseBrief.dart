class ExpenseBrief {
  String text;

  ExpenseBrief.fromJson(Map<String, dynamic> json) : text = json['text'];

  Map<String, dynamic> toJson() => {
        'text': text,
      };
}
