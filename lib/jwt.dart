// To parse this JSON data, do
//
//     final jwtToken = jwtTokenFromJson(jsonString);

import 'dart:convert';

JwtToken jwtTokenFromJson(String str) => JwtToken.fromJson(json.decode(str));

String jwtTokenToJson(JwtToken data) => json.encode(data.toJson());

class JwtToken {
    String? token;

    JwtToken({
        this.token,
    });

    factory JwtToken.fromJson(Map<String, dynamic> json) => JwtToken(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}
