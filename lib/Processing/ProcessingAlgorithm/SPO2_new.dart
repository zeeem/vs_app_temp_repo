import 'package:scidart/numdart.dart';
import 'algorithm/envelope.dart';
import 'algorithm/sgfilter.dart';


Process_SPO2(var sgfiltered_RED, var sgfiltered_IR){

  // //-------- Digital filter application -----------//,
  // SgFilter filter1 = new SgFilter(4, 11);
  //
  // var sgfiltered_RED = Array(filter1.smooth(RED_SIGNAL_array));
  // var sgfiltered_IR = Array(filter1.smooth(IR_SIGNAL_array));
  // //print(sgfiltered_IR);
  // //var sgfiltered_IR2 = Float64List.fromList(filter1.smooth(IR03));

  // ------------------------------------IR signal processing------------------------
  //enveloping RED
  var enved_RED = envelope(sgfiltered_RED, 5); //45
  var upper_RED = enved_RED[0];
  var lower_RED = enved_RED[1];
  //enveloping IR
  var enved_IR = envelope(sgfiltered_IR, 5);
  var upper_IR = enved_IR[0];
  var lower_IR = enved_IR[1];
  //print('----------Upper and lower IR/RED--');
  //print(upper_RED);
  //print('---------------------------------------------------/n');
  //print(lower_RED);
//-----------------------------------calculate parameters for RR and SPO2 ----------------------------------------------
  var pp_RED = new Array(
      Array(upper_RED.cast<double>()) - Array(lower_RED.cast<double>()));
  var pp_IR = new Array(
      Array(upper_IR.cast<double>()) - Array(lower_IR.cast<double>()));

  //--------------------------------calculate RR------------------------------------------------
  var RR = (pp_RED / Array(lower_RED.cast<double>())) /
      (pp_IR / Array(lower_IR.cast<double>()));

  //---------------------------calculate SPO2------------------------------
  //SPO2=(-45.060*RR.^2)+30.354*RR+94.84;
  var SPO2 = Array.empty();
  SPO2 = arraySubToScalar(
      arrayMultiplyToScalar(arrayPow(RR, 2.0), -45.06) +
          arrayMultiplyToScalar(RR, 30.354),
      -94.84);

  // print(SPO2);

  return SPO2;
}
