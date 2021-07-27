import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../components/components.dart';
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

            presenter.isLoadingStream!.listen((isLoading) {
              if(isLoading == true) {
                showLoading(context);
              } else {
                hideLoading(context);
              }
            });

            presenter.mainErrorStream!.listen((error) {
              if (error != null) {
                showErrorMessage(context, error.description);
              }
            });

            presenter.navigateToStream!.listen((page) {
              if (page?.isNotEmpty == true) {
                Get.offAllNamed(page!);
              }
            });

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
