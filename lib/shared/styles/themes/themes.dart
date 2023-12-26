import 'package:admin/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes{
    static final lightTheme=ThemeData(
        fontFamily: 'Metropolis',
        primarySwatch: AppColors.mainSwatchColor,
        appBarTheme:  AppBarTheme(
            actionsIconTheme: IconThemeData(color: AppColors.mainColor,size: 20),
            titleTextStyle: TextStyle(
              color: AppColors.titleColor,
              fontSize:24,
            ),
            iconTheme: IconThemeData(color: AppColors.mainColor),
            elevation: 0,
            color: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            )
        ),
        textTheme:  TextTheme(
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.titleColor,
            ),
            bodyMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.titleColor,
            ),
            bodySmall: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor
            ),
        ),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme:BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedItemColor: AppColors.disabledColor
        )
    );


    static final darkTheme=ThemeData(
        primarySwatch: Colors.deepOrange,
        appBarTheme: const AppBarTheme(
            elevation: 0,
            color: Colors.black54,
            titleTextStyle:  TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.black54,
              statusBarIconBrightness: Brightness.light,
            )
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),),
        scaffoldBackgroundColor: Colors.black54
    );
}
