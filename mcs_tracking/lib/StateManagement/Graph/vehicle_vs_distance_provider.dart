import 'package:flutter/cupertino.dart';
import 'package:mcs_tracking/Models/graph/vehiclesHours.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/api/graph/vehicle_hours_repository.dart';

class VehicleVsHourStateManagement extends ChangeNotifier {
  VehicleHoursList _vehicleHoursList;
  VehicleVsHoursRepository _vehicleVsHoursRepository =
      VehicleVsHoursRepository();

  VehicleHoursList get getVehicleHoursList => this._vehicleHoursList;

  void setVehicleVsHours(VehicleHoursList vehicleHoursList) {
    this._vehicleHoursList = vehicleHoursList;
    notifyListeners();
  }

  Future<void> fetchVehicleVsHours(data) async {
    try {
      VehicleHoursList vehicleHoursList =
          await _vehicleVsHoursRepository.getVehicleVsHours(data);
      setVehicleVsHours(vehicleHoursList);
    } catch (e) {
      throw CustomeException(e);
    }
  }
}
