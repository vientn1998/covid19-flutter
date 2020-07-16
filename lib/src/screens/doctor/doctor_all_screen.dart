import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_bloc.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_state.dart';
import 'package:template_flutter/src/blocs/schedule/bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/models/key_value_model.dart';
import 'package:template_flutter/src/models/major_model.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/utils/global.dart' as globals;
class DoctorAllPage extends StatefulWidget {
  @override
  _DoctorAllPageState createState() => _DoctorAllPageState();
}

class _DoctorAllPageState extends State<DoctorAllPage> {

  TextEditingController _textEditingController;
  List<KeyValueObj> listMajor;
  List<ScheduleModel> listSchedule;
  ScrollController controller = ScrollController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    listSchedule = [];
    _textEditingController = TextEditingController();
//    listMajor.addAll(globals.listMajor);
    fetchData();
  }

  void _onRefresh() async{
    listSchedule.clear();
    print('_onRefresh');
    fetchData();
  }

  void _onLoading() async{
    BlocProvider.of<ScheduleBloc>(context).add(GetScheduleLoadMore(isLoadMore: true));
  }
  
  fetchData() {
    BlocProvider.of<ScheduleBloc>(context).add(GetScheduleLoadMore(isLoadMore: false));
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    controller.dispose();
    _refreshController.dispose();
    listSchedule.clear();
  }

  @override
  Widget build(BuildContext context) {
    print('DoctorAllPage');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Doctors'),
      ),
      body: BlocListener<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is LoadingFetchSchedule) {
            LoadingHud(context).show();
          } else if (state is ErrorFetchSchedule) {
            LoadingHud(context).dismiss();
          } else if (state is FetchAllTotalScheduleByDoctorSuccess) {
            _refreshController.loadComplete();
            _refreshController.refreshCompleted();
            LoadingHud(context).dismiss();
          } else if (state is InitialScheduleState) {
            fetchData();
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: backgroundSearch),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    hintText: "Search doctor by name, major...",
                    border: InputBorder.none,
                  ),
                  autofocus: false,
                  textCapitalization: TextCapitalization.words,
                  autocorrect: false,
                  textInputAction: TextInputAction.search,
                  controller: _textEditingController,
                  onChanged: (value) {},
                ),
              ),
//            Container(
//              child: _widgetCategory(listMajor),
//            ),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  enableTwoLevel: true,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child:BlocBuilder<ScheduleBloc, ScheduleState>(
                    builder: (context, state) {
                      if (state is LoadingFetchSchedule) {
                        return _widgetBuildListData(listSchedule);
                      } else if (state is ErrorFetchSchedule) {
                        return Text('ErrorFetchSchedule ...');
                      } else if (state is FetchAllTotalScheduleByDoctorSuccess) {
                        listSchedule.addAll(state.list);
                        return _widgetBuildListData(listSchedule);
                      }
                      return Text('Loading...');
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _widgetCategory(List<KeyValueObj> majors) {
    return ListView.separated(
      itemCount: majors.length,
      separatorBuilder: (context, index) => SizedBox(width: 10,),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final item = majors[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: colorIcon, width: 1),
            color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
            child: Text(item.value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textColor),),
          ),
        );
      },
    );
  }

  _widgetBuildListData(List<ScheduleModel> list) {
    return ListView.separated(
//      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = list[index];
        return Padding(
          padding: const EdgeInsets.all(50.0),
          child: Text('${index + 1} - ${item.id}'),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10,);
      },
      itemCount: list.length);
  }
}

