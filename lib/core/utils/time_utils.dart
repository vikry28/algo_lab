class TimeUtils {
  static String formatUptime(double seconds) {
    final int s = seconds.round();
    final Duration d = Duration(seconds: s);

    if (d.inDays > 0) {
      return "${d.inDays}d ${d.inHours % 24}h";
    } else if (d.inHours > 0) {
      return "${d.inHours}h ${d.inMinutes % 60}m";
    } else if (d.inMinutes > 0) {
      return "${d.inMinutes}m ${d.inSeconds % 60}s";
    }
    return "${d.inSeconds}s";
  }

  static String hhmmsss(double ms) {
    final d = Duration(milliseconds: ms.toInt());
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');

    return "$hours:$minutes:$seconds";
  }

  static String hhmmss(double seconds) {
    final int s = seconds.round();
    final Duration d = Duration(seconds: s);

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return "${twoDigits(d.inHours)}:"
        "${twoDigits(d.inMinutes % 60)}:"
        "${twoDigits(d.inSeconds % 60)}";
  }

  static String verbose(double seconds) {
    final int s = seconds.round();
    final Duration d = Duration(seconds: s);

    final parts = <String>[];

    if (d.inDays > 0) parts.add("${d.inDays} day${d.inDays > 1 ? 's' : ''}");
    if (d.inHours % 24 > 0) {
      final h = d.inHours % 24;
      parts.add("$h hour${h > 1 ? 's' : ''}");
    }
    if (d.inMinutes % 60 > 0) {
      final m = d.inMinutes % 60;
      parts.add("$m minute${m > 1 ? 's' : ''}");
    }
    if (d.inSeconds % 60 > 0) {
      final sec = d.inSeconds % 60;
      parts.add("$sec second${sec > 1 ? 's' : ''}");
    }

    return parts.isEmpty ? "0 seconds" : parts.join(" ");
  }
}
