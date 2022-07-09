import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/helper/file_helper.dart';
import '../../../repository/app_cache_manager.dart';
import '../../../../locator.dart';

import '../../../../core/enums/preferences_keys.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  int currentPage = 1;
  final _gridCount = 12;
  int gridChildCount = 12;
  int totalPageCount = 5;
  final AppCacheManager _cacheManager = locator<AppCacheManager>();

  checkGridChildCount() {
    //
    int currentLevel =
        int.parse(_cacheManager.getItem(PreferencesKeys.level.name));
    totalPageCount = (FileHelper.instance.allLevels.length / 12).ceil();

    if (currentPage == totalPageCount) {
      gridChildCount = FileHelper.instance.allLevels.length % 12;
    } else {
      gridChildCount = 12;
    }
    if ((15 + currentPage * 15) > currentLevel) {}
  }

  changeCurrentPage(int currentPage) {
    emit(HomeInitial());
  }

  findRightPage() {
    int currentLevel =
        int.parse(_cacheManager.getItem(PreferencesKeys.level.name));
    if (currentLevel <= _gridCount) {
      currentPage = 1;
    } else if (currentLevel <= _gridCount * 2) {
      currentPage = 2;
    } else if (currentLevel <= _gridCount * 3) {
      currentPage = 3;
    } else if (currentLevel <= _gridCount * 4) {
      currentPage = 4;
    } else if (currentLevel <= _gridCount * 5) {
      currentPage = 5;
    } else if (currentLevel <= _gridCount * 6) {
      currentPage = 6;
    } else if (currentLevel <= _gridCount * 7) {
      currentPage = 7;
    } else if (currentLevel <= _gridCount * 8) {
      currentPage = 8;
    }
  }
}
