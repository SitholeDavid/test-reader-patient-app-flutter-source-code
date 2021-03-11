import 'package:test_reader_patient_app/core/models/patient.dart';

abstract class AuthServiceInterface {
  Future<Patient> getCurrentUser();
  Future<bool> signInWithEmail(String email, String password);
  Future<bool> signUpWithEmail(
      String email, String password, String name, String surname);
  Future<String> signUpClientWithEmail(String email, String password);
  Future<bool> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<bool> isUserLoggedIn();
}
