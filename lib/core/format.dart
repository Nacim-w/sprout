const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

const _monthsShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String monthDay(DateTime d) => '${d.day} ${_monthsShort[d.month - 1]}';

String longDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

String weekdayName(DateTime d) {
  const names = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];
  return names[d.weekday - 1];
}

/// A friendly label for how soon a plant needs water.
String dueLabel(int daysUntil) {
  if (daysUntil < 0) {
    final overdue = -daysUntil;
    return overdue == 1 ? 'Overdue by 1 day' : 'Overdue by $overdue days';
  }
  if (daysUntil == 0) return 'Due today';
  if (daysUntil == 1) return 'Due tomorrow';
  if (daysUntil < 7) return 'Due in $daysUntil days';
  if (daysUntil < 14) return 'Due in about a week';
  return 'Due in ${(daysUntil / 7).round()} weeks';
}
