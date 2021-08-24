import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget with LoadingManager, NavigationManager, SessionManager {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys)),
      body: Builder(
        builder: (context) {
          handleLoading(presenter.isLoadingStream, context);
          presenter.loadData();
          handleNavigation(presenter.navigateToStream);
          handleSessionExpired(presenter.isSessionExpiredStream);

          return StreamBuilder<List<SurveyViewModel>?>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if(snapshot.hasError) {
                return ReloadScreen(
                    error: '${snapshot.error}',
                    reload: presenter.loadData
                );
              }

              if(snapshot.hasData) {
                return Provider(
                  create: (_) => presenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          enlargeCenterPage: true,
                          aspectRatio: 1
                      ),
                      items: snapshot.data?.map((viewModel) => SurveyItem(viewModel)).toList(),
                    ),
                  ),
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

