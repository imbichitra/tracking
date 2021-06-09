import 'package:mcs_tracking/api/graph/analytics_provide.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/Models/graph/fleetanalytics.dart';


class AnalyticsRepository{
  final AnalyticsProvide _analyticsProvide = AnalyticsProvide(DioClient.getInstance());
  Future<FleetAnalytics> getUnderutilised(String orgRefName) => _analyticsProvide.getUnderutilizedVehicles(orgRefName);
  Future<FleetAnalytics> getOverSpeed(String orgRefName) => _analyticsProvide.getOverSpeedVehicles(orgRefName);
  Future<FleetAnalytics> getUnderSpeed(String orgRefName) => _analyticsProvide.getUnderSpeedVehicles(orgRefName);
  Future<FleetAnalytics> getLowFuel(String orgRefName) => _analyticsProvide.getLowFuelVehicles(orgRefName);

}