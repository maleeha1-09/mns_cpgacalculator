class QPCalculator {
  static double calculateQP(double obtainedMarks, double maxMarks) {
    if (maxMarks == 20) return _calculateQP20(obtainedMarks);
    if (maxMarks == 40) return _calculateQP40(obtainedMarks);
    if (maxMarks == 60) return _calculateQP60(obtainedMarks);
    if (maxMarks == 80) return _calculateQP80(obtainedMarks);
    if (maxMarks == 100) return _calculateQP100(obtainedMarks);
    return 0.0;
  }

  static double _calculateQP20(double marks) {
    if (marks >= 16) return 4.00;
    if (marks == 15) return 3.67;
    if (marks == 14) return 3.33;
    if (marks == 13) return 3.00;
    if (marks == 12) return 2.67;
    if (marks == 11) return 2.33;
    if (marks == 10) return 2.00;
    if (marks == 9) return 1.50;
    if (marks == 8) return 1.00;
    return 0.0;
  }

  static double _calculateQP40(double marks) {
    if (marks >= 32) return 8.00;
    if (marks == 31) return 7.67;
    if (marks == 30) return 7.33;
    if (marks == 29) return 7.00;
    if (marks == 28) return 6.67;
    if (marks == 27) return 6.33;
    if (marks == 26) return 6.00;
    if (marks == 25) return 5.67;
    if (marks == 24) return 5.33;
    if (marks == 23) return 5.00;
    if (marks == 22) return 4.67;
    if (marks == 21) return 4.33;
    if (marks == 20) return 4.00;
    if (marks == 19) return 3.50;
    if (marks == 18) return 3.00;
    if (marks == 17) return 2.50;
    if (marks == 16) return 2.00;
    return 0.0;
  }

  static double _calculateQP60(double marks) {
    if (marks >= 48) return 12.00;
    if (marks == 47) return 11.67;
    if (marks == 46) return 11.33;
    if (marks == 45) return 11.00;
    if (marks == 44) return 10.67;
    if (marks == 43) return 10.33;
    if (marks == 42) return 10.00;
    if (marks == 41) return 9.67;
    if (marks == 40) return 9.33;
    if (marks == 39) return 9.00;
    if (marks == 38) return 8.67;
    if (marks == 37) return 8.33;
    if (marks == 36) return 8.00;
    if (marks == 35) return 7.67;
    if (marks == 34) return 7.33;
    if (marks == 33) return 7.00;
    if (marks == 32) return 6.67;
    if (marks == 31) return 6.33;
    if (marks == 30) return 6.00;
    if (marks == 29) return 5.50;
    if (marks == 28) return 5.00;
    if (marks == 27) return 4.50;
    if (marks == 26) return 4.00;
    if (marks == 25) return 3.50;
    if (marks == 24) return 3.00;
    return 0.0;
  }

  static double _calculateQP80(double marks) {
    if (marks >= 64) return 16.00;
    if (marks == 63) return 15.67;
    if (marks == 62) return 15.33;
    if (marks == 61) return 15.00;
    if (marks == 60) return 14.67;
    if (marks == 59) return 14.33;
    if (marks == 58) return 14.00;
    if (marks == 57) return 13.67;
    if (marks == 56) return 13.33;
    if (marks == 55) return 13.00;
    if (marks == 54) return 12.67;
    if (marks == 53) return 12.33;
    if (marks == 52) return 12.00;
    if (marks == 49) return 11.00;
    if (marks == 48) return 10.67;
    if (marks == 47) return 10.33;
    if (marks == 46) return 10.00;
    if (marks == 45) return 9.67;
    if (marks == 44) return 9.33;
    if (marks == 43) return 9.00;
    if (marks == 42) return 8.67;
    if (marks == 41) return 8.33;
    if (marks == 40) return 8.00;
    if (marks == 39) return 7.50;
    if (marks == 38) return 7.00;
    if (marks == 37) return 6.50;
    if (marks == 36) return 6.00;
    if (marks == 35) return 5.50;
    if (marks == 34) return 5.00;
    if (marks == 33) return 4.50;
    if (marks == 32) return 4.00;
    return 0.0;
  }

  static double _calculateQP100(double marks) {
    if (marks >= 80) return 20.00;
    if (marks == 79) return 19.67;
    if (marks == 78) return 19.33;
    if (marks == 77) return 19.00;
    if (marks == 76) return 18.67;
    if (marks == 75) return 18.33;
    if (marks == 74) return 18.00;
    if (marks == 73) return 17.67;
    if (marks == 72) return 17.33;
    if (marks == 71) return 17.00;
    if (marks == 70) return 16.67;
    if (marks == 69) return 16.33;
    if (marks == 68) return 16.00;
    if (marks == 67) return 15.67;
    if (marks == 66) return 15.33;
    if (marks == 65) return 15.00;
    if (marks == 64) return 16.00;
    if (marks == 63) return 15.67;
    if (marks == 62) return 15.33;
    if (marks == 61) return 15.00;
    if (marks == 60) return 14.67;
    if (marks == 59) return 14.33;
    if (marks == 58) return 14.00;
    if (marks == 57) return 13.67;
    if (marks == 56) return 13.33;
    if (marks == 55) return 13.00;
    if (marks == 54) return 12.67;
    if (marks == 53) return 12.33;
    if (marks == 52) return 12.00;
    if (marks == 51) return 11.00;
    if (marks == 50) return 10.00;
    if (marks == 49) return 9.50;
    if (marks == 48) return 9.00;
    if (marks == 47) return 8.50;
    if (marks == 46) return 8.00;
    if (marks == 45) return 7.50;
    if (marks == 44) return 7.00;
    if (marks == 43) return 6.50;
    if (marks == 42) return 6.00;
    if (marks == 41) return 5.50;
    if (marks == 40) return 5.00;
    return 0.0;
  }
}