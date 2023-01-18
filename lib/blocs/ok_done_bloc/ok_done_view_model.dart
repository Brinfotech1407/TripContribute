// abstract template the view model that would be used by views
// why abstract?
// Because this can be implemented by a basic model class in case of Bloc and
// implemented by a ChangeNotifier in case of provider
import 'package:trip_contribute/blocs/abstract/app_view_model.dart';

abstract class OkDoneViewModel implements AppViewModel {

  bool? get isLoading;

}
