
import 'dart:convert';

import 'package:flutter/services.dart';

class ContactModel {
  String? title;
  List<UserContactModel>? userTitle;

  ContactModel(
      {this.title,
        this.userTitle});

  ContactModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['userTitle'] != null) {
      userTitle = <UserContactModel>[];
      json['userTitle'].forEach((v) {
        userTitle!.add(UserContactModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (userTitle != null) {
      data['userTitle'] = userTitle!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserContactModel {
  String? uid;
  String? username;
  String? phoneNumber;
  String? image;
  String? description;
  Uint8List? contactImage;
  bool? isRegister;

  UserContactModel(
      {this.uid,
        this.username,
        this.phoneNumber,
        this.image,
        this.description,
        this.contactImage,
        this.isRegister});

  UserContactModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    phoneNumber = json['phoneNumber'];
    image = json['image'];
    description = json['description'];
    contactImage = json['contactImage'];
    isRegister = json['isRegister'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['username'] = username;
    data['phoneNumber'] = phoneNumber;
    data['image'] = image;
    data['description'] = description;
    data['contactImage'] = contactImage;
    data['isRegister'] = isRegister;
    return data;
  }
}

class RegisterContactDetail {
  final String? phone,dialCode;
  final String? name;
  final String id;
  final String? image;
  final String? statusDesc;

  RegisterContactDetail(
      {this.phone, this.name, required this.id, this.image, this.statusDesc, this.dialCode});

  factory RegisterContactDetail.fromJson(Map<String, dynamic> jsonData) {
    return RegisterContactDetail(
      id: jsonData['id'],
      name: jsonData['name'],
      phone: jsonData['phone'],
      statusDesc: jsonData['statusDesc'],
      image: jsonData['image'],
    );
  }

  static Map<String, dynamic> toMap(RegisterContactDetail contact) => {
    'id': contact.id,
    'name': contact.name,
    'phone': contact.phone,
    'image': contact.image,
    'statusDesc': contact.statusDesc,
  };



  static List<RegisterContactDetail> decode(String contacts) =>
      (json.decode(contacts) as List<dynamic>)
          .map<RegisterContactDetail>(
              (item) => RegisterContactDetail.fromJson(item))
          .toList();
}