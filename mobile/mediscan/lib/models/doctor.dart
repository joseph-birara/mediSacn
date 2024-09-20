class Doctor {
  final String id;
  final String username;
  final String email;

  Doctor({required this.id, required this.username, required this.email});

  // Factory constructor to create a Doctor object from JSON
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  // Convert Doctor object to JSON (for any outgoing requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}
