class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String tricycleNumber;
  final String plateNumber;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.tricycleNumber,
    required this.plateNumber,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'tricycleNumber': tricycleNumber,
      'plateNumber': plateNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      tricycleNumber: map['tricycleNumber'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
