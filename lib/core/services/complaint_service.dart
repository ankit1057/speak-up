import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ComplaintService {
  static const String _storageKey = 'user_complaints';

  Future<void> saveComplaint(Map<String, dynamic> complaint) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> complaints = prefs.getStringList(_storageKey) ?? [];
    complaints.add(jsonEncode(complaint));
    await prefs.setStringList(_storageKey, complaints);
  }

  Future<List<Map<String, dynamic>>> getComplaints() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> complaints = prefs.getStringList(_storageKey) ?? [];
    return complaints
        .map((complaint) => jsonDecode(complaint) as Map<String, dynamic>)
        .toList()
        .reversed
        .toList();
  }

  Future<Map<String, int>> getStatistics() async {
    final complaints = await getComplaints();
    int total = complaints.length;
    int inProgress = complaints.where((c) => c['status'] == 'Pending').length;
    int resolved = complaints.where((c) => c['status'] == 'Resolved').length;
    int rejected = complaints.where((c) => c['status'] == 'Rejected').length;

    return {
      'total': total,
      'inProgress': inProgress,
      'resolved': resolved,
      'rejected': rejected,
    };
  }

  Future<void> clearComplaints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}