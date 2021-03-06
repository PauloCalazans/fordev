import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatelessWidget with KeyboardManager, LoadingManager, MainErrorManager, NavigationManager {
  final SignUpPresenter presenter;

  const SignUpPage(this.presenter);

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

                    Headline1(text: R.strings.addAccout),

                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Provider(
                        create: (_) => presenter,
                        child: Form(
                            child: Column(
                              children: [
                                NameInput(),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: EmailInput(),
                                ),

                                PasswordInput(),

                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                                  child: PasswordConfirmationInput(),
                                ),

                                SignUpButton(),
                                TextButton.icon(
                                    onPressed: presenter.goToLogin,
                                    icon: Icon(Icons.login),
                                    label: Text(R.strings.login)
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
