import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_reader_patient_app/core/models/clinic.dart';
import 'package:test_reader_patient_app/core/models/patient.dart';
import 'package:test_reader_patient_app/core/models/test_result.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service_interface.dart';
import 'package:test_reader_patient_app/core/services/firestore_service/firestore_service.dart';
import 'package:test_reader_patient_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:test_reader_patient_app/core/services/location_service/location_service.dart';
import 'package:test_reader_patient_app/core/services/location_service/location_service_interface.dart';
import 'package:test_reader_patient_app/locator.dart';
import 'package:test_reader_patient_app/ui/constants/routes.dart';

import '../utils.dart';

class FinalResultViewModel extends BaseViewModel {
  final LocationService _locationService = locator<LocationServiceInterface>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();

  List<String> qrResult;
  List<Clinic> availableClinics;
  LocationData location;
  bool testResult;
  TestResult result;
  Patient patient;
  Clinic selectedClinic;

  void initialise(
      List<String> qrResult, bool testResult, String imageUrl) async {
    await _locationService.initialise();
    await getPermissions();

    location = await _locationService.getCurrentLocation();
    patient = await _authService.getCurrentUser();
    availableClinics = await _firestoreService.getClinics();

    if (availableClinics.isNotEmpty)
      selectedClinic = availableClinics[0];
    else
      selectedClinic =
          Clinic(name: 'No clinic selected', clinicID: null, email: null);

    result = TestResult();
    result.name = patient.name ?? 'Not set';
    result.surname = patient.surname ?? 'Not set';
    result.patientID = patient.patientID ?? 'Not set';
    result.testID = qrResult[0] ?? 'Not set';
    result.sampleID = qrResult[1] ?? 'Not set';
    result.lotID = qrResult[2] ?? 'Not set';
    result.isPositive = testResult ?? false;
    result.gpsLocation =
        '${location.latitude + locationOffset()}, ${location.longitude + locationOffset()}';
    result.date = DateFormat('dd MMMM yyyy, hh:mm aaa').format(DateTime.now());
    result.clinicID = selectedClinic.clinicID;
    result.clinicName = selectedClinic.name;
    result.testResultPicUrl = imageUrl;

    notifyListeners();
  }

  void updateSelectedClinic(Clinic newClinic) {
    selectedClinic = newClinic;
    notifyListeners();
  }

  Future getPermissions() async {
    while (!_locationService.hasPermission) {
      await _locationService.requestLocationPermissions();
      if (!_locationService.hasPermission) {
        _snackbarService.showSnackbar(
            message: 'Location permission is required');
      }
    }

    return;
  }

  void saveResult() async {
    setBusy(true);
    result.clinicID = selectedClinic.clinicID;
    result.clinicName = selectedClinic.name;
    bool success = await _firestoreService.uploadResult(result);
    setBusy(false);

    if (success) {
      _snackbarService.showSnackbar(
          message: 'Result successfully uploaded',
          duration: Duration(seconds: 2));

      Future.delayed(Duration(seconds: 2),
          () => _navigationService.clearStackAndShow(DashboardViewRoute));
    } else {
      _snackbarService.showSnackbar(
          message:
              'Result could not be uploaded. Please check your internet connection and try again',
          duration: Duration(seconds: 3));
    }
  }
}
