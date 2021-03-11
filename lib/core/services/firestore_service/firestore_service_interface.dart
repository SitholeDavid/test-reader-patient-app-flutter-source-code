import 'package:test_reader_patient_app/core/models/clinic.dart';
import 'package:test_reader_patient_app/core/models/patient.dart';
import 'package:test_reader_patient_app/core/models/test_result.dart';

abstract class FirestoreServiceInterface {
  Future<bool> createPatient(Patient Patient);
  Future<Patient> getPatient(String patientID);
  Future<bool> updatePatient(Patient Patient);

  Future<bool> uploadResult(TestResult result);
  Future<List<TestResult>> getPatientResults(String patientID);

  Future<List<Clinic>> getClinics();
}
