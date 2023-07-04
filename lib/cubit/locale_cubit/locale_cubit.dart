import 'package:flutter/material.dart' show Locale;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multilingual/generated/l10n.dart';
import 'package:multilingual/main.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit()
      : super(SelectedLocale(Locale(prefs.getString('locale') ?? 'en')));

  Future setLocale(Locale locale) async {
    await prefs.setString('locale', locale.languageCode);
    localization = S.of(navigationKey.currentContext!);
    emit(SelectedLocale(locale));
  }
}
