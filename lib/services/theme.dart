import 'package:flutter/material.dart';
import 'package:meproject/services/sharedpreferences.dart';

class ThemeModel extends ChangeNotifier{
     bool _isDark=false;
    late ThemeSharedPreferences themeSharedPreferences;
    bool get isDark => _isDark;

     ThemeModel(){
      _isDark=false;
      themeSharedPreferences=ThemeSharedPreferences();
      getThemePreferences();
     }

     getThemePreferences() async {
      _isDark = await themeSharedPreferences.getTheme();
      notifyListeners();
     }

     set isDark(bool value){
      _isDark=value;
      themeSharedPreferences.setTheme(value);
      notifyListeners();
     }

}
