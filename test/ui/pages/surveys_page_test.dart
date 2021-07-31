import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
    testWidgets('Should call LoadSurveys on page load', (WidgetTester tester) async {
        final presenter = SurveysPresenterSpy();
        final surveysPage = GetMaterialApp(
            initialRoute: '/surveys',
            getPages: [
                GetPage(name: '/surveys', page: () => SurveysPage(presenter))
            ],
        );
        await tester.pumpWidget(surveysPage);

        verify(() => presenter.loadData()).called(1);
    });
}