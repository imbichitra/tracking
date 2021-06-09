import 'package:dio/dio.dart';

class   CustomeException {
  String message;
  CustomeException(DioError error){
    message = _handleError(error);
  }

  _handleError(DioError error) {
     String _errorMessage = "";
    switch (error.type) {
      case DioErrorType.CANCEL:
        _errorMessage = "Request was cancelled";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        _errorMessage = "Connection timeout";
        break;
      case DioErrorType.DEFAULT:
        _errorMessage =
            "Connection failed due to internet connection";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        _errorMessage = "Receive timeout in connection";
        break;
      case DioErrorType.RESPONSE:
        print(error.response.data);
        var msg = error.response.data["message"];
        print(error.response.data["message"]);
//        if(msg is String){
//           _errorMessage =error.response.data["message"];
//        }else{
//          for(int i=0;i<msg.length;i++){
//            _errorMessage = _errorMessage + msg[i]+"\n";
//          }
//        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        _errorMessage = "Receive timeout in send request";
        break;
    }
    return _errorMessage;
  }

}