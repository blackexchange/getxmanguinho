import "package:meta/meta.dart";

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';

import '../../../domain/usecases/usecases.dart';

import '../../models/models.dart';
import '../../http/http.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient<List<Map>> httpClient;
  final String url;

  RemoteLoadSurveys({@required this.httpClient, @required this.url});
  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');
      return httpResponse
          .map((json) => RemoteSurveysModel.fromJson(json).toEntity())
          .toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}

class RemoteLoadSurveysParams {
  final String email;
  final String password;

  RemoteLoadSurveysParams({@required this.email, @required this.password});

  factory RemoteLoadSurveysParams.fromDomain(AuthenticationParams params) =>
      RemoteLoadSurveysParams(email: params.email, password: params.secret);

  Map toJson() => {'email': email, 'password': password};
}
