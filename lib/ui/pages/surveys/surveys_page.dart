import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> with LoadingManager, NavigationManager, SessionManager, RouteAware {

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    widget.presenter.loadData();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>().subscribe(this, ModalRoute.of(context)!);

    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys)),
      body: Builder(
        builder: (context) {
          handleLoading(widget.presenter.isLoadingStream, context);
          handleNavigation(widget.presenter.navigateToStream);
          handleSessionExpired(widget.presenter.isSessionExpiredStream);
          widget.presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>?>(
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              if(snapshot.hasError) {
                return ReloadScreen(
                    error: '${snapshot.error}',
                    reload: widget.presenter.loadData
                );
              }

              if(snapshot.hasData) {
                return Provider(
                  create: (_) => widget.presenter,
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

