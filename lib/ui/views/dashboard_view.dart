import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:test_reader_patient_app/core/viewmodels/dashboard_viewmodel.dart';
import 'package:test_reader_patient_app/ui/constants/margins.dart';
import 'package:test_reader_patient_app/ui/constants/text_sizes.dart';
import 'package:test_reader_patient_app/ui/constants/ui_helpers.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  largeSpace,
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: pageHorizontalMargin,
                        vertical: pageVerticalMargin),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.maxFinite,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: model.signOut,
                        child: Text(
                          'Sign Out',
                          style: mediumTextFont.copyWith(
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  navigationOption(
                      'New Test Result',
                      'Scan and submit a new test result',
                      model.navigateToScanQRCodeView),
                  mediumSpace,
                  navigationOption(
                      'My Test Results',
                      'View and share your previous test results',
                      model.navigateToMyResultsView)
                ],
              ),
            ),
        viewModelBuilder: () => DashboardViewModel());
  }

  Widget navigationOption(
      String title, String subTitle, Function onTapCallback) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black54, width: 3)),
        margin: EdgeInsets.symmetric(horizontal: pageHorizontalMargin),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            smallSpace,
            Text(
              title,
              style: mediumTextFont.copyWith(fontWeight: FontWeight.bold),
            ),
            smallSpace,
            Text(
              subTitle,
              style: smallTextFont,
            ),
            smallSpace
          ],
        ),
      ),
    );
  }
}
