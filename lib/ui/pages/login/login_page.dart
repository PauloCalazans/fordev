import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget with KeyboardManager, LoadingManager, MainErrorManager, NavigationManager {
  final LoginPresenter presenter;
  
  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Builder(
          builder: (context) {
            handleLoading(presenter.isLoadingStream, context);

            handleError(presenter.mainErrorStream, context);

            handleNavigation(presenter.navigateToStream, clear: true);

            return GestureDetector(
              onTap: () => hideKeyboard(context),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LoginHeader(),

                    Headline1(text: R.strings.login),

                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Provider<LoginPresenter>(
                        create: (_) => presenter,
                        child: Form(
                            child: Column(
                              children: [
                                EmailInput(),

                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                                  child: PasswordInput(),
                                ),

                                LoginButon(),

                                TextButton.icon(
                                    onPressed: presenter.goToSignUp,
                                    icon: Icon(Icons.person),
                                    label: Text(R.strings.addAccout)
                                )
                              ],
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
