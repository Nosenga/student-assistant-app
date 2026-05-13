import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicationService {
  final SupabaseClient _client = Supabase.instance.client;

  //submit application
  Future<Map<String, dynamic>> submitApplication({
    required String userId,
    required String yearOfStudy,
    //required bool eligilibilityConfirmed,
    required List<Map<String, dynamic>> modules,
  }) async {

    // Insert application data into 'applications' table
    final applicationResponse = await _client.from('applications').insert({
      'user_id': userId,
      'year_of_study': yearOfStudy,
      //'eligilibility_confirmed': eligilibilityConfirmed,
      'status': 'pending',

    }).select().single();

    final applicationID = applicationResponse['id'];

    // Insert modules data into 'module_applications' table
    for (var module in modules){
      await _client.from('module_applications').insert({
        'application_id': applicationID,
        'module_name': module['name'],
        'academic_level': module['level'],
        'module_order': module['order']
      });
    }

    return applicationResponse;
  }


  //Fetch student's applications
  Future<List<Map<String, dynamic>>> getMyApplications(String userID) async{
    final response = await _client
    .from('applications')
    .select(
      '''*,
      module_applications(*)
      '''
    )
    .eq('user_id', userID)
    .order('created_at', ascending: false);
    return response;
  }

  //Fetch all applications for admin
  Future<List<Map<String, dynamic>>> getAllApplications() async{
    final response = await _client
    .from(
      'applications'
    )
    .select(
      '''*,
      profiles (email),
      module_applications(*)
      '''
    )
    .order(
      'created_at', ascending: false

    );
    return response;
  }

  //Update application status
  Future<void> updateApplicationStatus(int applicationID, String newStatus) async {
    await _client
    .from('applications')
    .update({'status': newStatus})
    .eq('id', applicationID);
  }

  //Delete application(cascade delete modules)
  Future<void> deleteApplication(int applicationID) async {
    await _client
    .from('applications')
    .delete()
    .eq('id', applicationID);
  }

  //Update applications (while pending)
  Future<void> updateApplication(String applicationID, String newStatus) async{
    await _client
    .from('applications')
    .update({'status':newStatus})
    .eq('id', applicationID);
  }

  //Upload file to storage
  Future<String> uploadFile(String userID, String fileName, List<int> bytes) async{
    final filePath = '$userID/$fileName';
    await _client.storage.from('supporting_documents').uploadBinary(filePath, Uint8List.fromList(bytes));
    final publicURL = _client.storage.from('supporting_documents').getPublicUrl(filePath);
    return publicURL;
  }

  //Update application and its modules

}