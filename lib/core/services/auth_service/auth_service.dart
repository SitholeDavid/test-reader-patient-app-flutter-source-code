import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_reader_patient_app/core/models/patient.dart';
import 'package:test_reader_patient_app/core/services/firestore_service/firestore_service.dart';
import 'package:test_reader_patient_app/core/services/firestore_service/firestore_service_interface.dart';

import '../../../locator.dart';
import 'auth_service_interface.dart';

class AuthService extends AuthServiceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = locator<FirestoreServiceInterface>();

  @override
  Future<Patient> getCurrentUser() async {
    var user = _auth.currentUser;
    if (user == null) return null;
    return await _firestore.getPatient(user.uid);
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    if (await isUserLoggedIn()) {
      await _auth.signOut();
    }
  }

  @override
  Future<bool> signUpWithEmail(
      String email, String password, String name, String surname) async {
    print('email: $email');
    print('password: $password');
    print('name: $name');
    print('surname: $surname');

    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (authResult == null) throw Error();

      var patient = Patient(
          patientID: authResult.user.uid,
          email: email,
          name: name,
          surname: surname);
      var result = await _firestore.createPatient(patient);
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    var user = await getCurrentUser();
    return user != null;
  }

  @override
  Future<String> signUpClientWithEmail(String email, String password) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return authResult.user.uid;
    } catch (e) {
      return null;
    }
  }
}
