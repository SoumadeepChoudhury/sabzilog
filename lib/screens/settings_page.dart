import 'package:flutter/material.dart';
import 'package:logger/screens/profile_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String current_version_code = '';

  void getVersionCode() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      current_version_code = info.version;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersionCode();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.headlineMedium),

        const SizedBox(height: 24),

        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: const Text('Profile'),
            subtitle: const Text('Edit your personal information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        Text('About', style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 8),

        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                subtitle: Text(current_version_code),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () async {
                  await launchUrl(
                    Uri.parse('https://sabzilog.netlify.app/privacy'),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms & Conditions'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () async {
                  await launchUrl(
                    Uri.parse('https://sabzilog.netlify.app/terms'),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.support_agent_outlined),
                title: const Text('Contact Support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        OutlinedButton.icon(
          onPressed: widget.onLogout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}
