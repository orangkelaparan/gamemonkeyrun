import 'game_status.dart';

class GameSnapshot {
  const GameSnapshot({
    required this.status,
    required this.score,
    required this.bestScore,
    required this.distanceMeters,
    required this.countdownLabel,
    required this.feedbackLabel,
    required this.isNewBest,
  });

  factory GameSnapshot.initial({int bestScore = 0}) => GameSnapshot(
    status: GameStatus.home,
    score: 0,
    bestScore: bestScore,
    distanceMeters: 0,
    countdownLabel: '',
    feedbackLabel: '',
    isNewBest: false,
  );

  final GameStatus status;
  final int score;
  final int bestScore;
  final int distanceMeters;
  final String countdownLabel;
  final String feedbackLabel;
  final bool isNewBest;

  GameSnapshot copyWith({
    GameStatus? status,
    int? score,
    int? bestScore,
    int? distanceMeters,
    String? countdownLabel,
    String? feedbackLabel,
    bool? isNewBest,
  }) {
    return GameSnapshot(
      status: status ?? this.status,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      countdownLabel: countdownLabel ?? this.countdownLabel,
      feedbackLabel: feedbackLabel ?? this.feedbackLabel,
      isNewBest: isNewBest ?? this.isNewBest,
    );
  }

  String get formattedScore => score.toString().padLeft(6, '0');

  String get formattedBest => bestScore.toString().padLeft(6, '0');
}
