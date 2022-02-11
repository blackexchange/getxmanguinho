import "package:meta/meta.dart";

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';

import '../../../domain/usecases/usecases.dart';

import '../../models/models.dart';
import '../../http/http.dart';

class RemoteLoadSurveyResult implements LoadSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveyResult({@required this.httpClient, @required this.url});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final json = await httpClient.request(url: url, method: 'get');
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
/*
class RemoteLoadSurveyResultParams {
  final String email;
  final String password;

  RemoteLoadSurveyResultParams({@required this.email, @required this.password});

  factory RemoteLoadSurveyResultParams.fromDomain(
          AuthenticationParams params) =>
      RemoteLoadSurveyResultParams(
          email: params.email, password: params.secret);

  Map toJson() => {'email': email, 'password': password};
}
*/
