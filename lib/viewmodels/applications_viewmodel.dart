import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/application_service.dart';

class ApplicationsViewModel extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();

  List<Map<String, dynamic>> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> submit({
    required String userId,
    required String yearOfStudy,
    //required bool eligilibilityConfirmed,
    required List<Map<String, dynamic>> modules,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _applicationService.submitApplication(
        userId: userId,
        yearOfStudy: yearOfStudy,
      //  eligilibilityConfirmed: eligilibilityConfirmed,
        modules: modules,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fetch student's applications
  Future<void> loadMyApplications(String userID) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _applications = await _applicationService.getMyApplications(userID);
      
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      
      notifyListeners();
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch all applications for admin
  Future<void> loadAllApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      _applications = await _applicationService.getAllApplications();
      
    } catch (e) {
      _errorMessage = e.toString();
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Update status (Admin)
  Future<void> updateStatus(String applicationID, String newStatus) async {
    

    try {
      await _applicationService.updateApplicationStatus(applicationID as int, newStatus);
      // After updating status, refresh the applications list
      await loadAllApplications();
      
    } catch (e) {
      _errorMessage = e.toString();
      
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Delete application (Admin)
  Future<void> deleteApplication(String applicationID) async {
    try {
      await _applicationService.deleteApplication(applicationID as int);
      // After deleting, refresh the applications list
      await loadAllApplications();
      
    } catch (e) {
      _errorMessage = e.toString();
      
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateApplication({
    required String applicationID,
    required String yearOfStudy,
    required List<Map<String, dynamic>> modules,
    required bool eligibilityConfirmed,
  }) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      await _applicationService.updateApplicationWithModules(
        applicationID: applicationID,
        yearOfStudy: yearOfStudy,
        modules: modules,
        eligibilityConfirmed: eligibilityConfirmed,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e){
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}