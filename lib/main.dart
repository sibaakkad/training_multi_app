import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news/modules/shop_app/login/shop_login_screen.dart';
import 'package:flutter_news/shared/bloc_observer.dart';
import 'package:flutter_news/shared/components/constants.dart';
import 'package:flutter_news/shared/cubit/cubit.dart';
import 'package:flutter_news/shared/cubit/states.dart';
import 'package:flutter_news/shared/network/local/chache_helper.dart';
import 'package:flutter_news/shared/network/remote/dio_helper.dart';
import 'package:flutter_news/shared/styles/themes.dart';
import 'layout/news_app/cubit/cubit.dart';
import 'layout/shop_app/cubit/cubit.dart';
import 'layout/shop_app/shop_layout.dart';
import 'layout/todo_app/todo_layout.dart';
import 'modules/shop_app/on_boarding/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  // bool? isDark = CacheHelper.getData(key: 'isDark') != null
  //     ? CacheHelper.getData(key: 'isDark')
  //     : false;
  bool? isDark = CacheHelper.getData(key: 'isDark') ?? false;
  Widget widget;

  bool? onBoarding;
  token = CacheHelper.getData(key: 'token') ?? '';
  print(token);

  if (onBoarding != null) {
    if (token != '') {
      widget = const ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  runApp(myApp(
    isDark: isDark!,
    startWidget: widget,
  ));
}

class myApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  const myApp({required this.isDark, required this.startWidget});

  // counstructor
  // build

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit()
            ..getBusiness()
            ..getSports()
            ..getScience(),
        ),
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: HomeLayout(),
          );
        },
      ),
    );
  }
}
