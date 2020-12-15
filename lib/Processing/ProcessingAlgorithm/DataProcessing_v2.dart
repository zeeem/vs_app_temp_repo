import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:stats/stats.dart';
import 'HR.dart';
import 'algorithm/sgfilter.dart';
import 'algorithm/findTopPeaks.dart';
import 'algorithm/envelope.dart';


String temp2show = '';


List calculate_HR_RR_SPO2_TEMP(
    Array raw_IR_500, Array raw_RED_500, var last_500_temperature) {
  List processed_500_hr_rr_spo2_temp = [];

  //-------- Digital filter application -----------//,
  SgFilter filter = new SgFilter(4, 11);

  var sgfiltered_RED = Array(filter.smooth(raw_RED_500));
  var sgfiltered_IR = Array(filter.smooth(raw_IR_500));

  //--------------------------------calculate Heart Rate-----------------------------------------

  double final_hr_ = calculate_HR(sgfiltered_IR);
//  String final_hr_ = calculated_hr.toStringAsFixed(0);

  //--------------------------------calculate Heart Rate-----------------------------------------

  // ------------------------------------IR signal processing------------------------
  //enveloping RED
  var enved_RED = envelope(sgfiltered_RED, 5); //45
  var upper_RED = enved_RED[0];
  var lower_RED = enved_RED[1];
  //enveloping IR
  var enved_IR = envelope(sgfiltered_IR, 5);
  var upper_IR = enved_IR[0];
  var lower_IR = enved_IR[1];

  var pp_IR = new Array(
      Array(upper_IR.cast<double>()) - Array(lower_IR.cast<double>()));

  var pp_RED = new Array(
      Array(upper_RED.cast<double>()) - Array(lower_RED.cast<double>()));

//-----------------------------------calculate parameters for RR and SPO2 ----------------------------------------------
  var smoothed_pp_IR = Array(filter.smooth(pp_IR));
  var pk_PP_IR = findTopPeaksRR(smoothed_pp_IR, mindistance: 5);
  print(smoothed_pp_IR);
  print(pk_PP_IR[0]);
  print(pk_PP_IR[1]);

  //---------------------------calculate RR------------------------------

  var collecting_frequency = 60; //-you may need to modify this for different devices
  var Resp = pk_PP_IR[0].length; // record how many breathing in the whole time.
  var time = sgfiltered_IR.length /
      collecting_frequency /
      60; // record how many minutes in the data
  double Resp_per_minute = Resp / time;

  print("Duration in minues:");
  print(time);
  print("Times of breathing:");
  print(Resp);
  print("RR:");
  print(Resp_per_minute);

  double final_rr_ = Resp_per_minute;


  //---------------------------calculate SPO2------------------------------
  var RR = (pp_RED / Array(lower_RED.cast<double>())) /
      (pp_IR / Array(lower_IR.cast<double>()));

  //SPO2=(-45.060*RR.^2)+30.354*RR+94.84;
  var SPO2 = Array.empty();
  SPO2 = arraySubToScalar(
      arrayMultiplyToScalar(arrayPow(RR, 2.0), -45.06) +
          arrayMultiplyToScalar(RR, 30.354),
      -94.84);

  double final_spo2_ = SPO2.last;
//  String final_spo2_ = SPO2.last.toStringAsFixed(0);
//  await Future.delayed(const Duration(seconds: 5));


  //--------------------------------calculate temperature-----------------------------------------

  double final_temp_ = calculateTemperature(last_500_temperature);

  processed_500_hr_rr_spo2_temp.add(final_hr_);
  processed_500_hr_rr_spo2_temp.add(final_rr_);
  processed_500_hr_rr_spo2_temp.add(final_spo2_);
  processed_500_hr_rr_spo2_temp.add(final_temp_);

  return processed_500_hr_rr_spo2_temp;
}

// not red, it will be IR for heart rate

// not red, it will be IR for heart rate
double calculate_HR(Array sgFiltered_red) {
  double F_hr;
  var fs = 60; // collecting frequency may need to be modified

  // SgFilter filter = new SgFilter(4, 11);
  //
  // var sgFiltered = Array(filter.smooth(RED_SIGNAL_array));
  //print(sgFiltered);
  // print('--------peaks-------');
  var pk = findTopPeaks(sgFiltered_red, mindistance: 5);
  // print(pk[0]); // print the indexes of the peaks found in the signal
  // print(pk[1]); // print the values of the peaks found in the signal

  //calculate HR
  var diffArray = arrayDiff(Array(pk[0].cast<double>()));
  var HRArray = Array([]); //contains HR for each second.
  print('-----diffArray----');
  print(diffArray);
  for (int i = 1; i < diffArray.length; i++) {
    HRArray.add(fs * 60 / diffArray[i]); //Heart beat per minute
  }
  print('-----HRArray----');
  print(HRArray);
  // double last_HR = HRArray.last;
  //
  // print('---last HR in the data----');
  // print(last_HR);

  //using only last 3 HR value to get the median or else output the one that we have
  try {
    var intermediate_hr_for_median = HRArray.reversed
        .toList()
        .getRange(0, 3)
        .toList(); //its a list now, not Array
    double HRLast3dataMedian =
        Stats.fromData(intermediate_hr_for_median).median;
    F_hr = HRLast3dataMedian;
  } catch (e) {
    double HRArray_mean = mean(HRArray);
    print('mean HR $HRArray_mean');
    F_hr = HRArray_mean;
  }

//    temp_HR_array.add(HRArray_mean);
//  warning_HR_val = HRArray_mean;
//  final_HR_to_show = HRArray_mean.toStringAsFixed(0);
  return F_hr;
}

// averaging temperature value after each 10 sec
double calculateTemperature(Array sensordata) {
  Array calculated_temp = Array.empty();
  for (int i = 0; i < sensordata.length; i++) {
    var T1 = (sensordata[i] * 3.3) / 1023;
    var T2 = T1 - 0.49;
    var intermediate_temp = T2 / 0.01;
    calculated_temp.add(intermediate_temp);
  }
  var final_T = mean(calculated_temp);

//  temp2show = final_T.toStringAsFixed(2);
  return final_T;
}

