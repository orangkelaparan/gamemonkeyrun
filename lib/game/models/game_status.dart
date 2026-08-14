enum GameStatus {
  home,
  tutorial,
  ready,
  running,
  paused,
  collision,
  handLick,
  gameOver,
}

extension GameStatusX on GameStatus {
  bool get acceptsJump =>
      this == GameStatus.ready || this == GameStatus.running;

  bool get hasActiveWorld =>
      this == GameStatus.ready ||
      this == GameStatus.running ||
      this == GameStatus.collision ||
      this == GameStatus.handLick;
}
