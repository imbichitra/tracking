import 'package:mcs_tracking/Models/graph/activeVehicleVsStatus.dart';
import 'package:mcs_tracking/Models/graph/fleetUsage.dart';
import 'package:mcs_tracking/Models/graph/vehicleStatusCounter.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/Models/graph/fleetStatus.dart';
import 'package:mcs_tracking/api/graph/graph_provide.dart';

class GraphRepository{
  final GraphProvide _graphProvide = GraphProvide(DioClient.getInstance());

  Future<FleetStatus> getFleetStatus(String orgRefName) => _graphProvide.getFleetStatus(orgRefName);
  Future<FleetUsage> getFleetUsage(String orgRefName) => _graphProvide.getFleetUsage(orgRefName);

  Future<VehicleStatusCounterList> getVehicleStatusCounter(var data) => _graphProvide.getVehicleStatusCounter(data);
  Future<ActiveVehicleVsStatusList> getActiveVehicleVsStatus(var data) => _graphProvide.getActiveVehicleVsStatus(data);

}