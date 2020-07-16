import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/repositories/user_repository.dart';
import './bloc.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {

  final UserRepository userRepository;
  List<DocumentSnapshot> documentList = [];
  DoctorBloc({@required this.userRepository});

  @override
  DoctorState get initialState => InitialDoctorState();

  @override
  Stream<DoctorState> mapEventToState(
    DoctorEvent event,
  ) async* {
    if (event is FetchListDoctor) {
      yield* _mapDoctorsToState(event);
    } else if (event is FetchDoctorLoadMore) {
      yield* _mapFetchDoctorLoadMoreToState(event);
    } else if (event is InitDoctorEvent) {
      yield InitialDoctorState();
    }
  }

  Stream<DoctorState> _mapDoctorsToState(FetchListDoctor event) async* {
    yield LoadingFetchDoctor();
    final list = await userRepository.getListDoctor();
    if (list != null) {
      yield LoadSuccessFetchDoctor(list: list);
    } else {
      yield LoadErrorFetchDoctor();
    }
  }

  Stream<DoctorState> _mapFetchDoctorLoadMoreToState(FetchDoctorLoadMore event) async* {
    yield LoadingFetchDoctor();
    try {
      if (!event.isLoadMore) {
        documentList.clear();
      }
      final data = await userRepository.getDoctorLoadMore(documentList, event.major);
      documentList.addAll(data);
      print('_mapFetchDoctorLoadMoreToState isLoadMore: ${event.isLoadMore} documentList: ${documentList.length}');
      if (data != null) {
        final List<UserObj> list = data.map((document) {
          return UserObj.fromSnapshot(document);
        }).toList();
        yield LoadSuccessDoctorLoadMore(list: list);
        print('_mapFetchDoctorLoadMoreToState : ${data.length}');
      } else {
        yield LoadErrorFetchDoctor();
        print('error _mapFetchDoctorLoadMoreToState');
      }
    } catch(error) {
      yield LoadErrorFetchDoctor();
      print('error _mapFetchDoctorLoadMoreToState: $error');
    }
  }
}
