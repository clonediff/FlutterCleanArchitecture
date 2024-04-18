import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/common/app_colors.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:flutter_clean_architecture/feature/presentation/pages/person_screen.dart';
import 'package:flutter_clean_architecture/locator_service.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonListCubit>(
          create: (context) => di.sl<PersonListCubit>()..loadPerson(),
        ),
        BlocProvider<PersonSearchBloc>(
          create: (context) => di.sl<PersonSearchBloc>(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          colorScheme:
              const ColorScheme.dark(background: AppColors.mainBackground),
          scaffoldBackgroundColor: AppColors.mainBackground,
        ),
        home: const HomePage(),
      ),
    );
  }
}
