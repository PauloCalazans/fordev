import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
    late SurveysPresenterSpy presenter;
    late StreamController<bool> isLoadingController;
    late StreamController<List<SurveyViewModel>?> loadSurveysController;

    void initStreams() {
        isLoadingController = StreamController<bool>();
        loadSurveysController = StreamController<List<SurveyViewModel>>();
    }

    void mockStreams() {
        when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
        when(() => presenter.loadSurveysStream).thenAnswer((_) => loadSurveysController.stream);
    }

    void closeStreamns() {
        isLoadingController.close();
        loadSurveysController.close();
    }

    Future<void> loadPage(WidgetTester tester) async {
        presenter = SurveysPresenterSpy();
        initStreams();
        mockStreams();
        final surveysPage = GetMaterialApp(
            initialRoute: '/surveys',
            getPages: [
                GetPage(name: '/surveys', page: () => SurveysPage(presenter))
            ],
        );
        await tester.pumpWidget(surveysPage);
    }

    tearDown(() {
        closeStreamns();
    });

    testWidgets('Should call LoadSurveys on page load', (WidgetTester tester) async {
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

    testWidgets('Should present error if loadSurveysStream fails', (WidgetTester tester) async {
        await loadPage(tester);

        loadSurveysController.addError(UIError.unexpected.description);
        await tester.pump();

        expect(find.text(UIError.unexpected.description), findsOneWidget);
        expect(find.text('Recarregar'), findsOneWidget);
        expect(find.text('Question 1'), findsNothing);
    });
}