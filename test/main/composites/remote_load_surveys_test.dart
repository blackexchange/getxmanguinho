import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:testes/data/usecases/usecases.dart';
import 'package:testes/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:testes/domain/helpers/domain_error.dart';
import 'package:testes/main/composites/composites.dart';

class RemoteLoadSurveySpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveySpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveySpy remote;
  LocalLoadSurveySpy local;
  RemoteLoadSurveysWithLocalFallBack sut;
  List<SurveyEntity> remoteSurveys;
  List<SurveyEntity> localSurveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: faker.date.dateTime(),
            didAnswer: faker.randomGenerator.boolean())
      ];

  PostExpectation mockRemoteLoadCall() => when(remote.load());
  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  PostExpectation mockLocalLoadCall() => when(local.load());

  void mockLocalLoad() {
    localSurveys = mockSurveys();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  void mockLocalLoadError() =>
      mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveySpy();
    local = LocalLoadSurveySpy();
    sut = RemoteLoadSurveysWithLocalFallBack(remote: remote, local: local);
    mockRemoteLoad();
    mockLocalLoad();
  });
  test('SHould call remote load', () async {
    await sut.load();
    verify(remote.load()).called(1);
  });

  test('SHould call Local load', () async {
    await sut.load();
    verify(local.save(remoteSurveys)).called(1);
  });

  test('SHould return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('SHould rethrow if remote load throwhs access denied', () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('SHould call local fetch on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);
    await sut.load();

    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  });

  test('SHould return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);
    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('SHould throw unexpected if remote and local throw', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
