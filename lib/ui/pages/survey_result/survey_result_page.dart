import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import 'survey_result.dart';

class SurveyResultPage extends StatelessWidget with LoadingManager, SessionManager {
  final SurveyResultPresenter presenter;

  SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys)),
      body: Builder(
        builder: (context) {
          handleLoading(presenter.isLoadingStream, context);
          handleSessionExpired(presenter.isSessionExpiredStream);
          presenter.loadData();

          return StreamBuilder<SurveyResultViewModel?>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {
              if(snapshot.hasError) {
                return ReloadScreen(
                    error: '${snapshot.error}',
                    reload: presenter.loadData
                );
              }

              if(snapshot.hasData) {
                return SuveyResult(
                  viewModel: snapshot.data!,
                  onSave: presenter.save
                );
              }

              return SizedBox.shrink();
            }
          );
        },
      ),
    );
  }
}

