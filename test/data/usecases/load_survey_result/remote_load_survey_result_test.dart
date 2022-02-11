import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:testes/data/http/http.dart';
import 'package:testes/domain/entities/entities.dart';
import 'package:testes/domain/helpers/helpers.dart';
import 'package:testes/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteLoadSurveyResult sut;
  HttpClientSpy httpClient;
  String url;
  Map surveyResult;

  surveyResult = {
    'surveyId': faker.guid.guid(),
    'question': faker.randomGenerator.string(50),
    'answers': [
      {
        'image': faker.internet.httpUrl(),
        'answer': faker.randomGenerator.string(20),
        'percent': faker.randomGenerator.integer(100),
        'count': faker.randomGenerator.integer(1000),
        'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
      },
      {
        'answer': faker.randomGenerator.string(20),
        'percent': faker.randomGenerator.integer(100),
        'count': faker.randomGenerator.integer(1000),
        'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
      }
    ],
    'date': faker.date.dateTime().toIso8601String(),
  };

  // AuthenticationParams params;

  Map mockValidData() => surveyResult;

  PostExpectation mockRequest() => when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteLoadSurveyResult(httpClient: httpClient, url: url);
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey();

    verify(httpClient.request(url: url, method: 'get'));
  });
  test('Should return surveyResult on 200', () async {
    final result = await sut.loadBySurvey();

    expect(
        result,
        SurveyResultEntity(
            surveyId: surveyResult['surveyId'],
            question: surveyResult['question'],
            answers: [
              SurveyAnswerEntity(
                  image: surveyResult['answers'][0]['image'],
                  answer: surveyResult['answers'][0]['answer'],
                  isCurrentAnswer: surveyResult['answers'][0]
                      ['isCurrentAccountAnswer'],
                  percent: surveyResult['answers'][0]['percent']),
              SurveyAnswerEntity(
                  answer: surveyResult['answers'][1]['answer'],
                  isCurrentAnswer: surveyResult['answers'][1]
                      ['isCurrentAccountAnswer'],
                  percent: surveyResult['answers'][1]['percent'])
            ]));
  });
  /*
  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpData([
      {'invalid_key': 'invalid_value'}
    ]);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });
*/
  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.loadBySurvey();

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
