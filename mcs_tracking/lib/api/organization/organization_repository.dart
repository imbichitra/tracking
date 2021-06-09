import 'package:mcs_tracking/Models/organization/organization.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/api/organization/organization_provider.dart';

class OrganizationRepository{
  final OrganizatioProvider _apiOrgProvider = OrganizatioProvider(DioClient.getInstance());

  Future<int> createOrganization(user)=>_apiOrgProvider.createOrganization(user);

  Future<int> updateOrganization(user)=>_apiOrgProvider.updateOrganization(user);

  Future<List<Organization>> getAllOrganization()=>_apiOrgProvider.getAllOrganization();

  Future<int> checkAvailability(String orgRefName) => _apiOrgProvider.checkAvailability(orgRefName);

  Future<int> deleteOrganization(int id)=> _apiOrgProvider.deleteOrganization(id);

  Future<Organization> updateStatus(int id,bool status) => _apiOrgProvider.updateStatus(id,status);

  Future<Organization> getMyOrganization(String orgRefName) => _apiOrgProvider.getMyOrganization(orgRefName);
}