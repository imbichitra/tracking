import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/vehicle_detail.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class LastLocationProvide {
  Dio _dio;

  LastLocationProvide(Dio dio) {
    _dio = dio;
  }

  Future<List<VehicleDetail>> getLastocation(String orgRefName) async {
    try {
      final response = await _dio.get(
        GET_LAST_LOCATION + orgRefName,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data["data"].map<VehicleDetail>((json) => VehicleDetail.fromJson(json)).toList();

    } catch (e) {
      throw CustomeException(e);

    }
  }
}
