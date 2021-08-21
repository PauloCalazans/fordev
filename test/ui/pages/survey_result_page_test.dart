import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/survey_result/components/components.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
    late SurveyResultPresenterSpy presenter;
    late StreamController<bool> isLoadingController;
    late StreamController<SurveyResultViewModel> surveyResultController;

    void initStreams() {
        isLoadingController = StreamController<bool>();
        surveyResultController = StreamController<SurveyResultViewModel>();
    }

    void mockStreams() {
        when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
        when(() => presenter.surveyResultStream).thenAnswer((_) => surveyResultController.stream);
    }

    void closeStreamns() {
        isLoadingController.close();
        surveyResultController.close();
    }

    Future<void> loadPage(WidgetTester tester) async {
        presenter = SurveyResultPresenterSpy();
        initStreams();
        mockStreams();
        final surveysPage = GetMaterialApp(
            initialRoute: '/survey_result/any_survey_id',
            getPages: [
                GetPage(name: '/survey_result/:survey_id', page: () => SurveyResultPage(presenter))
            ],
        );

        await mockNetworkImagesFor(() async => await tester.pumpWidget(surveysPage));
    }
    
    SurveyResultViewModel makeSurveyResult() => SurveyResultViewModel(
        surveyId: 'Any id', 
        question: 'Question', 
        answers: [
            SurveyAnswerViewModel(
                image: 'Image 0',
                answer: 'Answer 0',
                isCurrentAnswer: true,
                percent: '60%'
            ),
            SurveyAnswerViewModel(
                answer: 'Answer 1',
                isCurrentAnswer: false,
                percent: '40%'
            )
        ]
    );

    tearDown(() {
        closeStreamns();
    });

    testWidgets('Should call LoadSurveyResult on page load', (WidgetTester tester) async {
        await loadPage(tester);

        verify(() => presenter.loadData()).called(1);
    });

    testWidgets('Should handle loading correctly', (WidgetTester tester) async {
        await loadPage(tester);

        isLoadingController.add(true);
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        isLoadingController.add(false);
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Should present error if surveysStream fails', (WidgetTester tester) async {
        await loadPage(tester);

        surveyResultController.addError(UIError.unexpected.description);
        await tester.pump();

        expect(find.text(UIError.unexpected.description), findsOneWidget);
        expect(find.text('Recarregar'), findsOneWidget);
        expect(find.text('Question'), findsNothing);

    });

    testWidgets('Should call LoadSurveyResult on reload button click', (WidgetTester tester) async {
        await loadPage(tester);

        surveyResultController.addError(UIError.unexpected.description);
        await tester.pump();
        await tester.tap(find.text(R.strings.reload));

        verify(() => presenter.loadData()).called(2);
    });

    testWidgets('Should present valid data if surveysStream succeeds', (WidgetTester tester) async {
        await loadPage(tester);

        surveyResultController.add(makeSurveyResult());
        await mockNetworkImagesFor(() async => await tester.pump());

        expect(find.text(UIError.unexpected.description), findsNothing);
        expect(find.text('Recarregar'), findsNothing);
        expect(find.text('Question'), findsOneWidget);
        expect(find.text('Answer 0'), findsOneWidget);
        expect(find.text('Answer 1'), findsOneWidget);
        expect(find.text('60%'), findsOneWidget);
        expect(find.text('40%'), findsOneWidget);
        expect(find.byType(ActiveIcon), findsOneWidget);
        expect(find.byType(DisabledIcon), findsOneWidget);
        final image = tester.widget<Image>(find.byType(Image)).image as NetworkImage;
        expect(image.url, 'Image 0');
    });
}