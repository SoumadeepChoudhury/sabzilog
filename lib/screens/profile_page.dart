import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/models/user_role.dart';
import 'package:logger/providers/auth_provider.dart';
import 'package:logger/supabase/SupabaseImageService.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(
    text: 'Enter your full name...',
  );

  final _emailController = TextEditingController(
    text: 'Enter your email address...',
  );

  User? user;
  String? profileImageUrl;
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile(authProvider) async {
    if (_formKey.currentState!.validate()) {
      authProvider.updateName(_nameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          user = authProvider.user;
          profileImageUrl = user?.photoURL;
          _nameController.text = user?.displayName ?? '';
          _emailController.text = user?.email ?? '';

          if (user == null) {
            return const Center(child: Text("No user signed in"));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 50,
                        child: isLoading
                            ? CircularProgressIndicator()
                            : (profileImageUrl != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        profileImageUrl!,
                                      ),
                                    )
                                  : Icon(Icons.person, size: 50)),
                      ),
                      FloatingActionButton.small(
                        backgroundColor: Colors.teal[300],
                        heroTag: 'edit_photo',
                        onPressed: () async {
                          final picker = ImagePicker();
                          Future<File?> pickImage() async {
                            final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 100,
                            );
                            return pickedFile != null
                                ? File(pickedFile.path)
                                : null;
                          }

                          try {
                            final profileImage = await pickImage();
                            setState(() => isLoading = true);
                            if (profileImage != null) {
                              final supabaseImageService =
                                  SupabaseImageService();

                              final photoUrl = await supabaseImageService
                                  .pickCompressAndUpload(profileImage);

                              if (photoUrl == null) {
                                debugPrint('Upload failed');
                                return;
                              }

                              debugPrint('Image uploaded to: $photoUrl');
                              await authProvider.updateUserProfile(photoUrl);
                              setState(() {
                                profileImageUrl = photoUrl;
                                isLoading = false;
                              });
                            }
                          } catch (e) {
                            // Handle any errors that occur during image picking
                            debugPrint('Error picking image: $e');
                          }
                        },
                        child: const Icon(Icons.edit),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account Role',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54),
                        ),
                        Text(
                          authProvider.role!.label,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _saveProfile(authProvider),
                      icon: const Icon(Icons.save),
                      label: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
