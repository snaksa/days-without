class DateHelper {
  static String convertDurationToString(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours - (days * 24);
    int minutes = duration.inMinutes - (days * 24 * 60 + hours * 60);
    int seconds = duration.inSeconds -
        (days * 24 * 60 * 60 + hours * 60 * 60 + minutes * 60);
    List<String> passed = [];
    if (days > 0) {
      passed.add('${days}d');
    }
    if (hours > 0 || days > 0) {
      passed.add('${hours}h');
    }
    if (minutes > 0 || days + hours > 0) {
      passed.add('${minutes}m');
    }
    if (seconds > 0 || days + hours + minutes > 0) {
      passed.add('${seconds < 10 ? 0 : ""}${seconds}s');
    }

    return passed.join(' ');
  }
}
