import 'package:equatable/equatable.dart';

class DeathsObj extends Equatable {
  int id;
  String date;
  int totalDeaths;
  String changeInTotal;

  Map<String, dynamic> toMap() {
    return {
      'date': this.date,
      'totalDeaths': this.totalDeaths,
      'changeInTotal': this.changeInTotal
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
      totalDeaths: int.parse(parsedJson['TotalDeaths'].toString().replaceAll(",", "")),
      changeInTotal: parsedJson['ChangeInTotal'],
    );
  }

  DeathsObj.clone(DeathsObj deathsObj, {String date, int totalDeaths})
      : this(
            date: date ?? deathsObj.date,
            totalDeaths: totalDeaths ?? deathsObj.totalDeaths);

  @override
  List<Object> get props => [this.date, this.changeInTotal, this.totalDeaths];
}
