import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:testes/data/cache/cache.dart';
import 'package:testes/data/usecases/save_current_account/local_save_current_account.dart';

import 'package:testes/domain/entities/entities.dart';
import 'package:testes/domain/helpers/helpers.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  void mockError() {
    when(saveSecureCacheStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Should call SaveCachStorage', () async {
    await sut.save(account);

    verify(
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw Unexpected error if SaveCachStorage throws', () async {
    mockError();
    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
