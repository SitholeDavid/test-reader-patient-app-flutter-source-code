import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service_interface.dart';
import 'package:test_reader_patient_app/locator.dart';
import 'package:test_reader_patient_app/ui/constants/routes.dart';

class SignUpViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthServiceInterface>();
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  Future<void> signUp(
      {String email, String password, String name, String surname}) async {
    setBusy(true);
    var success =
        await _authService.signUpWithEmail(email, password, name, surname);

    setBusy(false);
    if (success) {
      _snackbarService.showSnackbar(
          message: 'Sign up successful', duration: Duration(seconds: 2));

      Future.delayed(Duration(seconds: 2),
          () => _navigationService.clearStackAndShow(DashboardViewRoute));
    } else {
      _snackbarService.showSnackbar(
          message: 'Sign up failed. Please check your details and try again',
          duration: Duration(seconds: 2));
    }
  }
}
