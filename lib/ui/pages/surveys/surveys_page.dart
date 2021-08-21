import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys)),
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if(isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          presenter.loadData();

          presenter.navigateToStream!.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.toNamed(page!);
            }
          });

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

