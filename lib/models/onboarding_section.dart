class OnboardingSection {
  late final String title;
  late final String subtitle;
  late final String image;

  OnboardingSection.fromData(dynamic data) {
    title = data['title'] ?? '';
    subtitle = data['subtitle'] ?? '';
    image = data['image'] ?? '';
  }
}
