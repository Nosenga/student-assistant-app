import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () { 
              // Show filter options (e.g., by status, date, etc.)
            },
            icon: Icon(Icons.filter_list),
            ),
          IconButton(
            onPressed: () {
              // Implement logout functionality here
              Navigator.pushReplacementNamed(context, '/login');
            }, 
            icon: Icon( Icons.logout),
            )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildSummaryCard('Total Applications', '120', Colors.blue),
                const SizedBox(width: 16),
                _buildSummaryCard('Pending', '30', Colors.orange),
                const SizedBox(width: 16),
                _buildSummaryCard('Approved', '80', Colors.green),
                const SizedBox(width: 16),
                _buildSummaryCard('Rejected', '10', Colors.red),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor('Pending'),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text('John Doe'),
                    subtitle: Text('Applied for: COS101 - Introduction to Computer Science'),
                    trailing: Chip(
                      label: Text('Pending'), 
                      backgroundColor: Colors.orange.shade100
                      ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Application Details',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow('Email', 'john.doe@example.com'),
                            _buildDetailRow('Year of Study', '2nd Year'),
                            _buildDetailRow('Applied Date', '2023-10-01'),
                            const SizedBox(height: 16),
                            const Text(
                              'Modules Applied For',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('COS101 - Introduction to Computer Science'),
                                  Text('COS102 - Data Structures'),
                                  Text('COS103 - Algorithms'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Supporting Documents',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // Handle download action
                              },
                              icon: const Icon(Icons.file_download),
                              label: const Text('Academic Transcript.pdf'),
                              ),
                              const Divider(),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Handle approve action
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      icon: const Icon(Icons.check),
                                      label: const Text('Approve'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Handle reject action
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      icon: const Icon(Icons.close),
                                      label: const Text('Reject'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: (){}, 
                                      label: Text('Delete'),
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: BorderSide(color: Colors.red),
                                    ),
                                  ), 
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      )
                    ]
                  ),
                );
              },
            )
          )
        ],
      )
    );
  }
}

Widget _buildSummaryCard(String title, String value, Color color){
  return Expanded(
    child: Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: color)),
            const SizedBox(height: 8),
            Text(
              value, 
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              )
            ),
          ],
        ),
      )
    ),
  );
  
}

Widget _buildDetailRow(String label, String value){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(value),
        )
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