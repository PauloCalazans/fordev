import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/i18n/i18n.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  const SignUpPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if(!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
    return Scaffold(
      body: Builder(
          builder: (context) {

            return GestureDetector(
              onTap: () => _hideKeyboard,
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
                                    onPressed: () {},
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
