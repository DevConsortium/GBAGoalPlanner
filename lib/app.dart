import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tea/entrypoint.dart';
import 'package:tea/features/shop/screens/Nointernet/ConnectivityWrapper.dart';

import 'package:tea/utils/theme/theme.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      // darkTheme: TAppTheme.darkTheme,
      // home: OnBoardingScreen(),
      // home: EntryPoint(),
      home: ConnectivityWrapper(child: EntryPoint()),
      debugShowCheckedModeBanner: false,
    );
  }
}
