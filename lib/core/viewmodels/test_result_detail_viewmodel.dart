import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_reader_patient_app/core/models/test_result.dart';
import 'package:test_reader_patient_app/locator.dart';
import 'package:test_reader_patient_app/ui/constants/enums.dart';

class TestResultDetailViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final TestResult result;

  TestResultDetailViewModel({@required this.result});

  void showTestResultImage() => _dialogService.showCustomDialog(
      variant: DialogType.viewTestPicture, title: result.testResultPicUrl);
}
