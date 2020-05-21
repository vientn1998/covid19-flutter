import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';
import 'package:template_flutter/src/repositories/covid19/covid_api_client.dart';

class Covid19Repository {
  final Covid19ApiClient covid19apiClient;

  Covid19Repository({@required this.covid19apiClient}) : assert(covid19apiClient != null);


  Future<OverviewObj> getDataOverview() async {
    return covid19apiClient.getOverview();
  }

}