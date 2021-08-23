import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';
import 'package:fordev/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
    late SurveysPresenterSpy presenter;
    late StreamController<bool> isLoadingController;
    late StreamController<List<SurveyViewModel>?> surveysController;
    late StreamController<String?> navigateToController;
    late StreamController<bool> isSessionExpiredController;

    void initStreams() {
        isLoadingController = StreamController<bool>();
        surveysController = StreamController<List<SurveyViewModel>>();
        navigateToController = StreamController<String?>();
        isSessionExpiredController = StreamController<bool>();
    }

    void mockStreams() {
        when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
        when(() => presenter.surveysStream).thenAnswer((_) => surveysController.stream);
        when(() => presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
        when(() => presenter.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
    }

    void closeStreamns() {
        isLoadingController.close();
        surveysController.close();
        navigateToController.close();
        isSessionExpiredController.close();
    }

    Future<void> loadPage(WidgetTester tester) async {
        presenter = SurveysPresenterSpy();
        initStreams();
        mockStreams();
        final surveysPage = GetMaterialApp(
            initialRoute: '/surveys',
            getPages: [
                GetPage(name: '/surveys', page: () => SurveysPage(presenter)),
                GetPage(name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
                GetPage(name: '/login', page: () => Scaffold(body: Text('fake login'))),
            ],
        );
        await tester.pumpWidget(surveysPage);
    }

    List<SurveyViewModel> makeSurveys() {
        return [
            SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
            SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
        ];
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

    testWidgets('Should present error if surveysStream fails', (WidgetTester tester) async {
        await loadPage(tester);

        surveysController.addError(UIError.unexpected.description);
        await tester.pump();

        expect(find.text(UIError.unexpected.description), findsOneWidget);
        expect(find.text('Recarregar'), findsOneWidget);
        expect(find.text('Question 1'), findsNothing);
    });

    testWidgets('Should present list if surveysStream succeeds', (WidgetTester tester) async {
        await loadPage(tester);

        surveysController.add(makeSurveys());
        await tester.pump();

        expect(find.text(UIError.unexpected.description), findsNothing);
        expect(find.text('Recarregar'), findsNothing);
        expect(find.text('Question 1'), findsWidgets);
        expect(find.text('Question 2'), findsWidgets);
        expect(find.text('Date 1'), findsWidgets);
        expect(find.text('Date 2'), findsWidgets);
    });

    testWidgets('Should call LoadSurveys on reload button click', (WidgetTester tester) async {
        await loadPage(tester);

        surveysController.addError(UIError.unexpected.description);
        await tester.pump();
        await tester.tap(find.text(R.strings.reload));

        verify(() => presenter.loadData()).called(2);
    });

    testWidgets('Should call gotoSurveyResult on survey click', (WidgetTester tester) async {
        await loadPage(tester);

        surveysController.add(makeSurveys());
        await tester.pump();

        await tester.tap(find.text('Question 1'));
        await tester.pump();

        verify(() => presenter.goToSurveyResult('1')).called(1);
    });

    testWidgets('Should change page', (WidgetTester tester) async {
        await loadPage(tester);

        navigateToController.add('/any_route');
        await tester.pumpAndSettle();

        expect(Get.currentRoute, '/any_route');
        expect(find.text('fake page'), findsOneWidget);
    });

    testWidgets('Should logout', (WidgetTester tester) async {
        await loadPage(tester);

        isSessionExpiredController.add(true);
        await tester.pumpAndSettle();

        expect(Get.currentRoute, '/login');
        expect(find.text('fake login'), findsOneWidget);
    });

    testWidgets('Should not logout', (WidgetTester tester) async {
        await loadPage(tester);

        isSessionExpiredController.add(false);
        await tester.pumpAndSettle();

        expect(Get.currentRoute, '/surveys');
    });
}