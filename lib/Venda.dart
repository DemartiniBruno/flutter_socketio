// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:flutter/foundation.dart';

class Venda {
  String? id;
  String? description;
  String? value;
  // String? value;
  int? status;

  // Venda.fromJson(Map<dynamic, dynamic> json) :
  //   id = json['id'],
  //   description = json['description'],
  //   value = json['value'],
  //   status = json['status'];
  Venda({
    this.id,
    this.description,
    this.value,
    this.status,
  });

  factory Venda.fromJson(Map<String, dynamic> message) {
    return Venda(
      id: message['id'],
      description: message['description'],
      value: message['value'],
      status: message['status']
    );
  }
}
