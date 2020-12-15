import 'package:scidart/numdart.dart';
import 'algorithm/envelope.dart';
import 'algorithm/findTopPeaks.dart';
import 'algorithm/sgfilter.dart';


Process_RR(Array sgfiltered_IR){
  //-------- Digital filter application -----------//,
  SgFilter filter1 = new SgFilter(4, 11);
  //
  // var sgfiltered_IR = Array(filter1.smooth(IR_SIGNAL_array));
  // ------------------------------------IR signal processing------------------------
  //enveloping IR
  var enved_IR = envelope(sgfiltered_IR, 5);
  var upper_IR = enved_IR[0];
  var lower_IR = enved_IR[1];

  var pp_IR = new Array(
      Array(upper_IR.cast<double>()) - Array(lower_IR.cast<double>()));
//-----------------------------------calculate parameters for RR and SPO2 ----------------------------------------------
  var smoothed_pp_IR = Array(filter1.smooth(pp_IR));

  var pk_PP_IR = findTopPeaksRR(smoothed_pp_IR, mindistance: 5);
  print(smoothed_pp_IR);
  print(pk_PP_IR[0]);
  print(pk_PP_IR[1]);
  var collecting_frequency = 60; //-you may need to modify this for different devices
  var Resp = pk_PP_IR[0].length; // record how many breathing in the whole time.
  var time = sgfiltered_IR.length /
      collecting_frequency /
      60; // record how many minutes in the data
  var Resp_per_minute = Resp / time;
  // print("Duration in minues:");
  // print(time);
  // print("Times of breathing:");
  // print(Resp);
  // print("RR:");
  // print(Resp_per_minute);

  return Resp_per_minute;

}