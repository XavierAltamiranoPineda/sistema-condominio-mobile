import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String token;
  final String usuario;
  final int idUsuario;
  final List<String> roles;

  AuthResponse({
    required this.token,
    required this.usuario,
    required this.idUsuario,
    required this.roles,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
