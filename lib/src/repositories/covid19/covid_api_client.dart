import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:template_flutter/src/models/covid19/deaths.dart';
import 'package:template_flutter/src/models/covid19/overview.dart';


class Covid19ApiClient {
  static final _baseUrl = 'covid19api.io';
  final _apiKey = '';
  final _contextRoot = '/api/v1';

  Map<String, String> get _headers =>
      {'Accept': 'application/json', 'user-key': _apiKey};

  Future<Map> request(
      {@required String path, Map<String, String> parameters}) async {
    final uri = Uri.https(_baseUrl, '$_contextRoot/$path', parameters);
    final results = await http.get(uri, headers: _headers);
    if (results.statusCode != 200) {
      throw Exception('error request api /$path');
    }
    final jsonObject = json.decode(results.body);
    print('fullUrl: ${uri.path}');
    print('parameters: $parameters');
    print('results: $jsonObject');
    return jsonObject;
  }

  Future<List<OverviewObj>> getOverview() async {
    try {
      final results = await request(path: 'AllReports', parameters: {
        'entity_id': '',
        'count': '10'
      });
      final list = results['reports'] as List;
      final reports = list.map<ReportsObj>((item) => ReportsObj.fromJson(item)).toList();
      return reports[0].listData[0];
    } on Exception catch (exception) {
      print(exception.toString());
    }
  }

  Future<List<DeathsObj>> getTotalDeaths() async {
    try {
      final results = await request(path: 'deaths');
      final list = results['deaths'] as List;
      final data = list.map<DeathsObj>((item) => DeathsObj.fromJson(item)).toList();
      return data;
    } on Exception catch (exception) {
      print(exception.toString());
    }
  }

}