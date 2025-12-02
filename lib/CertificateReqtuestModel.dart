// This file only contains the data structure for your request.
class CertificateRequest {
  final String studentName;
  final String mobile;
  final String courseName;
  final String email;
  final String dob;
  final String startDate;
  final String completionDate;
  final String year;
  final String notes;

  CertificateRequest({
    required this.studentName,
    required this.mobile,
    required this.courseName,
    required this.email,
    required this.dob,
    required this.startDate,
    required this.completionDate,
    required this.year,
    required this.notes,
  });

  // Method to convert the object to a JSON map for the API body.
  Map<String, String> toJson() {
    return {
    "student_name": studentName,
    "mobile": mobile,
    "course_name": courseName,
    "email": email,
    "dob": dob,
    "start_date": startDate,
    "completion_date": completionDate,
    "year": year,
    "notes": notes,
    };
    }
}