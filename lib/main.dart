import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize();

  await Supabase.initialize(
    url: 'https://fmtfjpowgbupupgalhbl.supabase.co',
    anonKey: 'sb_publishable_JqaI30FrrevtVlP5fsMIsg_sMtqS5oy',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const VegLogApp(),
    ),
  );
}
