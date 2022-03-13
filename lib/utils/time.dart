String fromNowString(DateTime time) {
  final timeSince = DateTime.now().difference(time);

  if (timeSince > const Duration(days: 365)) {
    return (timeSince.inDays ~/ 365).toString() + 'y';
  } else if (timeSince > const Duration(days: 30)) {
    return (timeSince.inDays ~/ 30).toString() + 'mo';
  } else if (timeSince > const Duration(days: 1)) {
    return timeSince.inDays.toString() + 'd';
  } else if (timeSince > const Duration(hours: 1)) {
    return timeSince.inHours.toString() + 'h';
  } else if (timeSince > const Duration(minutes: 1)) {
    return timeSince.inMinutes.toString() + 'm';
  } else if (timeSince > const Duration(seconds: 1)) {
    return timeSince.inSeconds.toString() + 's';
  } else {
    return 'now';
  }
}

String formatDate(DateTime date) {
  String daySuffix(int dayNumber) {
    switch (dayNumber % 100) {
      case 11:
      case 12:
      case 13:
        return 'th';
    }

    switch (dayNumber % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String monthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        throw 'Invalid Month';
    }
  }

  return '${date.day}${daySuffix(date.day)} ${monthAbbreviation(date.month)} ${date.year}';
}
