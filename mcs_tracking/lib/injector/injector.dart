import 'package:get_it/get_it.dart';
import 'package:mcs_tracking/storage/sharedpreferences/shared_preferences_manager.dart';


// For singleton use purpose we are using getit
GetIt locator = GetIt.instance;


Future setupLocator() async {
  SharedPreferencesManager sharedPreferencesManager = await SharedPreferencesManager.getInstance();
  locator.registerSingleton<SharedPreferencesManager>(sharedPreferencesManager);
}