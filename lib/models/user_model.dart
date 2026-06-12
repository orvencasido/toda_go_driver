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
      'id': uid,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'tricycle_number': tricycleNumber,
      'plate_number': plateNumber,
      'role': 'driver',
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['id'] ?? map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? map['fullName'] ?? '',
      phoneNumber: map['phone_number'] ?? map['phoneNumber'] ?? '',
      tricycleNumber: map['tricycle_number'] ?? map['tricycleNumber'] ?? '',
      plateNumber: map['plate_number'] ?? map['plateNumber'] ?? '',
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
