import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = RxnString();

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Future<void>? checkAccount() async {
    try {
      var account = await loadCurrentAccount.load();
      _navigateTo.value = account == null ? '/login' : '/surveys';
    } catch(error) {
      _navigateTo.value = '/login';
    }
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

}