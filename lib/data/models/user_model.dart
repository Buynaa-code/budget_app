import '../../domain/entities/user_entity.dart';

/// Data model class for User entity with serialization methods.
class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    required String email,
    String? name,
    String? phone,
    String? photoUrl,
    required DateTime createdAt,
  }) : super(
          uid: uid,
          email: email,
          name: name,
          phone: phone,
          photoUrl: photoUrl,
          createdAt: createdAt,
        );

  /// Create a UserModel from a map (e.g., from database or API).
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  /// Convert the UserModel to a map for persistence.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy of the UserModel with optional changes.
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
