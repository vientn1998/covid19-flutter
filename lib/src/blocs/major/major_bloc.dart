import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:template_flutter/src/models/key_value_model.dart';
import 'package:template_flutter/src/repositories/major_repository.dart';
import './bloc.dart';

class MajorBloc extends Bloc<MajorEvent, MajorState> {

  MajorRepository majorRepository;

  MajorBloc(this.majorRepository);

  @override
  MajorState get initialState => InitialMajorState();

  @override
  Stream<MajorState> mapEventToState(
    MajorEvent event,
  ) async* {
    if (event is FetchMajor) {
      yield* _mapFetchDataMajorToState();
    }
  }

  Stream<MajorState> _mapFetchDataMajorToState() async* {
    yield LoadingMajor();
    print('_mapFetchDataMajorToState');
    List<KeyValueObj> list = [];
    await majorRepository.getListMajor().then((value) {
      final item = value.documents.map((document) => KeyValueObj.fromDocument(document)).toList();
      print('LoadedSuccessMajor ${item.length}');
      list.addAll(item);
    }).catchError((error) {
      LoadedErrorMajor();
    });
    yield LoadedSuccessMajor(list: list);
    print('_mapFetchDataMajorToState');
  }
}
