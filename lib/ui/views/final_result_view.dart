import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';
import 'package:test_reader_patient_app/core/viewmodels/final_result_viewmodel.dart';
import 'package:test_reader_patient_app/ui/constants/colors.dart';
import 'package:test_reader_patient_app/ui/constants/margins.dart';
import 'package:test_reader_patient_app/ui/constants/text_sizes.dart';
import 'package:test_reader_patient_app/ui/constants/ui_helpers.dart';
import 'package:test_reader_patient_app/ui/widgets/custom_button.dart';
import 'package:test_reader_patient_app/ui/widgets/custom_loading_indicator.dart';
import 'package:test_reader_patient_app/ui/widgets/test_data_tile.dart';

class FinalResultView extends StatelessWidget {
  final List<String> qrResult;
  final bool testResult;
  final String imageUrl;

  FinalResultView(
      {@required this.qrResult,
      @required this.testResult,
      @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FinalResultViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: pageHorizontalMargin,
                          vertical: pageVerticalMargin),
                      child: model.result == null
                          ? Container(
                              child: smallSpace,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                largeSpace,
                                Text(
                                  'Test results',
                                  style: largeTextFont,
                                ),
                                smallSpace,
                                Text(
                                  model.result.date,
                                  style: smallTextFont,
                                ),
                                mediumSpace,
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(MaterialCommunityIcons.test_tube,
                                          size: 40,
                                          color: model.result.isPositive
                                              ? Colors.green
                                              : Colors.redAccent),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                        child: testDataTile(
                                            field: 'Test result',
                                            fieldValue: model.result.isPositive
                                                ? 'Positive (+)'
                                                : 'Negative (-)'),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Select Clinic',
                                    style: smallTextFont,
                                  ),
                                ),
                                Container(
                                  height: 65,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                      color:
                                          HexColor('#3b3941').withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.white70, width: 0.3)),
                                  child: DropdownButton(
                                      isExpanded: true,
                                      dropdownColor: Colors.green,
                                      style: smallTextFont.copyWith(
                                          color: Colors.white),
                                      underline: SizedBox(
                                        height: 1,
                                      ),
                                      items:
                                          model.availableClinics.map((clinic) {
                                        return DropdownMenuItem(
                                          child: new Text(clinic.name,
                                              style: smallTextFont),
                                          value: clinic,
                                        );
                                      }).toList(),
                                      value: model.selectedClinic,
                                      onChanged: model.updateSelectedClinic),
                                ),
                                testDataTile(
                                    field: 'Test ID',
                                    fieldValue: model.result.testID),
                                testDataTile(
                                    field: 'Sample ID',
                                    fieldValue: model.result.sampleID),
                                testDataTile(
                                    field: 'Lot ID',
                                    fieldValue: model.result.lotID),
                                testDataTile(
                                    field: 'Patient ID',
                                    fieldValue: model.result.patientID),
                                testDataTile(
                                    field: 'Patient name',
                                    fieldValue: model.result.name),
                                testDataTile(
                                    field: 'Patient surname',
                                    fieldValue: model.result.surname),
                                testDataTile(
                                    field: 'Location',
                                    fieldValue: model.result.gpsLocation),
                                largeSpace,
                                customButton(
                                    'Save Results',
                                    model.result == null
                                        ? null
                                        : model.saveResult)
                              ],
                            ),
                    ),
                  ),
                  loadingIndicator(model.result == null, 'Finalizing results'),
                  loadingIndicator(model.isBusy, 'Uploading results..')
                ],
              ),
            ),
        onModelReady: (model) =>
            model.initialise(qrResult, testResult, imageUrl),
        viewModelBuilder: () => FinalResultViewModel());
  }
}
