class LoginResponse
{
  final String acceso;
  final String error;
  final String token;
  final int idUsuario;
  final String nombreUsuario;
  LoginResponse(this.acceso, this.error, this.idUsuario, this.nombreUsuario, this.token);
  LoginResponse.fromJson(Map<String, dynamic> json) :acceso = json['acceso'],
        error = json['error'],token = json['token'],idUsuario = json['idUsuario'],nombreUsuario = json['nombreUsuario'];

}