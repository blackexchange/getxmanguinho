import 'package:testes/main/composites/composites.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../data/usecases/usecases.dart';
import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(), url: makeApiUrl('surveys'));

LoadSurveys makeLocalLoadSurveys() =>
    LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallBack(
        remote: makeRemoteLoadSurveys(), local: makeLocalLoadSurveys());
