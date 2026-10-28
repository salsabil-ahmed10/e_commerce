/// The logged-in user, built from the response of
/// POST https://dummyjson.com/auth/login (the existing login request).
/// Only fields the API really sends are kept; the access token is not.
class UserProfile {
  final int? id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;

  const UserProfile({
    required this.username,
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
  });

  /// "First Last" when the API sent a name, otherwise the username.
  String get displayName {
    final full = [firstName, lastName]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(' ');
    return full.isNotEmpty ? full : username;
  }

  /// Null when the response has no username (nothing real to show).
  static UserProfile? tryFromJson(Object? json) {
    if (json is! Map) return null;

    final username = json['username'];
    if (username is! String || username.isEmpty) return null;

    String? text(String key) {
      final v = json[key];
      return v is String && v.isNotEmpty ? v : null;
    }

    final id = json['id'];

    return UserProfile(
      id: id is int ? id : null,
      username: username,
      email: text('email'),
      firstName: text('firstName'),
      lastName: text('lastName'),
      gender: text('gender'),
      image: text('image'),
    );
  }
}
