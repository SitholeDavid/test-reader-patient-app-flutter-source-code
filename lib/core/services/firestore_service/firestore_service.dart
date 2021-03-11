import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_reader_patient_app/core/models/clinic.dart';
import 'package:test_reader_patient_app/core/models/patient.dart';
import 'package:test_reader_patient_app/core/models/test_result.dart';

import 'firestore_service_interface.dart';

class FirestoreService extends FirestoreServiceInterface {
  CollectionReference _patientsRef =
      FirebaseFirestore.instance.collection('patients');

  CollectionReference _clinicsRef =
      FirebaseFirestore.instance.collection('clinics');

  CollectionReference _resultsRef =
      FirebaseFirestore.instance.collection('results');

  @override
  Future<bool> createPatient(Patient patient) async {
    try {
      await _patientsRef.doc(patient.patientID).set(patient.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Patient> getPatient(String patientID) async {
    try {
      var patientJson = await _patientsRef.doc(patientID).get();
      var patient = Patient.fromMap(patientJson.data(), patientID);
      return patient;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updatePatient(Patient patient) async {
    try {
      await _patientsRef.doc(patient.patientID).update(patient.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> uploadResult(TestResult result) async {
    try {
      await _resultsRef.doc().set(result.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<TestResult>> getPatientResults(String patientID) async {
    try {
      var results =
          await _resultsRef.where('patientID', isEqualTo: patientID).get();

      if (results.docs.isEmpty) return <TestResult>[];

      var formattedResults = results.docs
          .map((result) => TestResult.fromMap(result.data(), result.id))
          .toList();

      return formattedResults;
    } catch (e) {
      return <TestResult>[];
    }
  }

  @override
  Future<List<Clinic>> getClinics() async {
    try {
      var clinicsData = await _clinicsRef.get();
      if (clinicsData.docs.isEmpty) return <Clinic>[];

      var clinics = clinicsData.docs
          .map((clinic) => Clinic.fromMap(clinic.data(), clinic.id))
          .toList();

      return clinics;
    } catch (e) {
      print(e);
      return <Clinic>[];
    }
  }
}
