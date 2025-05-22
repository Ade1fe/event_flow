import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // You'll need to add this package
import 'package:event_flow/theme/theme.dart';

class EventManagementScreen extends StatefulWidget {
  final String eventId;
  final String eventName;

  const EventManagementScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> attendees =
      []; // This would be populated from your backend
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Simulate loading attendees
    _loadAttendees();
  }

  Future<void> _loadAttendees() async {
    // In a real app, you would fetch this data from your backend
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      attendees = [
        {
          'id': '1',
          'name': 'John Doe',
          'email': 'john@example.com',
          'status': 'Confirmed',
          'checkedIn': true,
        },
        {
          'id': '2',
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'status': 'Confirmed',
          'checkedIn': false,
        },
        {
          'id': '3',
          'name': 'Bob Johnson',
          'email': 'bob@example.com',
          'status': 'Pending',
          'checkedIn': false,
        },
        {
          'id': '4',
          'name': 'Alice Brown',
          'email': 'alice@example.com',
          'status': 'Confirmed',
          'checkedIn': true,
        },
        {
          'id': '5',
          'name': 'Charlie Wilson',
          'email': 'charlie@example.com',
          'status': 'Cancelled',
          'checkedIn': false,
        },
      ];
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // 👈 Custom color
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.eventName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Event Management Tabs
          Container(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Attendees'),
                Tab(text: 'QR Codes'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildAttendeesTab(),
                _buildQRCodesTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add new attendee or scan QR code
          _showAddAttendeeDialog();
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Stats Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Statistics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total',
                        '${attendees.length}',
                        Icons.people,
                      ),
                      _buildStatItem(
                        'Checked In',
                        '${attendees.where((a) => a['checkedIn'] == true).length}',
                        Icons.check_circle,
                      ),
                      _buildStatItem(
                        'Pending',
                        '${attendees.where((a) => a['status'] == 'Pending').length}',
                        Icons.pending,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton('Scan QR', Icons.qr_code_scanner, () {
                  // Navigate to QR scanner
                }),
              ),
              const SizedBox(width: 16),
              // Expanded(
              //   child: _buildActionButton(
              //     'Add Attendee',
              //     Icons.person_add,
              //     _showAddAttendeeDialog,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Send Reminder',
                  Icons.notification_important,
                  () {
                    // Send reminder to attendees
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reminder sent to all attendees')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton('Export List', Icons.download, () {
                  // Export attendee list
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildAttendeesTab() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Search and filter bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search attendees...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              // Filter attendees
            },
          ),
        ),

        // Attendee list
        Expanded(
          child: ListView.builder(
            itemCount: attendees.length,
            itemBuilder: (context, index) {
              final attendee = attendees[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        attendee['checkedIn']
                            ? Colors.green.shade100
                            : Colors.grey.shade200,
                    child: Icon(
                      attendee['checkedIn'] ? Icons.check : Icons.person,
                      color: attendee['checkedIn'] ? Colors.green : Colors.grey,
                    ),
                  ),
                  title: Text(attendee['name']),
                  subtitle: Text(attendee['email']),
                  trailing: PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            child: Text(
                              attendee['checkedIn']
                                  ? 'Mark as not checked in'
                                  : 'Mark as checked in',
                            ),
                            onTap: () {
                              setState(() {
                                attendee['checkedIn'] = !attendee['checkedIn'];
                              });
                            },
                          ),
                          const PopupMenuItem(child: Text('Send message')),
                          const PopupMenuItem(child: Text('Remove attendee')),
                        ],
                  ),
                  onTap: () {
                    // Show attendee details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQRCodesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event QR Code
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Event Registration QR Code',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: QrImageView(
                      data: 'https://event-flow.app/register/${widget.eventId}',
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Share this QR code for easy event registration',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Share QR code
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Download QR code
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Check-in QR Code
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Event Check-in QR Code',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: QrImageView(
                      data: 'https://event-flow.app/checkin/${widget.eventId}',
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Use this QR code at the event entrance for check-ins',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Share QR code
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Download QR code
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAttendeeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Attendee'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter attendee name',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter attendee email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add attendee logic
                  Navigator.pop(context);
                  setState(() {
                    attendees.add({
                      'id': '${attendees.length + 1}',
                      'name': 'New Attendee',
                      'email': 'new@example.com',
                      'status': 'Pending',
                      'checkedIn': false,
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
