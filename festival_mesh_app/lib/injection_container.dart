import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/datasources/chat_local_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/domain/usecases/send_handshake.dart';
import 'features/chat/domain/usecases/get_chats.dart';
import 'features/chat/domain/usecases/get_identity.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'core/router/app_router.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Router
  sl.registerSingleton<AppRouter>(AppRouter());

  // Features - Chat
  // Bloc
  sl.registerFactory(() => ChatBloc(
        sendMessage: sl(),
        sendHandshake: sl(),
        getChats: sl(),
        getIdentity: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => SendHandshake(sl()));
  sl.registerLazySingleton(() => GetChats(sl()));
  sl.registerLazySingleton(() => GetIdentity(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
          remoteDataSource: sl(), 
          localDataSource: sl()));

  // Data sources
  final myName = sharedPreferences.getString('user_name') ?? "User_${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}";
  sl.registerLazySingleton<ChatDataSource>(
      () => MeshDataSourceImpl(myName));
  
  sl.registerLazySingleton<ChatLocalDataSource>(
      () => ChatLocalDataSourceImpl());
}
