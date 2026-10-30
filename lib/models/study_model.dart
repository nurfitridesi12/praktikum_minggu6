class StudyModel {
  final String subject;
  final int currentProgress;
  final int totalProgress;
  final bool isFavorite;
  final bool focusMode;

  StudyModel({
    required this.subject,
    required this.currentProgress,
    required this.totalProgress,
    this.isFavorite = false,
    this.focusMode = false,
  });

  StudyModel copyWith({
    String? subject,
    int? currentProgress,
    int? totalProgress,
    bool? isFavorite,
    bool? focusMode,
  }) {
    return StudyModel(
      subject: subject ?? this.subject,
      currentProgress: currentProgress ?? this.currentProgress,
      totalProgress: totalProgress ?? this.totalProgress,
      isFavorite: isFavorite ?? this.isFavorite,
      focusMode: focusMode ?? this.focusMode,
    );
  }

  String get progressPercentage {
    if (totalProgress == 0) return '0';
    return ((currentProgress / totalProgress) * 100).round().toString();
  }

  String get progressStatus {
    if (currentProgress == 0) return 'Belum Mulai';
    if (currentProgress == totalProgress) return 'Selesai';
    return 'Sedang Berjalan';
  }
}