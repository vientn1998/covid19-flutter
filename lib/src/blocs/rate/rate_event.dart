part of 'rate_bloc.dart';

abstract class RateEvent extends Equatable {
  const RateEvent();
  @override
  List<Object> get props => [];
}

class CreateRate extends RateEvent {
  final RateModel rateModel;
  CreateRate({@required this.rateModel});
}

class FetchRate extends RateEvent {
  final String idDoctor, idOrder;
  FetchRate({this.idDoctor = "", this.idOrder = ""});
}
