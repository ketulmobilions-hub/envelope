import 'package:envelope/bootstrap.dart';

Future<void> main() async {
  await bootstrap(
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
    supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );
}
