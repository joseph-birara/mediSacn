class Patient {
  final String id;
  final String name;
  final int age;
  final String diagnosis;
  final String imageUrl;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.diagnosis,
    required this.imageUrl,
  });

  // Factory constructor to create a Patient object from JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'], // Make sure to match the backend's field names
      name: json['name'],
      age: json['age'],
      diagnosis: json['diagnosis'],
      imageUrl: json['imageUrl'] ?? '', // Handle cases where imageUrl is null
    );
  }

  // Convert Patient object to JSON (for any outgoing requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'diagnosis': diagnosis,
      'imageUrl': imageUrl,
    };
  }
}
