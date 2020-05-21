import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';
import 'package:template_flutter/src/repositories/covid19/covid_api_client.dart';

class Covid19Repository {
  final Covid19ApiClient covid19apiClient;
  final List<OverviewObj> listData = [];

  Covid19Repository({@required this.covid19apiClient}) : assert(covid19apiClient != null);


  Future<OverviewObj> getDataOverview({String countryName}) async {
    final list = await covid19apiClient.getOverview();
    listData.clear();
    listData.addAll(list);
    if (countryName != null && countryName.isNotEmpty) {
      return list.firstWhere((element) => element.country == "Vietnam");
    } else {
      return list[0];
    }

  }

}