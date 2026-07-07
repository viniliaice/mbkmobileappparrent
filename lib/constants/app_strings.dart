class AppStrings {
  static const String monthly = 'Monthly';
  static const String midterm = 'Midterm';
  static const String finalTerm = 'Final';
  
  static const String noMonthlyData = 'No monthly exam data available';
  static const String showing400Records = 'Showing up to 400 exam records';
  static const String monthlyAverage = 'Monthly Average';
  static const String noResultsThisMonth = 'No results for this month';
  static String monthLabel(String month) => 'Month $month';
  
  static const String noMidtermData = 'No midterm results available';
  static const String midtermAverage = 'Midterm Average';
  static const String ca50 = 'CA (50%)';
  static const String exam50 = 'Exam (50%)';
  
  static const String noFinalData = 'No final results available';
  static const String finalAverage = 'Final Average';
  static const String overall = 'Overall';
  
  static const String ca = 'CA';
  static const String finalExam = 'Final Exam';
  static const String midtermExam = 'Midterm Exam';
  static const String monthlyExam = 'Monthly Exam';
  static const String total = 'Total';
  static String positionLabel(int position, String ordinal) => 'Position: $position$ordinal';
  
  static const String loadingResults = 'Loading results...';
}
