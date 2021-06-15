import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if(json.containsKey('accessToken')) {
      return RemoteAccountModel(json['accessToken']);
    }

    throw HttpError.invalidData;
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}