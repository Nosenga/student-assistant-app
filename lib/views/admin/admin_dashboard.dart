import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:student_assistant_app/viewmodels/applications_viewmodel.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _filterStatus = 'all'; // 'all', 'pending', 'approved', 'rejected'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadApplications();
    });
  }

  Future<void> _loadApplications() async {
    await context.read<ApplicationsViewModel>().loadAllApplications();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ApplicationsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          // Filter dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterStatus = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Applications')),
              const PopupMenuItem(value: 'pending', child: Text('Pending')),
              const PopupMenuItem(value: 'approved', child: Text('Approved')),
              const PopupMenuItem(value: 'rejected', child: Text('Rejected')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.applications.isEmpty
              ? const Center(child: Text('No applications found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.applications.length,
                  itemBuilder: (context, index) {
                    final app = vm.applications[index];
                    final status = app['status'] ?? 'pending';
                    
                    // Apply filter
                    if (_filterStatus != 'all' && status.toLowerCase() != _filterStatus) {
                      return const SizedBox.shrink();
                    }
                    
                    final studentEmail = app['profiles']?['email'] ?? 'Unknown email';
                    final studentId = app['user_id'] ?? 'Unknown';
                    final yearOfStudy = app['year_of_study'] ?? 'Unknown';
                    final modules = app['module_applications'] as List<dynamic>? ?? [];
                    final createdAt = app['created_at'] != null
                        ? DateTime.parse(app['created_at']).toLocal().toString().substring(0, 16)
                        : 'Unknown date';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(status),
                          child: Text(
                            status[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          studentEmail,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Year: $yearOfStudy'),
                            Text('Status: ${status.toUpperCase()}'),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(status.toUpperCase()),
                          backgroundColor: _getStatusColor(status).withOpacity(0.2),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Student Details
                                const Text(
                                  'Student Details',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow('Student ID', studentId),
                                _buildInfoRow('Year of Study', yearOfStudy),
                                _buildInfoRow('Submitted', createdAt),
                                
                                const SizedBox(height: 16),
                                
                                // Modules
                                const Text(
                                  'Applied Modules',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ...modules.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final module = entry.value;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Module ${idx + 1}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Level: ${module['academic_level']}'),
                                        Text('Module: ${module['module_name']}'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                
                                const SizedBox(height: 16),
                                
                                // Action Buttons (only for pending applications)
                                if (status.toLowerCase() == 'pending')
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () => _approveApplication(context, app['id']),
                                          icon: const Icon(Icons.check),
                                          label: const Text('Approve'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () => _rejectApplication(context, app['id']),
                                          icon: const Icon(Icons.close),
                                          label: const Text('Reject'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _deleteApplication(context, app['id']),
                                          icon: const Icon(Icons.delete),
                                          label: const Text('Delete'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            side: const BorderSide(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                
                                if (status.toLowerCase() != 'pending')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: OutlinedButton.icon(
                                      onPressed: () => _deleteApplication(context, app['id']),
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Delete Application'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(color: Colors.red),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<void> _approveApplication(BuildContext context, String appId) async {
    final vm = context.read<ApplicationsViewModel>();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Approving application...')),
    );
    
    try {
      await vm.updateStatus(appId, 'approved');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application approved'), backgroundColor: Colors.green),
        );
        await _loadApplications(); // Refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _rejectApplication(BuildContext context, String appId) async {
    final vm = context.read<ApplicationsViewModel>();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rejecting application...')),
    );
    
    try {
      await vm.updateStatus(appId, 'rejected');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application rejected'), backgroundColor: Colors.orange),
        );
        await _loadApplications(); // Refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteApplication(BuildContext context, String appId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Application'),
        content: const Text('Are you sure you want to delete this application? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    final vm = context.read<ApplicationsViewModel>();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deleting application...')),
    );
    
    try {
      await vm.deleteApplication(appId);
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application deleted'), backgroundColor: Colors.red),
        );
        await _loadApplications(); // Refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}