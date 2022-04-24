class SignInUser {
  String userName;
  String password;

  SignInUser(this.userName, this.password);

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'password': password,
  };
}