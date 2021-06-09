import 'package:flutter/material.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:provider/provider.dart';
import 'package:mcs_tracking/api/organization/organization_repository.dart';
import 'package:mcs_tracking/Models/organization/organization.dart';

class OrganizationStateManagement extends ChangeNotifier{
    List<Organization> organizationList = List();
    OrganizationRepository organizationRepository = OrganizationRepository();

    Organization myOrganization;

    bool isLoading = false;
    int statusCode;
    String deleteMessage;
    int updateStatus;

    OrganizationStateManagement();

    void setOrganizationList(List<Organization> organizations){
      this.organizationList = organizations;
      notifyListeners();
    }

    void setDeleteMessage(String msg){
      this.deleteMessage = msg;
      notifyListeners();
    }

    void setMyOrganization(Organization organization){
      this.myOrganization = organization;
      notifyListeners();
    }

    List<Organization> get getOrganizationList => this.organizationList;
    String get getDeleteMessage => this.deleteMessage;
    Organization get getMyOrganization => this.myOrganization;


    Future<void> getOrganizations()async{
      try{
        isLoading = true;
        notifyListeners();
        List<Organization> list = await organizationRepository.getAllOrganization();
        setOrganizationList(list);
      }catch(e){
        print(e);
      }
    }

    Future<int> createOrganization(organization) async{
      try{
        isLoading = true;
        notifyListeners();
        statusCode = await organizationRepository.createOrganization(organization);
        return statusCode;
      }catch(e){
        print(e);
      }
    }

    Future<int> updateOrganization(organization) async{
      try{
        isLoading = true;
        notifyListeners();
        statusCode = await organizationRepository.updateOrganization(organization);
        return statusCode;
      }catch(e){
        print(e);
      }
    }

    Future<int> deleteOrganization(int id) async{
      try{
        int status = await organizationRepository.deleteOrganization(id);
        if(status == 204){
          organizationList.removeWhere((element) => element.orgId == id);
          notifyListeners();
        }

        return status;
      }catch(e){
        throw CustomeException(e);
      }
    }

    Future<int> checkAvailability(String orgRefName)async{
      try{
        statusCode = await organizationRepository.checkAvailability(orgRefName);

        return statusCode;
      }catch(e){
        print(e);
      }
    }

    Future<Organization> statusUpdate(int id,bool statusOrg) async{
      try{
        Organization updatedOrganization  = await organizationRepository.updateStatus(id, statusOrg);

        return updatedOrganization;
      }catch(e){
        print(e);
      }

    }

    Future<void> fetchMyOrganization(String orgRefName)async{
      try{
        Organization organization = await organizationRepository.getMyOrganization(orgRefName);
        setMyOrganization(organization);
      }catch(e){
        print(e);
        throw CustomeException(e);
      }
    }

}