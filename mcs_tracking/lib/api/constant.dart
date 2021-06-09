const String BASE_URL = "https://aztrackapiqa.asiczen.com/api/";
//const String BASE_URL = "https://aztrackapiqa.asiczen.com/api/";
// const String BASE_URL = "https://aztrackapi.asiczen.com/api/";
/*
*LOGIN_URL->LOGIN TO THE SYSTEM
*TYPE->POST
*@Param(username,password)
*/
const String LOGIN_URL = "user/login";
/*
 * CURRENT_USER_URL->GET CUURENT LOGED IN USER DATA
 * TYPE->GET
 * @Param()->empty
*/
const String CURRENT_USER_URL = "user/currentuser"; 

/*
 * CREATE_ORG_URL->create an organization
 * TYPE->POST
 * @Param(
 *      orgRefName,
 *      orgName,
 *      description,
 *      firstName,
 *      lastName,
 *      contactEmail,
 *      contactNumber
 * )
 */
const String CREATE_ORG_URL = "service/org";

/*
 * UPDATE_ORG_URL->update an organization
 * TYPE->PUT
 * @Param(
 *      orgId,
 *      orgRefName,
 *      orgName,
 *      description,
 * )
 */
const String UPDATE_ORG_URL = "service/org";

/*
 * GET_ORG_URL->GET an organization
 * TYPE->GET
 */
const String GET_ORG_URL = "service/org";

/*
 * DELETE_ORG_URL->DELETE an organization
 * TYPE->DELETE
 */
const String DELETE_ORG_URL = "service/org/";

/*
 * ENABLE_DISABLE_ORG_URL -> Enable Disable of an organization
 * TYPE->PUT
 */
const  String ENABLE_DISABLE_ORG_URL = "service/org/disable?orgId=";

/*
 * MY_ORG_URL -> Get info about organization
 * TYPE-> GET
 */
const String MY_ORG_URL = "service/org/orgref/";

/*
 * CREATE_DRIVER_URL->create a driver in server
 * TYPE->POST
 * @Param(
 * driverName,
 * contactNumber,
 * whatsappnumber,
 * drivingLicence
 * ) 
 */
const CREATE_DRIVER_URL = "fleet/driver";

/*
 * DELETE_DRIVER_URL->delete a driver by using query param as vehicleId EX(fleet/driver:vehicleId)
 * TYPE->DELETE
 */
const DELETE_DRIVER_URL = "fleet/driver/";

/*
 * UPDATE_DRIVER_URL->update a driver in server
 * TYPE->PUT
 * @Param(
 * driverId,
 * driverName,
 * contactNumber,
 * whatsappnumber,
 * drivingLicence
 * ) 
 */
const UPDATE_DRIVER_URL = "fleet/driver";

/*
 * GET_DRIVERS_URL->get all driver present in server
 * TYPE->GET
 */
const GET_DRIVERS_URL = "fleet/driver";

/*
 * GET_ASSCIATE_DRIVER
 * TYPE->GET
 */
const GET_ASSCIATE_DRIVER = "fleet/vehicledrivermap";

/*
 * CREATE_ASSCIATE_DRIVER
 * TYPE->POST
 * @Param(
 * vehicleId,
 * driverId
 * )
 */
const CREATE_ASSCIATE_DRIVER = "fleet/vehicledrivermap";

/*
 * GET_LAST_LOCATION->get the latest location of vehicle by theire organization refrence so that it will show in map
 * TYPE->GET (pass orgRefName as query param)
 */
const GET_LAST_LOCATION = "analytics/lastpositiondtl?orgRefName=";


/*
 * GET_FLEET_STATUS -> get the fleet status of the vehicles like idle, inactive, active  etc
 * TYPE -> Get(pass orgRefName as query param)
 */
const GET_FLEET_STATUS = "analytics/fleetstatus?orgRefName=";


/*
 * GET_FLEET_USAGE -> get the fleet usage of the vehicles like running distance
 * TYPE -> Get(pass orgRefName as query param)
 */
const GET_FLEET_USAGE = "analytics/fleetusage?orgRefName=";

/*
 * GET_ACCESS_TOKEN-> get a new access token after the old access token expire,we can get the new access
 *  token by passing refreshToken as query param
 * TYPE->GET
 */
const GET_ACCESS_TOKEN = "user/refreshtoken?refreshToken=";

/*
 * CREATE_TACKER_URL
 * TYPE->POST
 * @Param(
 * imeiNumber,
 * modelType
 * )
 */
const CREATE_DEVICE_URL = "fleet/device";

/*
 * GET_TACKER_URL
 * TYPE->GET
 */
const GET_DEVICE_URL = "fleet/device";

/*
 * DELETE_TACKER_URL->pass device id as query param
 * TYPE->DELETE
 */
const DELETE_DEVICE_URL = "fleet/device/";

const UPDATE_DEVICE_URL = "fleet/device";

/*
 * CREATE_VEHICLE_URL
 * TYPE->POST
 * @Param(
 * vehicleRegNumber,
 * vehcleType,
 * ownerName,
 * ownerContact
 * )
 */
const CREATE_VEHICLE_URL = "fleet/vehicle";

/*
 * GET_VEHICLE_INFO_URL->get all vehicle information with assciate vehicle owner detail and driver detail
 * TYPE->GET
 */
const GET_VEHICLE_INFO_URL = "fleet/vehicleinfo";

/*
 * GET_VEHICLE_URL->get all vehicle information
 * TYPE->GET
 */
const GET_VEHICLE_URL = "fleet/vehicle";

/*
 * GET_OWNER_URL->get Owner details of vehicle
 * TYPE->GET
 */
const GET_OWNER_URL = "fleet/ownerbyvehicle/";

/*
 * UPDATE_VEHICLE_URL
 * TYPE->PUT
 * @Param(
 * vehicleid,
 * vehicleRegNumber,
 * ownerName,
 * ownerContact,
 * vehcleType
 * )
 */
const UPDATE_VEHICLE_URL = "fleet/vehicle";

/*
 * DELTE_VEHICLE_URL
 * TYPE->DELETE (pass vehicleId as query param)
 */
const DELTE_VEHICLE_URL = "fleet/vehicle/";

/*
 * GET_ASSOCIATE_VEHICLE_URL
 * TYPE->GET
 */
const GET_ASSOCIATE_VEHICLE_URL = "fleet/vehicleinfo";

/*
 * GET_ASSOCIATE_DEVICE_VEHICLE_URL
 * TYPE->GET
 */
const GET_ASSOCIATE_DEVICE_VEHICLE_URL = "fleet/deviceinfo";

/*
 * CREATE_ASSOCIATE_VEHICLE_URL
 * TYPE->POST
 * @Param(
 * vehicleid,
 * deviceid
 * )
 */
const CREATE_ASSOCIATE_DEVICE_VEHICLE_URL = "fleet/devicevehiclemap";

const CREATE_ASSOCIATE_DRIVER_VEHICLE_URL = "fleet/vehicledrivermap";

/*
 * GET USERS
 * TYPE -> GET
 */
const GET_USERS = "user/users";


/*
 * CREATE_ASSOCIATE_VEHICLE_URL
 * TYPE->GET
 */
const CHECK_AVAILABILITY_ORG_REF_NAME = "service/org/validate?orgReferenceName=";

/*
 * GET_UNDERUTILIZED_VEHICLE
 * TYPE->GET
 * @Param(
 * orgRefName
 * )
 */

const GET_UNDERUTILIZED_VEHICLE = "analytics/underutilized?orgRefName=";

/*
 * GET_OVER_SPEED_VEHICLE
 * TYPE->GET
 * @Param(
 * orgRefName
 * )
 */

const GET_OVER_SPEED_VEHICLE = "analytics/overspeed?orgRefName=";

/*
 * GET_UNDER_SPEED_VEHICLE
 * TYPE->GET
 * @Param(
 * orgRefName
 * )
 */

const GET_UNDER_SPEED_VEHICLE = "analytics/underspeed?orgRefName=";

/*
 * GET_LOW_FUEL_VEHICLE
 * TYPE->GET
 * @Param(
 * orgRefName
 * )
 */

const GET_LOW_FUEL_VEHICLE = "analytics/lowfuel?orgRefName=";

/*
 * GET_DISTANCE_VEHICLE_AVERAGE
 * TYPE->POST
 * @Param(
 * orgRefName,
 * startDate,
 * endDate
 * )
 */
const GET_DISTANCE_VEHICLE_AVERAGE = "analytics/distancevehiclesavg";
/*
 * GET_VEHICLE_VS_HOURS
 * TYPE->POST
 * @Param(
 * orgRefName,
 * startDate,
 * endDate
 * )
 */

const GET_VEHICLE_VS_HOURS = "analytics/vehiclevshours";

/*
 * GET_VEHICLE_STATUS_COUNT
 * TYPE->POST
 * @Param(
 * orgRefName,
 * startDate,
 * endDate
 * )
 */
const GET_VEHICLE_STATUS_COUNT = "analytics/vehiclestatuscounter";

/*
 * GET_ACTIVE_VEHICLE_VS_DISTANCE
 * TYPE->POST
 * @Param(
 * orgRefName,
 * startDate,
 * endDate
 * )
 */
const GET_ACTIVE_VEHICLE_VS_DISTANCE = "analytics/activevehiclevsdistance";


/*
 * POST_USER_URL
 * TYPE->POST
 * @Param(
 * orgRefName: “”,
 * contactNumber: "",
 * userName: "",
 * firstName: "",
 * lastName: "",
 * )
 */
const POST_USER = "user/createuser";


/*
 * POST_USER_URL
 * TYPE->POST
 * @Param(
    TRIP_CLASS
 * )
 */

const CREATE_TRIP = "manage/trip";

/*
 * GET_TRIP
 * TYPE->GET
 * @Param()
 */

const GET_TRIP = "manage/trip/all?orgRefName=";


/*
 * GET_DISTANCE_BY_DATE_AND_VEHICLE
 * TYPE->POST
 * @Param(
 * orgRefName
 * inputDate
 * )
 */

const GET_DISTANCE_BY_DATE_AND_VEHICLE = "analytics/distanceByDateAndVehicle";


/*
 * GET_DISTANCE_BY_VEHICLE
 * TYPE->POST
 * @Param(
 * orgRefName
 * fromDate
 * toDate
 * vehicleNumber
 * )
 */

const GET_DISTANCE_BY_VEHICLE = "analytics/distanceByVehicle";

/*
 * GET_ROUTE_REPLAY
 * TYPE->POST
 * @Param(
 * fromDate
 * toDate
 * vehicleNumber
 * )
 */

const GET_ROUTE_REPLAY = "analytics/history";

/*
 * START_TRIP
 * TYPE->POST
 * @Param(
 *  org_ref_name
 *  trip_id
 * )
 */
const START_TRIP = "manage/trip/start?orgRefName=";

/*
 * END_TRIP
 * TYPE->PATCH
 * @Param(
 *  trip_id
 * vehicle_Id
 * )
 */
const END_TRIP = "manage/trip/endTrip?orgRefName=";

/*
 * UPDATE_TRIP
 * TYPE->PUT
 * TRIP OBJECT
 * )
 */
const UPDATE_TRIP = "manage/trip";