class Patient {
  final String username;
  final int birthYear;
  final String displayName;

  const Patient(
      {required this.username,
      required this.birthYear,
      required this.displayName});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      username: json['username'],
      birthYear: json['birth_year'],
      displayName: json['display_name'],
    );
  }

  @override
  String toString() {
    return 'Patient(username: $username, birthYear: $birthYear, displayName: $displayName)';
  }
}
