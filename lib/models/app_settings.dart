class AppSettings {
  final String id;
  final String headerImageUrl;
  final String? appTitle;
  final String? appSubtitle;

  AppSettings({
    required this.id,
    required this.headerImageUrl,
    this.appTitle,
    this.appSubtitle,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      id: json['id'].toString(),
      headerImageUrl: json['header_image_url'] ?? '',
      appTitle: json['app_title'],
      appSubtitle: json['app_subtitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'header_image_url': headerImageUrl,
      'app_title': appTitle,
      'app_subtitle': appSubtitle,
    };
  }

  static AppSettings getDefault() {
    return AppSettings(
      id: 'default',
      headerImageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&auto=format&fit=crop',
      appTitle: 'Our Adventures',
      appSubtitle: 'A collection of our favorite moments',
    );
  }
}
