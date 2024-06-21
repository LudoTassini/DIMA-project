import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> checkConnectivity({required var localizedText}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if(connectivityResult.contains(ConnectivityResult.none)){
    throw BloqoException(message: localizedText.network_error);
  }
}