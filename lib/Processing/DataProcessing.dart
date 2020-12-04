import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:stats/stats.dart';

String temp2show = '';
//void dataProcess(String v) {
//  print("1234 ----$v");
//}

List findTopPeaks(Array a, {double mindistance}) {
  //modify from scidart.findPeaks
  var N = a.length - 2;
  Array ix = Array.empty(); //ix -- index
  Array ax = Array.empty(); // ax -- value
  ix.add(0);
  ax.add(0);
  if (mindistance != null) {
    for (int i = 1; i <= N; i++) {
      if (a[i - 1] <= a[i] && a[i] >= a[i + 1]) {
        if (i - ix.last > mindistance) {
          //mindistance between two peaks
          ix.add(i.toDouble());
          ax.add(a[i]);
        }
      }
    }
  } else {
    for (int i = 1; i <= N; i++) {
      if (a[i - 1] <= a[i] && a[i] >= a[i + 1]) {
        ix.add(i.toDouble());
        ax.add(a[i]);
      }
    }
  }
  ix.remove(0);
  ax.remove(0);
  return [ix, ax];
}

Array filter_raw_ppg(Array val) {
  //    final stopwatch = Stopwatch()..start();
  var fs = 100;
  var sample_sg = val;

  var nyq = 0.5 * fs; // nyquist frequency
  var fc = 1; // cut frequency 1Hz
  var normal_fc = fc / nyq; // frequency normalization for digital filters
  var numtaps = 30; // attenuation of the filter after cut frequency

  var b = firwin(numtaps, Array([normal_fc]));
//      print('b--- $b');
//      print('normal_fc--- $normal_fc');
  var ttt = Array([normal_fc]);
//      print('array-norm fc--- $ttt');
  var sgFiltered = lfilter(b, Array([1.0]), sample_sg);
//    print('doSomething() executed in ${stopwatch.elapsed}');

  return sgFiltered;
}

List linear_interp(double x1, double y1, double x2, double y2) {
  if (x1 > x2) {
    // keep x1 smaller than x2.
    var t;
    t = x1;
    x1 = x2;
    x2 = t;

    t = y1;
    y1 = y2;
    y2 = t;
  }
  var N = x2 - x1;
  var x;
  var y;
  Array result_y = Array.empty(); //
  for (int i = 0; i < N; i++) {
    x = x1 + i;
    y = (x - x1) * (y2 - y1) / (x2 - x1) + y1;
    result_y.add(y);
  }
  return result_y;
} //

List findlowtroughs(Array a, {double mindistance}) {
  //modify from scidart.findPeaks
  var N = a.length - 2;
  Array ix = Array.empty(); //ix -- index
  Array ax = Array.empty(); // ax -- value
  ix.add(0);
  ax.add(0);
  if (mindistance != null) {
    for (int i = 1; i <= N; i++) {
      if (a[i - 1] >= a[i] && a[i] <= a[i + 1]) {
        if (i - ix.last > mindistance) {
          //mindistance between two peaks
          ix.add(i.toDouble());
          ax.add(a[i]);
        }
      }
    }
  } else {
    for (int i = 1; i <= N; i++) {
      if (a[i - 1] >= a[i] && a[i] <= a[i + 1]) {
        ix.add(i.toDouble());
        ax.add(a[i]);
      }
    }
  }
  ix.remove(0);
  ax.remove(0);
  return [ix, ax];
}

List calculate_HR_RR_SPO2_TEMP(
    Array raw_IR_500, Array raw_RED_500, var last_500_temperature) {
  List processed_500_hr_rr_spo2_temp = [];

  // filtering signals
  var sgfiltered_IR = filter_raw_ppg(raw_IR_500);
  var sgfiltered_RED = filter_raw_ppg(raw_RED_500);

  // ------------------------------------IR signal processing------------------------
  var pk_IR = findTopPeaks(sgfiltered_IR, mindistance: 55);
  var troughs_IR = findlowtroughs(sgfiltered_IR, mindistance: 55);

  //fit a model that project pk_IR[0] to pk_IR[1]
  var u_x_IR = Array([]);
  var u_y_IR = Array([]);
  var l_x_IR = Array([]);
  var l_y_IR = Array([]);

  u_x_IR.add(0); //force u contains the last point of the filtered signal
  u_y_IR.add(sgfiltered_IR.first); //
  u_x_IR.addAll(pk_IR[0]);
  u_y_IR.addAll(pk_IR[1]);
  u_x_IR.add(sgfiltered_IR.length -
      1.0); //force u contains the last point of the filtered signal
  u_y_IR.add(sgfiltered_IR.last); //

  l_x_IR.add(0); //force u contains the last point of the filtered signal
  l_y_IR.add(sgfiltered_IR.first); //
  l_x_IR.addAll(troughs_IR[0]);
  l_y_IR.addAll(troughs_IR[1]);
  l_x_IR.add(sgfiltered_IR.length -
      1.0); //force u contains the last point of the filtered signal
  l_y_IR.add(sgfiltered_IR.last); //

  var q_u_IR = []; // the model for upper bound of IR signal
  var q_l_IR = []; // the model for lower bound of IR signal
  for (var k = 0; k < u_x_IR.length - 1; k++) {
    q_u_IR.addAll(
        linear_interp(u_x_IR[k], u_y_IR[k], u_x_IR[k + 1], u_y_IR[k + 1]));
  }
  for (var k = 0; k < l_x_IR.length - 1; k++) {
    q_l_IR.addAll(
        linear_interp(l_x_IR[k], l_y_IR[k], l_x_IR[k + 1], l_y_IR[k + 1]));
  }

  //print('---q_l_IR----');
  //print(q_l);
  //print('---q_u_IR----');
  // print(q_u_IR);
  // ------------------------------------RED signal processing------------------------
  var pk_RED = findTopPeaks(sgfiltered_RED, mindistance: 55);
  var troughs_RED = findlowtroughs(sgfiltered_RED, mindistance: 55);

  //fit a model that project pk_RED[0] to pk_RED[1]
  var u_x_RED = Array([]);
  var u_y_RED = Array([]);
  var l_x_RED = Array([]);
  var l_y_RED = Array([]);

  u_x_RED.add(0); //force u contains the last point of the filtered signal
  u_y_RED.add(sgfiltered_RED.first); //
  u_x_RED.addAll(pk_RED[0]);
  u_y_RED.addAll(pk_RED[1]);
  u_x_RED.add(sgfiltered_RED.length -
      1.0); //force u contains the last point of the filtered signal
  u_y_RED.add(sgfiltered_RED.last); //

  l_x_RED.add(0); //force u contains the last point of the filtered signal
  l_y_RED.add(sgfiltered_RED.first); //
  l_x_RED.addAll(troughs_RED[0]);
  l_y_RED.addAll(troughs_RED[1]);
  l_x_RED.add(sgfiltered_RED.length -
      1.0); //force u contains the last point of the filtered signal
  l_y_RED.add(sgfiltered_RED.last); //

  var q_u_RED = []; // the model for upper bound of IR signal
  var q_l_RED = []; // the model for lower bound of IR signal
  for (var k = 0; k < u_x_RED.length - 1; k++) {
    q_u_RED.addAll(
        linear_interp(u_x_RED[k], u_y_RED[k], u_x_RED[k + 1], u_y_RED[k + 1]));
  }
  for (var k = 0; k < l_x_RED.length - 1; k++) {
    q_l_RED.addAll(
        linear_interp(l_x_RED[k], l_y_RED[k], l_x_RED[k + 1], l_y_RED[k + 1]));
  }
//-----------------------------------calculate parameters for RR and SPO2 ----------------------------------------------
  var pp_RED = Array(q_u_RED.cast<double>()) - Array(q_l_RED.cast<double>());
  var pp_IR = Array(q_u_IR.cast<double>()) - Array(q_l_IR.cast<double>());
  print(sgfiltered_RED.length);
  var RR = (pp_RED / Array(q_l_RED.cast<double>())) /
      (pp_IR / Array(q_l_IR.cast<double>()));

  //---------------------------calculate SPO2------------------------------
  //SPO2=(-45.060*RR.^2)+30.354*RR+94.84;
  var SPO2 = Array.empty();
  SPO2 = arraySubToScalar(
      arrayMultiplyToScalar(arrayPow(RR, 2.0), -45.06) +
          arrayMultiplyToScalar(RR, 30.354),
      -94.84);

  print('SPO2 --- $SPO2');

  double final_spo2_ = SPO2.last;
//  String final_spo2_ = SPO2.last.toStringAsFixed(0);
//  await Future.delayed(const Duration(seconds: 5));

  //--------------------------------calculate RR------------------------------------------------

  // design a FIR filter low pass with cut frequency at 1Hz, the objective is,
  // remove the 10Hz sine wave signal,
  var fs = 100;
  var nyq = 0.5 * fs; // nyquist frequency,
  var fc = 1; // cut frequency 1Hz,
  var normal_fc = fc / nyq; // frequency normalization for digital filters,
  var numtaps = 30; // attenuation of the filter after cut frequency,
  // generation of the filter coefficients,
  var b = firwin(numtaps, Array([normal_fc]));
  var smoothed_pp_IR = lfilter(b, Array([1.0]), pp_IR);
  var pk_PP_IR = findTopPeaks(smoothed_pp_IR, mindistance: 120);
  //print(smoothed_pp_IR);
  //print(pk_PP_IR[0]);
  //print(pk_PP_IR[1]);

  var Resp = pk_PP_IR[0].length; // record how many breathing in the whole time.
  var time = sgfiltered_IR.length / 6000; // record how many minutes in the data
  var Resp_per_minute = Resp / time;
  print(Resp);
  print(Resp_per_minute);

  print('RR --- $Resp');
  print('RR per min --- $Resp_per_minute');
  double final_rr_ = Resp_per_minute;
//  String final_rr_ = Resp_per_minute.last.toStringAsFixed(0);

  //--------------------------------calculate Heart Rate-----------------------------------------

  double final_hr_ = calculate_HR(sgfiltered_IR);
//  String final_hr_ = calculated_hr.toStringAsFixed(0);

  //--------------------------------calculate temperature-----------------------------------------

  double final_temp_ = calculateTemperature(last_500_temperature);

  processed_500_hr_rr_spo2_temp.add(final_hr_);
  processed_500_hr_rr_spo2_temp.add(final_rr_);
  processed_500_hr_rr_spo2_temp.add(final_spo2_);
  processed_500_hr_rr_spo2_temp.add(final_temp_);

  return processed_500_hr_rr_spo2_temp;
}

// not red, it will be IR for heart rate
double calculate_HR(Array Filtered_signal) {
  double F_hr;
//    final stopwatch = Stopwatch()..start();
  var sgFiltered = Filtered_signal;

  print('--------peaks-------');
  var pk = findTopPeaks(sgFiltered, mindistance: 55);
  print(pk[0]); // print the indexes of the peaks found in the signal
  print(pk[1]); // print the values of the peaks found in the signal

  //calculate HR
  var diffArray = arrayDiff(pk[0]);
  var HRArray = Array([]); //contains HR for each second.
  print('-----diffArray----');
  print(diffArray);
  for (int i = 1; i < diffArray.length; i++) {
    HRArray.add(100 * 60 / diffArray[i]);
  }
  print('-----HRArray----');
  print(HRArray);

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

//averaging temperature value after each 10 sec
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

//String new_calculateTemperature(var sensordata) {
//  var T1 = (sensordata * 3.3) / 1024;
//  var T2 = T1 - 0.5;
//  var final_T = T2 / 0.01;
//  return final_T.toStringAsFixed(2);
//}
