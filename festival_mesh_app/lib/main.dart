import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'injection_container.dart' as di;
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize dependencies
  await di.init();
  
  runApp(const FestivalMeshApp());
}

class FestivalMeshApp extends StatelessWidget {
  const FestivalMeshApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = di.sl<AppRouter>();

    return BlocProvider(
      create: (_) => di.sl<ChatBloc>()..add(const ChatEvent.started()),
      child: MaterialApp.router(
        title: 'Festival Mesh',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: Colors.blue.shade800,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade800,
            primary: Colors.blue.shade800,
          ),
        ),
        routerConfig: appRouter.config(),
      ),
    );
  }
}
