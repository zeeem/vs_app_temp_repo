import 'package:stats/stats.dart';
import 'package:scidart/numdart.dart';




List demo = [[79, 17, 95, 35.34], [100, 12, 100, 36.33], [92, 13, 97, 37.22], [73, 19, 96, 36.34], [95, 18, 96, 38.77], [76, 14, 95, 38.83], [91, 15, 96, 37.29], [70, 13, 97, 35.97], [99, 13, 95, 37.32], [95, 16, 93, 35.67], [90, 17, 94, 37.7], [98, 18, 93, 36.61], [74, 14, 96, 37.56], [72, 15, 96, 35.13], [90, 18, 96, 38.37], [85, 14, 97, 35.6], [93, 15, 96, 36.36], [82, 15, 94, 38.2], [84, 15, 96, 36.06], [80, 15, 96, 37.63], [94, 12, 100, 36.01], [100, 19, 98, 38.82], [70, 18, 100, 38.49], [76, 14, 99, 38.72], [73, 19, 93, 36.55], [86, 16, 99, 37.48], [94, 18, 99, 37.2], [80, 13, 93, 37.69], [89, 16, 100, 38.79], [88, 19, 96, 35.44], [80, 19, 96, 36.26], [87, 14, 96, 36.58], [100, 14, 94, 36.55], [91, 19, 93, 35.15], [72, 15, 94, 36.72], [70, 16, 93, 38.81], [85, 14, 98, 36.22], [95, 14, 93, 36.58], [97, 16, 93, 38.78], [99, 20, 93, 37.45], [76, 14, 97, 38.79], [84, 13, 97, 38.59], [99, 12, 96, 35.18], [87, 14, 95, 37.55], [88, 13, 100, 35.05], [94, 14, 98, 37.51], [100, 19, 93, 37.54],[79, 17, 95, 35.34], [100, 12, 100, 36.33], [92, 13, 97, 37.22], [73, 19, 96, 36.34], [95, 18, 96, 38.77], [76, 14, 95, 38.83], [91, 15, 96, 37.29], [70, 13, 97, 35.97], [99, 13, 95, 37.32], [95, 16, 93, 35.67], [90, 17, 94, 37.7], [98, 18, 93, 36.61], [74, 14, 96, 37.56], [72, 15, 96, 35.13], [90, 18, 96, 38.37], [85, 14, 97, 35.6], [93, 15, 96, 36.36], [82, 15, 94, 38.2], [84, 15, 96, 36.06], [80, 15, 96, 37.63], [94, 12, 100, 36.01], [100, 19, 98, 38.82], [70, 18, 100, 38.49], [76, 14, 99, 38.72], [73, 19, 93, 36.55], [86, 16, 99, 37.48], [94, 18, 99, 37.2], [80, 13, 93, 37.69], [89, 16, 100, 38.79], [88, 19, 96, 35.44], [80, 19, 96, 36.26], [87, 14, 96, 36.58], [100, 14, 94, 36.55], [91, 19, 93, 35.15], [72, 15, 94, 36.72], [70, 16, 93, 38.81], [85, 14, 98, 36.22], [95, 14, 93, 36.58], [97, 16, 93, 38.78], [99, 20, 93, 37.45], [76, 14, 97, 38.79], [84, 13, 97, 38.59], [99, 12, 96, 35.18], [87, 14, 95, 37.55], [88, 13, 100, 35.05], [94, 14, 98, 37.51], [100, 19, 93, 37.54],[79, 17, 95, 35.34], [100, 12, 100, 36.33], [92, 13, 97, 37.22], [73, 19, 96, 36.34], [95, 18, 96, 38.77], [76, 14, 95, 38.83], [91, 15, 96, 37.29], [70, 13, 97, 35.97], [99, 13, 95, 37.32], [95, 16, 93, 35.67], [90, 17, 94, 37.7], [98, 18, 93, 36.61], [74, 14, 96, 37.56], [72, 15, 96, 35.13], [90, 18, 96, 38.37], [85, 14, 97, 35.6], [93, 15, 96, 36.36], [82, 15, 94, 38.2], [84, 15, 96, 36.06], [80, 15, 96, 37.63], [94, 12, 100, 36.01], [100, 19, 98, 38.82], [70, 18, 100, 38.49], [76, 14, 99, 38.72], [73, 19, 93, 36.55], [86, 16, 99, 37.48], [94, 18, 99, 37.2], [80, 13, 93, 37.69], [89, 16, 100, 38.79], [88, 19, 96, 35.44], [80, 19, 96, 36.26], [87, 14, 96, 36.58], [100, 14, 94, 36.55], [91, 19, 93, 35.15], [72, 15, 94, 36.72], [70, 16, 93, 38.81], [85, 14, 98, 36.22], [95, 14, 93, 36.58], [97, 16, 93, 38.78], [99, 20, 93, 37.45], [76, 14, 97, 38.79], [84, 13, 97, 38.59], [99, 12, 96, 35.18], [87, 14, 95, 37.55], [88, 13, 100, 35.05], [94, 14, 98, 37.51], [100, 19, 93, 37.54]];

List processRange (List data, int range, [String vs_type, String mid_type="avg"]) {


  List output = [];
  int vs_index = 0;
  int start, end =0;

  int boundary = data.length~/range;

  switch (vs_type) {
    case "hr":
      vs_index = 0;
      break;
    case "rr":
      vs_index = 1;
      break;
    case "spo2":
      vs_index = 2;
      break;
    case "temp":
      vs_index = 3;
      break;

    default:
      vs_index = 0;
      break;

  }


  for(int i = 0; i < boundary; i++)
  {

    if(output.length<1)
    {
      start = 0;
      end = range;
    }
    else {
      start = end;
      end = end + range;
    }


    List temp_output = data.sublist(start, end);
    //print("out: ${temp_output},,, $start,,,,,, $end");

    Array list_to_process = Array.empty();
    for (int j = 0; j < temp_output.length; j++)
    { double column_value = temp_output[j][vs_index]*1.0;

    list_to_process.add(column_value);

    }

    temp_output = [];
    double avg_or_median;
    if(mid_type=="median")
      {
        avg_or_median = Stats.fromData(list_to_process).median;
      }
    else {
      avg_or_median = Stats.fromData(list_to_process).average;
    }


    List processed_output = [Stats.fromData(list_to_process).min, avg_or_median ,Stats.fromData(list_to_process).max];

    list_to_process = Array.empty();
    output.add(processed_output);
  }

  return output;
}


void show_thirty_min_data (List data)
{
  int length = data.length;
  data = data.sublist(length-1200,length);
  List out = [];
  List hr_out = processRange(data, length, "hr");
  List rr_out = [];
  List spo2_out = [];
  List temp_out = [];


}

