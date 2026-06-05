import 'dart:convert';

class ProfileModel {
  final String name;
  final String contact;
  final String email;
  final String address;
  final String todaNumber;
  final String licenseNumber;
  final String vehicleDetails;
  final String verificationStatus;
  final String accountStatus;
  final String password;
  final String? imagePath;

  ProfileModel({
    required this.name,
    required this.contact,
    required this.email,
    required this.address,
    required this.todaNumber,
    required this.licenseNumber,
    required this.vehicleDetails,
    required this.verificationStatus,
    required this.accountStatus,
    required this.password,
    this.imagePath,
  });

  ProfileModel copyWith({
    String? name,
    String? contact,
    String? email,
    String? address,
    String? todaNumber,
    String? licenseNumber,
    String? vehicleDetails,
    String? verificationStatus,
    String? accountStatus,
    String? password,
    String? imagePath,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      address: address ?? this.address,
      todaNumber: todaNumber ?? this.todaNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      vehicleDetails: vehicleDetails ?? this.vehicleDetails,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      accountStatus: accountStatus ?? this.accountStatus,
      password: password ?? this.password,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contact': contact,
      'email': email,
      'address': address,
      'todaNumber': todaNumber,
      'licenseNumber': licenseNumber,
      'vehicleDetails': vehicleDetails,
      'verificationStatus': verificationStatus,
      'accountStatus': accountStatus,
      'password': password,
      'imagePath': imagePath,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      todaNumber: map['todaNumber'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      vehicleDetails: map['vehicleDetails'] ?? '',
      verificationStatus: map['verificationStatus'] ?? 'Verified',
      accountStatus: map['accountStatus'] ?? 'Active',
      password: map['password'] ?? 'password123',
      imagePath: map['imagePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) => ProfileModel.fromMap(json.decode(source));
}
