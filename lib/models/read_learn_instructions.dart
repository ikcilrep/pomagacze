class FAQQuestion {
  late final String title;
  late final String body;
  bool isExpanded = false;

  FAQQuestion.fromData(dynamic data) {
    title = data['title'] ?? '';
    body = data['body'] ?? '';
  }
}

class FAQSection {
  late final String title;
  late final List<FAQQuestion> children;

  FAQSection.fromData(dynamic data) {
    title = data['title'] ?? '';
    children = data['children']?.map<FAQQuestion>((x) => FAQQuestion.fromData(x)).toList() ?? [];
  }
}