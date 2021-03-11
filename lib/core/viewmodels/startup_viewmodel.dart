import 'package:firebase_core/firebase_core.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service_interface.dart';
import 'package:test_reader_patient_app/core/services/camera_service/camera_service.dart';
import 'package:test_reader_patient_app/core/services/camera_service/camera_service_interface.dart';
import 'package:test_reader_patient_app/locator.dart';
import 'package:test_reader_patient_app/ui/constants/routes.dart';

class StartupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final CameraService _cameraService = locator<CameraServiceInterface>();
  AuthService _authService = locator<AuthServiceInterface>();

  Future startupLogic() async {
    var loggedIn = await _authService.isUserLoggedIn();
    await _cameraService.initializeController();

    if (loggedIn) {
      _navigationService.clearStackAndShow(DashboardViewRoute);
    } else {
      _navigationService.clearStackAndShow(SignUpViewRoute);
    }
  }
}
