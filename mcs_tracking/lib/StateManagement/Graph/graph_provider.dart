
import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/graph/activeVehicleVsStatus.dart';
import 'package:mcs_tracking/Models/graph/fleetStatus.dart';
import 'package:mcs_tracking/Models/graph/fleetUsage.dart';
import 'package:mcs_tracking/Models/graph/vehicleStatusCounter.dart';
import 'package:mcs_tracking/api/graph/graph_repository.dart';


class GraphStateManagement extends ChangeNotifier{
    bool isLoading = false;
    FleetStatus fleetStatus;
    FleetUsage fleetUsage;
    ActiveVehicleVsStatusList activeVehiclesVsStatusList ;
    VehicleStatusCounterList vehicleStatusCounterList ;


    GraphRepository _graphRepository = GraphRepository();

    GraphStateManagement();

    void setFleetStatus(FleetStatus fleetStatus){
      this.fleetStatus = fleetStatus;
      isLoading = false;
      notifyListeners();
    }

    void setFleetUsage(FleetUsage fleetUsage){
      this.fleetUsage = fleetUsage;

      notifyListeners();
    }

    void setAverageVehicleVsStatusList(ActiveVehicleVsStatusList object){
      this.activeVehiclesVsStatusList = object;
      notifyListeners();
    }

    void setVehicleStatusCounterList(VehicleStatusCounterList obj){
      this.vehicleStatusCounterList = obj;
      notifyListeners();
    }


    FleetStatus get  getFleetStatus => this.fleetStatus;
    FleetUsage get getFleetUsage => this.fleetUsage;

    VehicleStatusCounterList get getVehicleStatusCounterList => this.vehicleStatusCounterList;
    ActiveVehicleVsStatusList get getActiveVehicleVsStatus => this.activeVehiclesVsStatusList;


    Future<void> fetchFleetStatus(String orgRefName)async{
      try{
        isLoading = true;
        notifyListeners();
        FleetStatus obj = await _graphRepository.getFleetStatus(orgRefName);
        setFleetStatus(obj);
      }catch(e){
        print(e);
      }
    }


    Future<void> fetchFleetUsage(String orgRefName)async{
      try{
        FleetUsage obj = await _graphRepository.getFleetUsage(orgRefName);
        setFleetUsage(obj);
      }catch(e){
        print(e);
      }
    }

    Future<void> fetchActiveVehicleVsStatus(var data)async{
      try{
        ActiveVehicleVsStatusList list = await _graphRepository.getActiveVehicleVsStatus(data);
        setAverageVehicleVsStatusList(list);
      }catch(e){
        print(e);
      }
    }

    Future<void> fetchVehicleStatusCounter(var data)async{
      try{
        VehicleStatusCounterList obj = await _graphRepository.getVehicleStatusCounter(data);
        setVehicleStatusCounterList(obj);
      }catch(e){
        print(e);
      }
    }


}