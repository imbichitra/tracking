  import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/organization/organization.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class OrganizatioProvider {
  Dio _dio;

  OrganizatioProvider(Dio dio) {
    _dio = dio;
  }

  Future<int> createOrganization(organization) async {
    try {
      final response = await _dio.post(
        CREATE_ORG_URL,
        data: organization,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.statusCode; //201
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<int> updateOrganization(organization) async {
    try {
      final response = await _dio.put(
        UPDATE_ORG_URL,
        data: organization,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.statusCode; //200
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<List<Organization>> getAllOrganization() async {
    try {
      final response = await _dio.get(
        UPDATE_ORG_URL,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.data["data"].map<Organization>((json) =>
          Organization.fromJson(json)).toList();
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<int> checkAvailability(String orgRefName) async {
    try {
      final response = await _dio.get(
          CHECK_AVAILABILITY_ORG_REF_NAME + orgRefName,
          options: Options(
              headers: {
                'requirestoken': true,
              }
          )
      );

      return response.statusCode;
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<int> deleteOrganization(int id) async {
    try {
      final response = await _dio.delete(
          DELETE_ORG_URL + id.toString(),
          options: Options(
              headers: {
                'requirestoken': true,
              }
          )
      );

      return response.statusCode;
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<Organization> updateStatus(int id, bool status) async {
    try {
      final response = await _dio.put(
          ENABLE_DISABLE_ORG_URL + id.toString() + "&status=" +
              status.toString(),
          options: Options(
              headers: {
                'requirestoken': true,
              }
          )
      );
      return Organization.fromJson(response.data["data"]);
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<Organization> getMyOrganization(String orgRefName) async {
    try {
      final response = await _dio.get(
          MY_ORG_URL+orgRefName,
          options: Options(
              headers: {
                'requirestoken': true,
              }
          )
      );
      return Organization.myOrganization(response.data);

    } catch (e) {
      throw CustomeException(e);
    }
  }

}
