import 'package:envelope/bootstrap.dart';
import 'package:envelope/firebase_options_production.dart';

Future<void> main() async {
  await bootstrap(
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
    supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
