import 'package:equatable/equatable.dart';

class DeathsObj extends Equatable {
  int id;
  String date;
  String totalDeaths;
  String changeInTotal;

  Map<String, dynamic> toMap() {
    return {
      'date' : this.date,
      'totalDeaths' : this.totalDeaths,
      'changeInTotal' : this.changeInTotal
    };
  }


  DeathsObj({
    this.date,
    this.totalDeaths,
    this.changeInTotal,
  });

  factory DeathsObj.fromJson(Map<String, dynamic> parsedJson) {
    return DeathsObj(
      date: parsedJson['Date'],
      totalDeaths: parsedJson['TotalDeaths'],
      changeInTotal: parsedJson['ChangeInTotal'],
    );
  }


  @override
  List<Object> get props => [
    this.date,
    this.changeInTotal,
    this.totalDeaths
  ];
}