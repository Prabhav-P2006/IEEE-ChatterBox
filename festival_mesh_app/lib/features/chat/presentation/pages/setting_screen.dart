import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../bloc/chat_bloc.dart';

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
              ChatLoaded(:final myId) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.person, size: 80, color: Colors.blue.shade800),
                      ),
                      const SizedBox(height: 20),
                      Text(myId.startsWith("User_") ? "Set your Name" : "Profile",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Mesh ID: ${myId.substring(0, 16)}...", 
                        style: const TextStyle(color: Colors.grey)),
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
                      _buildSettingItem(Icons.security, "Safety Numbers", "Verify mesh encryption"),
                      _buildSettingItem(Icons.notifications, "Notifications", "Mute or change sounds"),
                      _buildSettingItem(Icons.help_outline, "Help", "FAQs and support"),
                      _buildSettingItem(Icons.info_outline, "About", "Festival Mesh v1.0.0"),
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

  Widget _buildSettingItem(IconData icon, String title, String subtitle) {
    return ListTile(
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
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final sp = GetIt.instance<SharedPreferences>();
                await sp.setString('user_name', controller.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Name saved! Restart app to apply to Mesh Engine.")),
                  );
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
