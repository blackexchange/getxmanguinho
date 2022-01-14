import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:testes/data/usecases/usecases.dart';
import 'package:testes/domain/helpers/helpers.dart';

import 'package:testes/data/cache/cache.dart';
import 'package:testes/domain/entities/entities.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;
  String token;

  PostExpectation mockFetchSecureCall() =>
      when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return an Accontity', () async {
    final account = await sut.load();
    expect(account, AccountEntity(token: token));
  });

  test('Should throw unexpected error if fetchSecureCacheStorage throw',
      () async {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
