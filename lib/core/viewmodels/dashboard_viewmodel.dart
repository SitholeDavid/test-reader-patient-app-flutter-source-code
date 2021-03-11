import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service.dart';
import 'package:test_reader_patient_app/core/services/auth_service/auth_service_interface.dart';
import 'package:test_reader_patient_app/locator.dart';
import 'package:test_reader_patient_app/ui/constants/routes.dart';

class DashboardViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthServiceInterface>();

  void navigateToScanQRCodeView() =>
      _navigationService.navigateTo(ScanQRCodeViewRoute);

  void navigateToMyResultsView() =>
      _navigationService.navigateTo(MyResultsViewRoute);

  void signOut() async {
    await _authService.signOut();
    _navigationService.clearStackAndShow(SignInViewRoute);
  }
}
