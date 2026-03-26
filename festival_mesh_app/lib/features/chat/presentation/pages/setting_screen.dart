import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import '../bloc/chat_bloc.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import 'package:festival_mesh_app/core/utils/mesh_logger.dart';

@RoutePage()
class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.router.pop(),
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return switch (state) {
              ChatLoaded(:final myId, :final myName) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      myName.isNotEmpty ? myName : "Set your Name",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Mesh ID: ${myId.substring(0, 16)}...",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => _showEditNameDialog(context),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text("Edit Mesh Name"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildSettingItem(
                      Icons.security,
                      "Safety Numbers",
                      "Verify mesh encryption",
                      () {
                        _showSafetyNumbers(context, myId);
                      },
                    ),
                    _buildSettingItem(
                      Icons.notifications,
                      "Notifications",
                      "Mute or change sounds",
                      () {
                        _showNotificationSettings(context);
                      },
                    ),
                    _buildSettingItem(
                      Icons.bug_report_outlined,
                      "Developer Logs",
                      "View mesh traffic",
                      () {
                        _showMeshLogs(context);
                      },
                    ),
                    _buildSettingItem(
                      Icons.help_outline,
                      "Help",
                      "FAQs and support",
                      () {
                        _showHelpDialog(context);
                      },
                    ),
                    _buildSettingItem(
                      Icons.info_outline,
                      "About",
                      "Festival Mesh v1.0.0",
                      () {
                        showAboutDialog(
                          context: context,
                          applicationName: "Festival Mesh",
                          applicationVersion: "1.0.0",
                          applicationIcon: Icon(
                            Icons.hub,
                            color: Colors.blue.shade800,
                          ),
                          children: [
                            const Text(
                              "A decentralized, off-grid messenger using Peer-to-Peer Bluetooth Mesh networking. No internet required!\n\nBuild: 2026.03.26",
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: Colors.blue.shade800),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  void _showSafetyNumbers(BuildContext context, String myId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_user, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Your Safety Number",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "To verify encryption with a peer, compare these numbers. If they match, your connection is secure.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                myId,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Mesh Notifications"),
        content: StatefulBuilder(
          builder: (context, setState) => SwitchListTile(
            title: const Text("Enable Alerts"),
            subtitle: const Text("Receive sound when peers send messages"),
            value: true,
            onChanged: (val) { /* In a real app, save to SharedPreferences here */ },
            activeColor: Colors.blue.shade800,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  void _showMeshLogs(BuildContext context) {
    final logs = MeshLogger().logs;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const Text("Mesh Activity Logs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: logs.isEmpty 
                ? const Center(child: Text("No traffic yet..."))
                : ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(logs[index], style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Mesh Help & FAQ"),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Q: How do I find peers?", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("A: Tap the blue Bluetooth icon on the home screen and wait for devices to appear. Both devices must be scanning."),
              SizedBox(height: 15),
              Text("Q: What is the range?", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("A: Typically 10-30 meters depending on obstacles. Each node acts as a repeater for others!"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Got it")),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Mesh Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter your name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final sp = GetIt.instance<SharedPreferences>();
                await sp.setString('user_name', controller.text);

                // Update DataSource and Bloc
                await GetIt.instance<ChatDataSource>().updateMyName(
                  controller.text,
                );
                if (context.mounted) {
                  context.read<ChatBloc>().add(const ChatEvent.started());
                  Navigator.pop(context);
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
