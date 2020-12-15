import 'package:scidart/numdart.dart';
import 'dart:math';
import 'package:linalg/linalg.dart';
import 'package:stats/stats.dart';

List get_peaks_boundary(List peaks) {
  List boundary_list = [];
  double boundary_y;
  boundary_list.add((peaks[0] + 2 * peaks[1] + peaks[2]) / 4);
  int n = peaks.length - 3;
  for (int i = 0; i <= n; i++) {
    boundary_y = (peaks[i] + 2 * peaks[i + 1] + peaks[i + 2]) / 4;
    boundary_list.add(boundary_y);
  }
  boundary_list.add((peaks[n] + 2 * peaks[n + 1] + peaks[n + 2]) / 4);
  return boundary_list;
}

List<double> cubicSplineInterpolation(
    List<dynamic> x, List<dynamic> v, List<dynamic> xq) {
  // ans
  List<double> ans = [];

  // Matrix objects. Ease the calculation.
  Array2d M;
  Array2d R;
  Array2d P;

  // attributes of iMatrix
  int sizeMatrix = 4 * (x.length - 1);
  int fromValEqual = 0;
  int toValEqual = x.length - 1;
  int fromFirstDerivative = (x.length - 1) * 2;
  int toFirstDerivative = 3 * x.length - 4;
  int fromSecDerivative = 3 * x.length - 4;
  int toSecDerivative = 4 * x.length - 6;
  int nKnot1 = 4 * x.length - 6;
  int nKnot2 = 4 * x.length - 5;

  // iMatrix X params = response
  List<List<double>> iMatrix = [];
  List<List<double>> response = [];

  // initialize response vector
  for (int i = 0; i < 4 * (x.length - 1); i++) {
    response.add([0]);
  }
  for (int i = 0; i < x.length - 1; i++) {
    response[i * 2][0] = v[i];
    response[i * 2 + 1][0] = v[i + 1];
  }

  // initialize iMatrix
  for (int i = 0; i < 4 * (x.length - 1); i++) {
    List<double> tempRow = [];
    for (int j = 0; j < 4 * (x.length - 1); j++) {
      tempRow.add(0);
    }
    iMatrix.add(tempRow);
  }

  // filling up iMatrix
  // Filling up the value equality part
  for (int i = fromValEqual; i < toValEqual; i++) {
    for (int j = i * 4; j < (i + 1) * 4; j++) {
      int exp = j - i * 4;
      iMatrix[2 * i][j] = pow(x[i], exp);
      iMatrix[2 * i + 1][j] = pow(x[i + 1], exp);
    }
  }

  // Filling up the first derivatives
  for (int i = fromFirstDerivative; i < toFirstDerivative; i++) {
    for (int j = 4 * (i - 2 * (x.length - 1));
        j < 4 * (i - 2 * (x.length - 1) + 1);
        j++) {
      int exp = j - 4 * (i - 2 * (x.length - 1)) - 1;

      // first part
      iMatrix[i][j] = (exp + 1) * pow(x[i - fromFirstDerivative + 1], exp);
      if (exp < 0) {
        iMatrix[i][j] = 0;
      }

      // second part
      iMatrix[i][j + 4] = (exp + 1) * -pow(x[i - fromFirstDerivative + 1], exp);
      if (exp < 0) {
        iMatrix[i][j + 4] = 0;
      }
    }
  }

  // Filling up the second derivative part
  for (int i = fromSecDerivative; i < toSecDerivative; i++) {
    for (int j = 4 * (i - fromSecDerivative);
        j < 4 * (i - fromSecDerivative + 1);
        j++) {
      int exp = j - 4 * (i - fromSecDerivative) - 2;

      // first part
      if (exp < 0) {
        iMatrix[i][j] = 0;
      } else if (exp == 0) {
        iMatrix[i][j] = 2;
      } else {
        iMatrix[i][j] = 6 * x[i - fromSecDerivative + 1];
      }

      // second part
      if (exp < 0) {
        iMatrix[i][j + 4] = 0;
      } else if (exp == 0) {
        iMatrix[i][j + 4] = -2;
      } else {
        iMatrix[i][j + 4] = -6 * x[i - fromSecDerivative + 1];
      }
    }
  }

  // not-knot case
  iMatrix[nKnot1][2] = 2;
  iMatrix[nKnot1][3] = 6 * (x[0]);
  iMatrix[nKnot2][sizeMatrix - 2] = 2;
  iMatrix[nKnot2][sizeMatrix - 1] = 6 * (x[x.length - 1]);

  // Finished initializing the interpolation matrix. Convert them to Matrix objects
  M = new Array2d.empty();
  R = new Array2d.empty();

  // converting iMatrix
  for (List<double> row in iMatrix) {
    Array tempRow = new Array(row);
    M.add(tempRow);
  }

  // converting response
  for (List<double> row in response) {
    Array tempRow = new Array(row);
    R.add(tempRow);
  }
  P = matrixSolve(M, R); //  matrixDot(Minv, R);

  // Interpolating xq
  int counter = 0;
  for (int i = 0; i < xq.length; i++) {
    if (xq[i] > x[counter + 1] && counter < x.length - 2) {
      counter++;
    }
    double p1 = P.elementAt(counter * 4 + 0).elementAt(0);
    double p2 = P.elementAt(counter * 4 + 1).elementAt(0);
    double p3 = P.elementAt(counter * 4 + 2).elementAt(0);
    double p4 = P.elementAt(counter * 4 + 3).elementAt(0);
    ans.add(p1 + p2 * pow(xq[i], 1) + p3 * pow(xq[i], 2) + p4 * pow(xq[i], 3));
  }

  return ans;
}

List findLowTroughs(List a, {double mindistance}) {
  //modify from scidart.findPeaks
  var N = a.length - 2;
  List ix = []; //ix -- index
  List ax = []; // ax -- value
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
  var boundary = get_peaks_boundary(ax);
  var ix_final = [];
  var ax_final = [];
  for (int i = 0; i < ax.length; i++) {
    //remove high troughs
    if (ax[i] <= boundary[i]) {
      ix_final.add(ix[i]);
      ax_final.add(ax[i]);
    }
  }
  return [ix_final, ax_final];
}

List findTopPeaks(List a, {double mindistance}) {
  //modify from scidart.findPeaks
  var N = a.length - 2;
  List ix = []; //ix -- index
  List ax = []; // ax -- value
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
  var boundary = get_peaks_boundary(ax);
  var ix_final = [];
  var ax_final = [];
  for (int i = 0; i < ax.length; i++) {
    //remove small peaks
    if (ax[i] >= boundary[i]) {
      ix_final.add(ix[i]);
      ax_final.add(ax[i]);
    }
  }
  return [ix_final, ax_final];
}

List findTopPeaksRR(List a, {double mindistance}) {
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

/// Calculate the envelope of a sequence of signal
/// Argument
///   - x: List<double>, currently only support double.
///   - frameLen: int, the frame length to calculate the peak.
/// return
///   - List<List<double>>, the upper and lower envelope of the signal.
List<List<double>> envelope(List<double> x, int frameLen) {
  // validate type of x
  if (x[0].runtimeType != 0.runtimeType &&
      x[0].runtimeType != 0.0.runtimeType) {
    throw FormatException("x can only be List<double>. Get: ${x.runtimeType}");
  } else if (x[0].runtimeType == 0.runtimeType) {
    // change to List<double> if x.runtimeType == List<int>
    for (int i = 0; i < x.length; i++) {
      x[i] = x[i] * 1.0;
    }
  }

  List xq = linspace(0, (x.length - 1) * 1.0, num: x.length).toList();

  // find the upper envelope
  List bounds = findTopPeaks(Array(x), mindistance: frameLen * 1.0);
  List iPk = bounds[0].toList();
  List vPk = [];

  for (int i = 0; i < iPk.length; i++) {
    iPk[i] *= 1.0;
  }

  if (iPk.length < 2) {
    iPk.add(x.length);
    iPk.insert(0, 1);
  }

  // Filling up vPk
  for (double i in iPk) {
    vPk.add(x[i.toInt()]);
  }

  // get the upper envelope
  List yUp = cubicSplineInterpolation(iPk, vPk, xq);

  // =====
  // find the lower envelope
  bounds = findLowTroughs(Array(x), mindistance: frameLen * 1.0);

  iPk = bounds[0].toList();
  vPk = [];

  for (int i = 0; i < iPk.length; i++) {
    iPk[i] *= 1.0;
  }

  if (iPk.length < 2) {
    iPk.add(x.length);
    iPk.insert(0, 1);
  }

  // Filling up vPk
  for (double i in iPk) {
    vPk.add(x[i.toInt()]);
  }

  // get the upper envelope
  List yLow = cubicSplineInterpolation(iPk, vPk, xq);

  return [yUp, yLow];
}

class SgFilter {
  int _order;
  int _frameLength;
  int _size;
  Matrix _kernel;

  /// The constructor for SgFilter
  /// Arguments:
  ///   - _order: int, the order of polynomial.
  ///   - _frameLength: int, the windows size for smoothing.
  /// Return:
  ///   - SgFilter
  SgFilter(this._order, this._frameLength) {
    _size = _frameLength ~/ 2;
    _kernel = this._buildKernel();
  }

  /// Build the kernel for smoothing
  /// Arguments:
  ///   - void
  /// Return:
  ///   - Matrix: the kernel for smoothing
  Matrix _buildKernel() {
    List<double> baseSeq = [];
    List<List<double>> tempMatrix = [];
    Matrix matrix;
    Matrix kernel;

    // construct base sequence
    for (int i = -_size; i <= _size; i++) {
      baseSeq.add(i.toDouble());
    }

    // fill the tempMatrix
    for (int i = 0; i < _order; i++) {
      List<double> tempSeq = [];

      // make row
      for (double val in baseSeq) {
        tempSeq.add(pow(val, i));
      }

      // add row
      tempMatrix.add(tempSeq);
    }

    // convert List<List<double>> to Matrix
    matrix = new Matrix(tempMatrix).transpose();

    // Calculate the kernel
    kernel =
        matrix * (matrix.transpose() * matrix).inverse() * matrix.transpose();

    return kernel;
  }

  /// Smooth given data
  /// Arguments:
  ///   - x: List<dynamic>, input data, only support int/double type.
  /// Return:
  ///   - List<dynamic>: Data after smoothing
  /// Throws:
  ///   - FormatException:
  ///      - if the data type is neither int nor double.
  ///      - Or the input length < _frameLength
  List<dynamic> smooth(List<dynamic> x) {
    List<double> dataAfterSmooth = [];
    List<double> inputData = [];

    // validate input data
    if (x.length < _frameLength) {
      throw FormatException(
          "The length of input must be >= _frameLength. (_frameLength=$_frameLength; input=${x.length})");
    }
    if (x[0].runtimeType != 0.runtimeType &&
        x[0].runtimeType != 1.0.runtimeType) {
      throw FormatException(
          "Only support int/double, get: ${x[0].runtimeType}!");
    }

    // convert List<int> to List<double> if needed
    if (x[0].runtimeType == 0.runtimeType) {
      for (int val in x) {
        inputData.add(val * 1.0);
      }
    } else {
      inputData = x;
    }

    // add padding
    // adding padding in the front
    for (int i = 0; i < _size; i++) {
      inputData.insert(0, 1);
    }

    // adding padding at the end
    for (int i = 0; i < _size; i++) {
      inputData.insert(_size - 1, 1);
    }

    // smoothing input data
    for (int i = _size; i < inputData.length - _size; i++) {
      List<List<double>> tempWin = [
        inputData.sublist(i - _size, i + _size + 1)
      ];
      Matrix windowX = new Matrix(tempWin).transpose();
      dataAfterSmooth.add((_kernel * windowX)[_size][0]);
    }
    return dataAfterSmooth;
  }

  /// getters
  int get order {
    return _order;
  }

  int get frameLength {
    return _frameLength;
  }

  Matrix get kernel {
    return _kernel;
  }
}

//showing the most recent HR calculated from IR PPG
double calculateHR(Array sgFiltered, int fs) {
  //print('--------peaks-------');
  var pk = findTopPeaks(sgFiltered, mindistance: 5);
  //print(pk[0]); // print the indexes of the peaks found in the signal
  //print(pk[1]); // print the values of the peaks found in the signal

  //calculate HR
  var diffArray = arrayDiff(Array(pk[0].cast<double>()));
  var HRArray = Array([]); //contains HR for each second.
  //print('-----diffArray----');
  //print(diffArray);
  for (int i = 1; i < diffArray.length; i++) {
    HRArray.add(fs * 60 / diffArray[i]); //Heart beat perminute
  }
  //print('-----HRArray----');
  //print(HRArray);
  var last_HR = HRArray.last;

  //print('---last HR in the data----');
  //print(last_HR);
  // return last_HR;

  double F_hr;

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

List calculateSPO2andRR(Array sgfiltered_RED, Array sgfiltered_IR, int fs) {
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

  //print(SPO2);
  //print(SPO2.last);
  //------------------------calculate RR-------------------------------------
  SgFilter filter = new SgFilter(4, 11);
  var smoothed_pp_IR = Array(filter.smooth(pp_IR));
  var pk_PP_IR = findTopPeaksRR(smoothed_pp_IR, mindistance: 5);
  //print(smoothed_pp_IR);
  //print(pk_PP_IR[0]);
  //print(pk_PP_IR[1]);
  var collecting_frequency =
      100; //-you may need to modify this for different devices
  var Resp = pk_PP_IR[0].length; // record how many breathing in the whole time.
  var time = sgfiltered_IR.length /
      collecting_frequency /
      60; // record how many minutes in the data
  var Resp_per_minute = Resp / time;
  //print("Duration in minues:");
  //print(time);
  //print("Times of breathing:");
  //print(Resp);
  //print("RR:");
  //print(Resp_per_minute);

  return [SPO2.last, Resp_per_minute];
}

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

List calculate_HR_RR_SPO2_TEMP(Array IR, Array RED, Array sensor_tem_data, {int fs = 60}) {

  // List processed_500_hr_rr_spo2_temp = [];

  //-------- Digital filter application -----------//,
  SgFilter filter1 = new SgFilter(4, 11);

  var sgfiltered_RED = Array(filter1.smooth(RED));
  var sgfiltered_IR = Array(filter1.smooth(IR));
  var HR = calculateHR(sgfiltered_IR, fs);
  List SPO2_RR_list = calculateSPO2andRR(sgfiltered_RED, sgfiltered_IR, fs);
  var SPO2 = SPO2_RR_list[0];
  var RR = SPO2_RR_list[1];
  var TEM = calculateTemperature(sensor_tem_data);
  // print('The values in order of HR, SPO2, RR, TEM are: ${[HR, SPO2, RR, TEM]}');
  return [HR, RR, SPO2, TEM];
}
//
// void main() {
//   //testing
//
//   var results = calculateVS(IR03, RED03, sensor_tem_data, fs: 100);
//   print('results list: ${results}');
// }

// // function from VS new page
// count++;
//
// print('count ---->>> $count');
// if (count == 301) {
// print('calculating result............');
// var reslt = calculate_HR_RR_SPO2_TEMP(RED_raw_500, IR_raw_500, TEMP_raw_500);
//
// setState(() {
// final_HR_to_show = reslt[0].toStringAsFixed(0);
// final_RR_to_show = reslt[1].toStringAsFixed(0);
// final_SPO2_to_show = reslt[2].toStringAsFixed(0);
// final_temp_to_show = reslt[3].toStringAsFixed(1);
// });
// print('result ---->> $reslt');
// count=1;
// }
