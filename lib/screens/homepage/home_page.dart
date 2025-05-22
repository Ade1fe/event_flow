// import 'package:event_flow/screens/widgets/chat_bubble_card.dart';
// import 'package:event_flow/screens/widgets/event_category_card.dart';
// import 'package:flutter/material.dart';
// import 'package:event_flow/screens/widgets/event_registration_card.dart';
// import 'package:event_flow/screens/widgets/app_header.dart';
// import 'package:event_flow/theme/theme.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppHeader(
//         onMenuPressed: () {},
//         onProfilePressed: () {},
//         title: 'EventFlow',
//         profileImageUrl: 'https://i.pravatar.cc/150?img=8',
//       ),
//       body: SafeArea(
//         child: CustomScrollView(
//           controller: _scrollController,
//           slivers: [
//             // Welcome and Search Section
//             SliverToBoxAdapter(child: _buildWelcomeAndSearchSection()),

//             // Category Tabs - Moved up for better navigation flow
//             SliverToBoxAdapter(child: _buildCategoryTabs()),

//             // Event Categories Carousel - Moved up as it's a primary navigation element
//             SliverToBoxAdapter(child: _buildEventCategoriesSection()),

//             // Featured Event Section - Moved after categories for better content hierarchy
//             SliverToBoxAdapter(child: _buildFeaturedEventSection()),

//             // Your Tickets Section
//             SliverToBoxAdapter(child: _buildTicketsSection()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWelcomeAndSearchSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Welcome text
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Hello, Designer!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               Text(
//                 'Discover amazing events around you',
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),

//           // Search bar moved up for better usability
//           _buildSearchBar(),

//           const SizedBox(height: 15),

//           // Chat bubble moved below search for better flow
//           SizedBox(width: double.infinity, child: ChatBubbleCard()),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 0,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: 'Search events...',
//           prefixIcon: Icon(Icons.search, color: Colors.grey),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryTabs() {
//     return Container(
//       height: 50,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: TabBar(
//         controller: _tabController,
//         isScrollable: false,
//         labelPadding: const EdgeInsets.symmetric(horizontal: 0),
//         indicator: BoxDecoration(
//           color: Theme.of(context).primaryColor,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         indicatorColor: Colors.transparent,
//         dividerColor: Colors.transparent,
//         indicatorSize: TabBarIndicatorSize.tab,
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.black87,
//         tabs: const [
//           Tab(child: Text('All')),
//           Tab(child: Text('Upcoming')),
//           Tab(child: Text('Nearby')),
//           Tab(child: Text('Popular')),
//         ],
//         onTap: (index) {
//           // Add tab switching logic here
//         },
//       ),
//     );
//   }

//   Widget _buildEventCategoriesSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Event Categories',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 15),
//           SizedBox(
//             height: 120, // Slightly reduced height
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 EventCategoryCard(
//                   categoryName: 'Music',
//                   icon: Icons.music_note,
//                   primaryColor: Colors.purple,
//                   onTap: () {},
//                 ),
//                 EventCategoryCard(
//                   categoryName: 'Sports',
//                   icon: Icons.sports,
//                   primaryColor: Colors.green,
//                   onTap: () {},
//                 ),
//                 EventCategoryCard(
//                   categoryName: 'Tech',
//                   icon: Icons.computer,
//                   primaryColor: Colors.blue,
//                   onTap: () {},
//                 ),
//                 EventCategoryCard(
//                   categoryName: 'Art',
//                   icon: Icons.brush,
//                   primaryColor: Colors.orange,
//                   onTap: () {},
//                 ),
//                 EventCategoryCard(
//                   categoryName: 'Food',
//                   icon: Icons.fastfood,
//                   primaryColor: Colors.red,
//                   onTap: () {},
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFeaturedEventSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Featured Event',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   'View all',
//                   style: TextStyle(color: Theme.of(context).primaryColor),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _buildFeaturedEventCard(),
//         ],
//       ),
//     );
//   }

//   Widget _buildFeaturedEventCard() {
//     return GestureDetector(
//       onTap: () {
//         // Add navigation to event details
//       },
//       child: Hero(
//         tag: 'featured-event',
//         child: Container(
//           height: 180,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 spreadRadius: 0,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//             image: DecorationImage(
//               image: NetworkImage('https://i.pravatar.cc/500?img=32'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
//               ),
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'TRENDING',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Tech Conference 2025',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, color: Colors.white70, size: 16),
//                     const SizedBox(width: 4),
//                     Text(
//                       'May 25, 2025',
//                       style: TextStyle(color: Colors.white70, fontSize: 14),
//                     ),
//                     const SizedBox(width: 12),
//                     Icon(Icons.location_on, color: Colors.white70, size: 16),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         '20, Olowu Street, Lagos',
//                         style: TextStyle(color: Colors.white70, fontSize: 14),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTicketsSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Your Tickets',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   'View all',
//                   style: TextStyle(color: Theme.of(context).primaryColor),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           EventRegistrationCard(
//             eventName: 'Tech Conference 2025',
//             attendeeName: 'Tubi Obaloluwa',
//             eventDetails: 'Entrethlsoy',
//             eventLocation: '20, Olowu Street, Lagos',
//             qrData: 'https://event-flow.app/ticket/12345',
//             completionPercentage: 0.7,
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
// import 'package:event_flow/screens/event/event_management_screen.dart';
// import 'package:event_flow/screens/qr/approval_requests_screen.dart';
// import 'package:event_flow/screens/qr/qr_scanner_screen.dart';
// import 'package:event_flow/screens/widgets/chat_bubble_card.dart';
// import 'package:event_flow/screens/widgets/event_category_card.dart';
// import 'package:flutter/material.dart';
// import 'package:event_flow/screens/widgets/event_registration_card.dart';
// import 'package:event_flow/screens/widgets/app_header.dart';
// import 'package:event_flow/theme/theme.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppHeader(
//         onMenuPressed: () {},
//         onProfilePressed: () {},
//         title: 'EventFlow',
//         profileImageUrl: 'https://i.pravatar.cc/150?img=8',
//       ),
//       body: SafeArea(
//         child: CustomScrollView(
//           controller: _scrollController,
//           slivers: [
//             // Welcome and Search Section
//             SliverToBoxAdapter(child: _buildWelcomeAndSearchSection()),

//             // Category Tabs - Moved up for better navigation flow
//             SliverToBoxAdapter(child: _buildCategoryTabs()),

//             // Event Categories Carousel - Moved up as it's a primary navigation element
//             SliverToBoxAdapter(child: _buildEventCategoriesSection()),

//             // Featured Event Section - Moved after categories for better content hierarchy
//             SliverToBoxAdapter(child: _buildFeaturedEventSection()),

//             // Your Tickets Section
//             SliverToBoxAdapter(child: _buildTicketsSection()),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to QR scanner
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder:
//                   (context) => QRScannerScreen(
//                     eventId:
//                         'current-event', // Replace with actual event ID or context
//                   ),
//             ),
//           );
//         },
//         backgroundColor: Theme.of(context).primaryColor,
//         child: const Icon(Icons.qr_code_scanner),
//         tooltip: 'Scan QR Code',
//       ),
//     );
//   }

//   Widget _buildWelcomeAndSearchSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Welcome text
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Hello, Designer!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               Text(
//                 'Discover amazing events around you',
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Navigate to approval requests screen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const ApprovalRequestsScreen(),
//                     ),
//                   );
//                 },
//               ),
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   constraints: const BoxConstraints(
//                     minWidth: 16,
//                     minHeight: 16,
//                   ),
//                   child: const Text(
//                     '3', // This would be dynamic in a real app
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),

//           // Search bar moved up for better usability
//           _buildSearchBar(),

//           const SizedBox(height: 15),

//           // Chat bubble moved below search for better flow
//           SizedBox(width: double.infinity, child: ChatBubbleCard()),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 0,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: 'Search events...',
//           prefixIcon: Icon(Icons.search, color: Colors.grey),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryTabs() {
//     return Container(
//       height: 50,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: TabBar(
//         controller: _tabController,
//         isScrollable: false,
//         labelPadding: const EdgeInsets.symmetric(horizontal: 0),
//         indicator: BoxDecoration(
//           color: Theme.of(context).primaryColor,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         indicatorColor: Colors.transparent,
//         dividerColor: Colors.transparent,
//         indicatorSize: TabBarIndicatorSize.tab,
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.black87,
//         tabs: const [
//           Tab(child: Text('All')),
//           Tab(child: Text('Upcoming')),
//           Tab(child: Text('Nearby')),
//           Tab(child: Text('Popular')),
//         ],
//         onTap: (index) {
//           // Filter events based on selected tab
//           // This would typically update the displayed events
//         },
//       ),
//     );
//   }

//   Widget _buildEventCategoriesSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Event Categories',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 15),
//           SizedBox(
//             height: 120, // Slightly reduced height
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 EventCategoryCard(
//                   categoryName: 'Music',
//                   icon: Icons.music_note,
//                   primaryColor: Colors.purple,
//                   onTap: () {
//                     // Navigate to music events or filter by music category
//                   },
//                 ),
//                 EventCategoryCard(
//                   categoryName: 'Sports',
//                   icon: Icons.sports,
//                   primaryColor: Colors.green,
//                   onTap: () {
//                     // Navigate to sports events or filter by sports category
//                   },
//                 ),
//                 EventCategoryCard(
//                   categoryName: 'Tech',
//                   icon: Icons.computer,
//                   primaryColor: Colors.blue,
//                   onTap: () {
//                     // Navigate to tech events or filter by tech category
//                   },
//                 ),
//                 EventCategoryCard(
//                   categoryName: 'Art',
//                   icon: Icons.brush,
//                   primaryColor: Colors.orange,
//                   onTap: () {
//                     // Navigate to art events or filter by art category
//                   },
//                 ),
//                 EventCategoryCard(
//                   categoryName: 'Food',
//                   icon: Icons.fastfood,
//                   primaryColor: Colors.red,
//                   onTap: () {
//                     // Navigate to food events or filter by food category
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFeaturedEventSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Featured Event',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // Navigate to all featured events
//                 },
//                 child: Text(
//                   'View all',
//                   style: TextStyle(color: Theme.of(context).primaryColor),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _buildFeaturedEventCard(),
//         ],
//       ),
//     );
//   }

//   Widget _buildFeaturedEventCard() {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to event details with management options
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (context) => EventManagementScreen(
//                   eventId: 'event-123', // Replace with actual event ID
//                   eventName: 'Tech Conference 2025',
//                 ),
//           ),
//         );
//       },
//       child: Hero(
//         tag: 'featured-event',
//         child: Container(
//           height: 180,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 spreadRadius: 0,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//             image: DecorationImage(
//               image: NetworkImage('https://i.pravatar.cc/500?img=32'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
//               ),
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'TRENDING',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Tech Conference 2025',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, color: Colors.white70, size: 16),
//                     const SizedBox(width: 4),
//                     Text(
//                       'May 25, 2025',
//                       style: TextStyle(color: Colors.white70, fontSize: 14),
//                     ),
//                     const SizedBox(width: 12),
//                     Icon(Icons.location_on, color: Colors.white70, size: 16),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         '20, Olowu Street, Lagos',
//                         style: TextStyle(color: Colors.white70, fontSize: 14),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Add a subtle indicator that this is tappable
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 8),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.people, color: Colors.white, size: 14),
//                         const SizedBox(width: 4),
//                         Text(
//                           'Manage',
//                           style: TextStyle(color: Colors.white, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTicketsSection() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Your Tickets',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // Navigate to all tickets/events
//                 },
//                 child: Text(
//                   'View all',
//                   style: TextStyle(color: Theme.of(context).primaryColor),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           GestureDetector(
//             onTap: () {
//               // Navigate to event management for this specific ticket
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder:
//                       (context) => EventManagementScreen(
//                         eventId: 'ticket-123', // Replace with actual ticket ID
//                         eventName: 'Tech Conference 2025',
//                       ),
//                 ),
//               );
//             },
//             child: EventRegistrationCard(
//               eventName: 'Tech Conference 2025',
//               attendeeName: 'Tubi Obaloluwa',
//               eventDetails: 'Entrethlsoy',
//               eventLocation: '20, Olowu Street, Lagos',
//               qrData: 'https://event-flow.app/ticket/12345',
//               completionPercentage: 0.7,
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Add a "Create Event" button
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 // Navigate to event creation screen
//                 // This would be a new screen you'd need to create
//               },
//               icon: const Icon(Icons.add_circle_outline),
//               label: const Text('Create New Event'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 backgroundColor: Theme.of(context).primaryColor,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // You could also add a method to create events
//   void _showCreateEventDialog() {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Create New Event'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   decoration: const InputDecoration(
//                     labelText: 'Event Name',
//                     hintText: 'Enter event name',
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   decoration: const InputDecoration(
//                     labelText: 'Location',
//                     hintText: 'Enter event location',
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   decoration: const InputDecoration(
//                     labelText: 'Date',
//                     hintText: 'YYYY-MM-DD',
//                   ),
//                   keyboardType: TextInputType.datetime,
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Create event logic
//                   Navigator.pop(context);
//                   // Navigate to the new event management screen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => EventManagementScreen(
//                             eventId:
//                                 'new-event-${DateTime.now().millisecondsSinceEpoch}',
//                             eventName:
//                                 'New Event', // This would be the entered name
//                           ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                 ),
//                 child: const Text('Create'),
//               ),
//             ],
//           ),
//     );
//   }
// }
import 'package:event_flow/screens/event/event_management_screen.dart';
import 'package:event_flow/screens/qr/approval_requests_screen.dart';
import 'package:event_flow/screens/qr/qr_scanner_screen.dart';
import 'package:event_flow/screens/widgets/chat_bubble_card.dart';
import 'package:event_flow/screens/widgets/event_category_card.dart';
import 'package:flutter/material.dart';
import 'package:event_flow/screens/widgets/event_registration_card.dart';
import 'package:event_flow/screens/widgets/app_header.dart';
import 'package:event_flow/theme/theme.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        onMenuPressed: () {},
        onProfilePressed: () {},
        title: 'EventFlow',
        profileImageUrl: 'https://i.pravatar.cc/150?img=8',
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Welcome and Search Section
            SliverToBoxAdapter(child: _buildWelcomeAndSearchSection()),

            // Category Tabs
            SliverToBoxAdapter(child: _buildCategoryTabs()),

            // Event Categories Carousel
            SliverToBoxAdapter(child: _buildEventCategoriesSection()),

            // Featured Event Section
            SliverToBoxAdapter(child: _buildFeaturedEventSection()),

            // Your Tickets Section
            SliverToBoxAdapter(child: _buildTicketsSection()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to QR scanner
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => QRScannerScreen(
                    eventId:
                        'current-event', // Replace with actual event ID or context
                  ),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.qr_code_scanner),
        tooltip: 'Scan QR Code',
      ),
    );
  }

  Widget _buildWelcomeAndSearchSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome text and notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hello, Designer!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Discover amazing events around you',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Search bar
          _buildSearchBar(),

          const SizedBox(height: 15),

          // Chat bubble
          SizedBox(width: double.infinity, child: ChatBubbleCard()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search events...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 0),
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black87,
        tabs: const [
          Tab(child: Text('All')),
          Tab(child: Text('Upcoming')),
          Tab(child: Text('Nearby')),
          Tab(child: Text('Popular')),
        ],
        onTap: (index) {
          // Filter events based on selected tab
          // This would typically update the displayed events
        },
      ),
    );
  }

  Widget _buildEventCategoriesSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all categories
                },
                child: Text(
                  'See all',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 110, // Slightly reduced height
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                EventCategoryCard(
                  categoryName: 'Music',
                  icon: Icons.music_note,
                  primaryColor: Colors.purple,
                  onTap: () {
                    // Navigate to music events or filter by music category
                  },
                ),
                EventCategoryCard(
                  categoryName: 'Sports',
                  icon: Icons.sports,
                  primaryColor: Colors.green,
                  onTap: () {
                    // Navigate to sports events or filter by sports category
                  },
                ),
                EventCategoryCard(
                  categoryName: 'Tech',
                  icon: Icons.computer,
                  primaryColor: Colors.blue,
                  onTap: () {
                    // Navigate to tech events or filter by tech category
                  },
                ),
                EventCategoryCard(
                  categoryName: 'Art',
                  icon: Icons.brush,
                  primaryColor: Colors.orange,
                  onTap: () {
                    // Navigate to art events or filter by art category
                  },
                ),
                EventCategoryCard(
                  categoryName: 'Food',
                  icon: Icons.fastfood,
                  primaryColor: Colors.red,
                  onTap: () {
                    // Navigate to food events or filter by food category
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedEventSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Event',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all featured events
                },
                child: Text(
                  'View all',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildFeaturedEventCard(),
        ],
      ),
    );
  }

  Widget _buildFeaturedEventCard() {
    return GestureDetector(
      onTap: () {
        // Navigate to event details with management options
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => EventManagementScreen(
                  eventId: 'event-123', // Replace with actual event ID
                  eventName: 'Tech Conference 2025',
                ),
          ),
        );
      },
      child: Hero(
        tag: 'featured-event',
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/500?img=32'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'TRENDING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tech Conference 2025',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'May 25, 2025',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.location_on, color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '20, Olowu Street, Lagos',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Add a subtle indicator that this is tappable
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Manage',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketsSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Tickets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all tickets/events
                },
                child: Text(
                  'View all',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          GestureDetector(
            // onTap: () {
            //   // Navigate to event management for this specific ticket
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder:
            //           (context) => EventManagementScreen(
            //             eventId: 'ticket-123', // Replace with actual ticket ID
            //             eventName: 'Tech Conference 2025',
            //           ),
            //     ),
            //   );
            // },
            onTap: () {
              // Navigate to event management for this specific ticket using GoRouter
              context.go(
                '/event/ticket-123?eventName=${Uri.encodeComponent('Tech Conference 2025')}',
              );
            },
            child: EventRegistrationCard(
              eventName: 'Tech Conference 2025',
              attendeeName: 'Tubi Obaloluwa',
              eventDetails: 'Entrethlsoy',
              eventLocation: '20, Olowu Street, Lagos',
              qrData: 'https://event-flow.app/ticket/12345',
              completionPercentage: 0.7,
            ),
          ),
          const SizedBox(height: 20),

          // Add a "Create Event" button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                // Show create event dialog
                _showCreateEventDialog();
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create New Event'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Create event dialog
  void _showCreateEventDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create New Event'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                      hintText: 'Enter event name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      hintText: 'Enter event location',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      hintText: 'YYYY-MM-DD',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter event description',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Create event logic
                  Navigator.pop(context);
                  // Navigate to the new event management screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EventManagementScreen(
                            eventId:
                                'new-event-${DateTime.now().millisecondsSinceEpoch}',
                            eventName:
                                'New Event', // This would be the entered name
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }
}
