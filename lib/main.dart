import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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

  // 2. Initialize the downloader (THIS IS THE MISSING PIECE)
  await FlutterDownloader.initialize(
    debug: kDebugMode, // Change to false for the final public release
    ignoreSsl: true, // Crucial for downloading from GitHub URLs
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const VegLogApp(),
    ),
  );
}
