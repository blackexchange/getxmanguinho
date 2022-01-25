import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:testes/data/http/http.dart';
import 'package:testes/domain/helpers/helpers.dart';
import 'package:testes/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteLoadSurveys sut;
  HttpClientSpy httpClient;
  String url;
  List<Map> list;

  list = [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String(),
    },
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String(),
    }
  ];

  // AuthenticationParams params;

  List<Map> mockValidData() => list;

  PostExpectation mockRequest() => when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(List<Map> data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteLoadSurveys(httpClient: httpClient, url: url);
    // params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should rerturn surveys on 200', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpData([
      {'invalid_key': 'invalid_value'}
    ]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
  /*


  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid_key'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
*/
}
