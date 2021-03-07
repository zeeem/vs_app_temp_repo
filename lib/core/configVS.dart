import 'package:vital_signs_ui_template/Processing/NetworkGateway/networkManager.dart';
import 'package:vital_signs_ui_template/elements/User.dart';

class localConfigVS {
  //local warning boolean
  //to issue the warning alert box and sound
  static bool isWarningIssued = false; //true during warning
  static bool isDeviceConnected = false;

  //local color warning for values
  static bool hr_warning = false; //true during warning
  static bool rr_warning = false; //true during warning
  static bool spo2_warning = false; //true during warning
  static bool temp_warning = false; //true during warning

  //local config
  static List HR_threshold_range = [60, 90];
  static List temp_threshold_range = [25, 40];

  //config to trigger the alarm
  //its a multiplier. Change it to increase the final value by x (above/below range) to trigger the alarm
  //it should be positive number (0 to ~2)
  static int warning_trigger_value_adder = 0; //0 means not active
  static bool isTestingModeOn = true; //true for enabling test mode for alert

}

class VS_Values {
  static String final_static_HR = '';
  static String final_static_RR = '';
  static String final_static_SPO2 = '';
  static String final_static_temp = '';
}

class profileData {
  static String DEVICE_ID = "04:91:62:96:EA:DA";
  // "F1547A55-0823-261A-B1C2-051234E9DAE9"; //"04:91:62:96:EA:F5"; //"66:55:44:33:22:11";
  static bool needToTryAgain = false;

  static String userUUID = '';

  static bool PROFILE_CREATED = false;

  static String DOCTOR_FULL_NAME;
  static String DOCTOR_HEALTHCARE_FACILITY;

  static String USER_FULL_NAME;
  static String USER_PHONE;

  static String EMERGENCY_CONTACT_1_NAME;
  static String EMERGENCY_CONTACT_1_PHONE;

  static String EMERGENCY_CONTACT_2_NAME;
  static String EMERGENCY_CONTACT_2_PHONE;

  static String EMERGENCY_CONTACT_3_NAME;
  static String EMERGENCY_CONTACT_3_PHONE;

  //app info
  static String buildNumber;
  static String appVersion;
}

class doctorData {
  static List<User> patientList = [];
}

class apiData {
  static String baseAPIurl = "yizhouzhao.dev";
}

class GLOBALS {
  static UserProfile USER_PROFILE;
  static NetworkManager API_NETWORK_MANAGER =
      NetworkManager(apiData.baseAPIurl, nursingHome: false);
}
