import 'package:equatable/equatable.dart';

/// Entity representing a user in the application domain.
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final String? phone;
  final String? photoUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    this.name,
    this.phone,
    this.photoUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [uid, email, name, phone, photoUrl, createdAt];
}
