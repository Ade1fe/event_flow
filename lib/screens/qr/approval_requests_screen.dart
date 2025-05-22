import 'package:flutter/material.dart';
import 'package:event_flow/theme/theme.dart';

class ApprovalRequest {
  final String id;
  final String eventId;
  final String eventName;
  final String attendeeName;
  final String qrData;
  final DateTime timestamp;
  bool isApproved;
  bool isRejected;

  ApprovalRequest({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.attendeeName,
    required this.qrData,
    required this.timestamp,
    this.isApproved = false,
    this.isRejected = false,
  });
}

class ApprovalRequestsScreen extends StatefulWidget {
  const ApprovalRequestsScreen({super.key});

  @override
  State<ApprovalRequestsScreen> createState() => _ApprovalRequestsScreenState();
}

class _ApprovalRequestsScreenState extends State<ApprovalRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ApprovalRequest> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would fetch data from your backend:
    // final response = await http.get(Uri.parse('https://your-api.com/check-in-requests'));
    // final data = jsonDecode(response.body);

    // Mock data
    setState(() {
      requests = [
        ApprovalRequest(
          id: '1',
          eventId: 'event-123',
          eventName: 'Tech Conference 2025',
          attendeeName: 'John Doe',
          qrData: 'https://event-flow.app/ticket/12345',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        ApprovalRequest(
          id: '2',
          eventId: 'event-123',
          eventName: 'Tech Conference 2025',
          attendeeName: 'Jane Smith',
          qrData: 'https://event-flow.app/ticket/12346',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        ApprovalRequest(
          id: '3',
          eventId: 'event-456',
          eventName: 'Music Festival',
          attendeeName: 'Bob Johnson',
          qrData: 'https://event-flow.app/ticket/78901',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Approval Requests',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: false, // Still works with fixed-width
              indicator: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              labelColor: theme.colorScheme.onPrimary,
              unselectedLabelColor: theme.colorScheme.onSurface,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: const [
                Tab(
                  child: SizedBox(
                    width: 100,
                    child: Center(child: Text('Pending')),
                  ),
                ),
                Tab(
                  child: SizedBox(
                    width: 100,
                    child: Center(child: Text('Approved')),
                  ),
                ),
                Tab(
                  child: SizedBox(
                    width: 100,
                    child: Center(child: Text('Rejected')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              )
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildRequestList(
                    requests
                        .where((r) => !r.isApproved && !r.isRejected)
                        .toList(),
                    isPending: true,
                  ),
                  _buildRequestList(
                    requests.where((r) => r.isApproved).toList(),
                  ),
                  _buildRequestList(
                    requests.where((r) => r.isRejected).toList(),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          _loadRequests();
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildRequestList(
    List<ApprovalRequest> requestList, {
    bool isPending = false,
  }) {
    final theme = Theme.of(context);

    if (requestList.isEmpty) {
      return _buildEmptyState(isPending);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requestList.length,
      itemBuilder: (context, index) {
        final request = requestList[index];
        return _buildRequestCard(request, isPending, theme);
      },
    );
  }

  Widget _buildEmptyState(bool isPending) {
    final theme = Theme.of(context);
    final String statusText =
        isPending
            ? 'No pending requests'
            : 'No ${_tabController.index == 1 ? 'approved' : 'rejected'} requests';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPending
                ? Icons.hourglass_empty
                : _tabController.index == 1
                ? Icons.check_circle
                : Icons.cancel,
            size: 80,
            color: theme.colorScheme.outline.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPending
                ? 'New requests will appear here'
                : 'Requests will appear here after processing',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.outline.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    ApprovalRequest request,
    bool isPending,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildAvatar(request, theme),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.attendeeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        request.eventName,
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildTimestamp(request, theme),
              ],
            ),
            const SizedBox(height: 16),
            _buildQrDataSection(request, theme),
            const SizedBox(height: 16),
            isPending
                ? _buildActionButtons(request)
                : _buildStatusBadge(request, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ApprovalRequest request, ThemeData theme) {
    return Hero(
      tag: 'avatar-${request.id}',
      child: CircleAvatar(
        radius: 24,
        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
        child: Text(
          request.attendeeName.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildTimestamp(ApprovalRequest request, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _formatTimestamp(request.timestamp),
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildQrDataSection(ApprovalRequest request, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.qr_code, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'QR Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            request.qrData,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ApprovalRequest request) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: () => _rejectRequest(request),
          icon: const Icon(Icons.close),
          label: const Text('Reject'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => _approveRequest(request),
          icon: const Icon(Icons.check),
          label: const Text('Approve'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(ApprovalRequest request, ThemeData theme) {
    final isApproved = request.isApproved;
    final backgroundColor = isApproved ? Colors.green[50] : Colors.red[50];
    final textColor = isApproved ? Colors.green[700] : Colors.red[700];
    final iconData = isApproved ? Icons.check_circle : Icons.cancel;
    final statusText = isApproved ? 'Approved' : 'Rejected';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, size: 16, color: textColor),
              const SizedBox(width: 6),
              Text(
                statusText,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      // Format date without using intl package
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      final month = months[timestamp.month - 1];
      final day = timestamp.day;
      final hour =
          timestamp.hour > 12
              ? timestamp.hour - 12
              : timestamp.hour == 0
              ? 12
              : timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = timestamp.hour >= 12 ? 'PM' : 'AM';

      return '$month $day, $hour:$minute $period';
    }
  }

  Future<void> _approveRequest(ApprovalRequest request) async {
    _showLoadingDialog();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would send the approval to your backend:
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/check-in-requests/${request.id}/approve'),
      // );

      // Update local state
      setState(() {
        request.isApproved = true;
        request.isRejected = false;
      });

      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show success message
      _showSnackBar(
        'Request approved successfully',
        Colors.green,
        Icons.check_circle,
      );

      // Switch to the Approved tab
      _tabController.animateTo(1);
    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show error
      _showSnackBar(
        'Error approving request: ${e.toString()}',
        Colors.red,
        Icons.error,
      );
    }
  }

  Future<void> _rejectRequest(ApprovalRequest request) async {
    _showLoadingDialog();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would send the rejection to your backend:
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/check-in-requests/${request.id}/reject'),
      // );

      // Update local state
      setState(() {
        request.isApproved = false;
        request.isRejected = true;
      });

      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show success message
      _showSnackBar('Request rejected', Colors.grey.shade700, Icons.cancel);

      // Switch to the Rejected tab
      _tabController.animateTo(2);
    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show error
      _showSnackBar(
        'Error rejecting request: ${e.toString()}',
        Colors.red,
        Icons.error,
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing...'),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  void _showSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
