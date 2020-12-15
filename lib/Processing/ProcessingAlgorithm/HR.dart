import 'dart:io';
import 'package:scidart/numdart.dart';
import 'algorithm/findTopPeaks.dart';
import 'algorithm/sgfilter.dart';

//-------- FIR filter -----------//,
// generate the test signal for filter,
// a sum of sine waves with 1Hz and 10Hz, 50 samples and,
// sample frequency (fs) 100Hz,

// input = RED_SIGNAL_array (Array)
Array Process_HR(Array IR_SIGNAL_array){
  var fs = 60; // collecting frequency may need to be modified

  SgFilter filter = new SgFilter(4, 11);

  var sgFiltered = Array(filter.smooth(IR_SIGNAL_array));
  print(sgFiltered);
  // print('--------peaks-------');
  var pk = findTopPeaks(sgFiltered, mindistance: 5);
  // print(pk[0]); // print the indexes of the peaks found in the signal
  // print(pk[1]); // print the values of the peaks found in the signal

  //calculate HR
  var diffArray = arrayDiff(Array(pk[0].cast<double>()));
  var HRArray = Array([]); //contains HR for each second.
  //print('-----diffArray----');
  //print(diffArray);
  for (int i = 1; i < diffArray.length; i++) {
    HRArray.add(fs * 60 / diffArray[i]); //Heart beat per minute
  }
  print('-----HRArray----');
  print(HRArray);
  // double last_HR = HRArray.last;
  //
  // print('---last HR in the data----');
  // print(last_HR);
  return HRArray;
}
