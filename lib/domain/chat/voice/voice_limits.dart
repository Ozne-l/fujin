abstract final class VoiceLimits {
  static const shortest = Duration(seconds: 1);
  static const longest = Duration(minutes: 5);
  static const lead = Duration(seconds: 10);

  static bool tooShort(Duration recorded) => recorded < shortest;

  static bool nearEnd(Duration recorded) => recorded >= longest - lead;

  static bool reached(Duration recorded) => recorded >= longest;

  static int seconds(Duration readBack) =>
      (readBack.inMilliseconds / Duration.millisecondsPerSecond).round().clamp(
        shortest.inSeconds,
        longest.inSeconds,
      );
}
