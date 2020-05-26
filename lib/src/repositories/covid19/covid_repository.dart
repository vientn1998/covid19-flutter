import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/covid19/deaths.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';
import 'package:template_flutter/src/repositories/covid19/covid_api_client.dart';

class Covid19Repository {
  final Covid19ApiClient covid19apiClient;
  Covid19Repository({@required this.covid19apiClient}) : assert(covid19apiClient != null);


  Future<List<OverviewObj>> getDataOverview({String countryName}) async {
    final listData = await covid19apiClient.getOverview();
    return listData;
  }

  Future<List<DeathsObj>> getTotalDeaths() async {
    final listData = await covid19apiClient.getTotalDeaths();
    return listData;
  }
}