class ProgressStream {
  int progress;
  int totalStages;
  int currentStage;
  bool finishedStream;
  String message;
  ProgressStream({
    required this.message,
    required this.progress,
    this.finishedStream = false,
    required this.totalStages,
    required this.currentStage,
  });
}
