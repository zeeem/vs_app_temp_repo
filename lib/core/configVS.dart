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
  static String DEVICE_ID = "66:55:44:33:22:11";
  static bool PROFILE_CREATED;

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
}
