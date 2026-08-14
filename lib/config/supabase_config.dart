import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://sfuyffjrcemekqpkaygi.supabase.co/rest/v1/';
  static const String publishableKey = 'sb_publishable_FVKbMQ3qSSekV-hnjo7K_Q_NmBviZBx';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: publishableKey,
    );
  }
}