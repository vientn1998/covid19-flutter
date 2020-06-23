import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template_flutter/src/app/simple_bloc_delegate.dart';
import 'package:template_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:template_flutter/src/blocs/auth/auth_state.dart';
import 'package:template_flutter/src/blocs/common/bloc.dart';
import 'package:template_flutter/src/blocs/covid19/bloc.dart';
import 'package:template_flutter/src/blocs/death/bloc.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_bloc.dart';
import 'package:template_flutter/src/blocs/local_search/bloc.dart';
import 'package:template_flutter/src/blocs/major/bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/database/covid_dao.dart';
import 'package:template_flutter/src/repositories/covid19/covid_api_client.dart';
import 'package:template_flutter/src/repositories/covid19/covid_repository.dart';
import 'package:template_flutter/src/repositories/major_repository.dart';
import 'package:template_flutter/src/repositories/user_repository.dart';
import 'package:template_flutter/src/screens/introduction/splash_screen.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/share_preferences.dart';

import 'src/app/my_app.dart';
import 'src/screens/introduction/login_screen.dart';
import 'src/screens/introduction/introduction_screen.dart';

  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final Covid19Repository covid19repository = Covid19Repository(
      covid19apiClient: Covid19ApiClient()
  );
  final majorRepository = MajorRepository();

  final userRepository = UserRepository();
  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<Covid19Bloc>(
            create: (context) =>
                Covid19Bloc(covid19repository: covid19repository),
          ),
          BlocProvider<CommonBloc>(
            create: (context) => CommonBloc(),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(covid19dao: Covid19Dao()),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(userRepository: userRepository),
          ),
          BlocProvider<DeathBloc>(
            create: (context) => DeathBloc(covid19repository: covid19repository),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(userRepository: userRepository),
          ),
          BlocProvider<DoctorBloc>(
            create: (context) => DoctorBloc(userRepository: userRepository),
          ),
          BlocProvider<MajorBloc>(
            create: (context) =>
                MajorBloc(majorRepository),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Roboto',
          ),
          home: SplashPage(userRepository: userRepository,),
        ),
      )
  );
}