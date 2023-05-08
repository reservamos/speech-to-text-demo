import 'package:sttdemo/app.dart';
import 'package:sttdemo/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
