import 'package:flutter/material.dart';
import '../survey_result.dart';
import 'components.dart';

class SuveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  SuveyResult(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: viewModel.answers.length + 1,
        itemBuilder: (context, index) {
          if(index == 0) {
            return SurveyHeader(viewModel.question);
          }

          return SurveyAnswer(viewModel.answers[index - 1]);
        }
    );
  }
}