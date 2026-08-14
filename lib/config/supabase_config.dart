import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://sfuyffjrcemekqpkaygi.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_FVKbMQ3qSSekV-hnjo7K_Q_NmBviZBx';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
  }
}