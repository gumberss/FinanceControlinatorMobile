class SignUpUser {
  String userName;
  String password;
  String email;

  SignUpUser(this.userName, this.password, this.email);

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'password': password,
    'email': email,
  };
}