import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_reader_patient_app/core/models/patient.dart';
import 'package:test_reader_patient_app/core/models/test_result.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service_interface.dart';
import 'package:test_reader_patient_app/core/services/firestore_service/firestore_service.dart';
import 'package:test_reader_patient_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:test_reader_patient_app/locator.dart';
import 'package:test_reader_patient_app/ui/constants/routes.dart';

class MyResultsViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthServiceInterface>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();

  List<TestResult> myResults;

  void initialise() async {
    setBusy(true);
    Patient myProfile = await _authService.getCurrentUser();
    myResults = await _firestoreService.getPatientResults(myProfile.patientID);
    setBusy(false);
  }

  void navigateToTestResultDetailView({int index}) {
    _navigationService.navigateTo(TestResultDetailViewRoute,
        arguments: myResults[index]);
  }
}
