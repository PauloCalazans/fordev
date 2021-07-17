import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = RxnString();

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Future<void>? checkAccount() async {
    await loadCurrentAccount.load();
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  test('Should call LoadCurrentAccount', () async {
    final loadCurrentAccount = LoadCurrentAccountSpy();
    final sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);

    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });
}