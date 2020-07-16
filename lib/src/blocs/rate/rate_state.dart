part of 'rate_bloc.dart';

abstract class RateState extends Equatable {
  const RateState();
  @override
  List<Object> get props => [];
}

class RateInitial extends RateState {
  @override
  List<Object> get props => [];
}

class LoadingCreateSchedule extends RateState {
}

class CreateRateSuccess extends RateState {
}

class ExistsRate extends RateState {
  final RateModel rateModel;
  ExistsRate(this.rateModel);
}

class ErrorCreateRate extends RateState {
  String messageError;
  ErrorCreateRate(this.messageError);
}

class LoadingFetchRate extends RateState {
}

class ErrorFetchRate extends RateState {
}

class FetchRateSuccess extends RateState {
  final List<RateModel> list;
  FetchRateSuccess({@required this.list});
  @override
  List<Object> get props => [this.list];
}