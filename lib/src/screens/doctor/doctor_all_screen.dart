import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:template_flutter/src/blocs/doctor/bloc.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_bloc.dart';
import 'package:template_flutter/src/blocs/doctor/doctor_state.dart';
import 'package:template_flutter/src/blocs/schedule/bloc.dart';
import 'package:template_flutter/src/blocs/user/bloc.dart';
import 'package:template_flutter/src/models/key_value_model.dart';
import 'package:template_flutter/src/models/location_model.dart';
import 'package:template_flutter/src/models/major_model.dart';
import 'package:template_flutter/src/models/schedule_model.dart';
import 'package:template_flutter/src/models/user_model.dart';
import 'package:template_flutter/src/utils/calculate.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/styles.dart';
import 'package:template_flutter/src/utils/global.dart' as globals;

import 'doctor_details_screen.dart';

class DoctorAllPage extends StatefulWidget {

  LocationObj currentLocation;

  DoctorAllPage({@required this.currentLocation});

  @override
  _DoctorAllPageState createState() => _DoctorAllPageState();
}

class _DoctorAllPageState extends State<DoctorAllPage> {

  TextEditingController _textEditingController;
  List<KeyValueObj> listMajor;
  List<UserObj> listDoctor;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  var isEnableLoading = true;
  int indexSelected = 0;
  @override
  void initState() {
    super.initState();
    listDoctor = [];
    listMajor = [];
    _textEditingController = TextEditingController();
    listMajor.add(KeyValueObj(key: "all", value: "All"));
    listMajor.addAll(globals.listMajor);
    fetchData();
  }

  void _onRefresh() async{
    listDoctor.clear();
    fetchData();
  }

  void _onLoading() async{
    if (indexSelected == 0) {
      BlocProvider.of<DoctorBloc>(context).add(FetchDoctorLoadMore(isLoadMore: true));
    } else {
      BlocProvider.of<DoctorBloc>(context).add(FetchDoctorLoadMore(isLoadMore: true, major: listMajor[indexSelected]));
    }
  }
  
  fetchData() {
    if (indexSelected == 0) {
      BlocProvider.of<DoctorBloc>(context).add(FetchDoctorLoadMore(isLoadMore: false));
    } else {
      BlocProvider.of<DoctorBloc>(context).add(FetchDoctorLoadMore(isLoadMore: false, major: listMajor[indexSelected]));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    listDoctor.clear();
  }

  @override
  Widget build(BuildContext context) {
    print('DoctorAllPage');
    return Scaffold(
      backgroundColor: backgroundSearch,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Doctors'),
      ),
      body: BlocListener<DoctorBloc, DoctorState>(
        listener: (context, state) {
          if (state is LoadingFetchDoctor) {
            LoadingHud(context).show();
          } else if (state is LoadErrorFetchDoctor) {
            LoadingHud(context).dismiss();
          } else if (state is LoadSuccessDoctorLoadMore) {
            LoadingHud(context).dismiss();
            print('LoadSuccessDoctorLoadMore: all');
            _refreshController.loadComplete();
            _refreshController.refreshCompleted();
          } else if (state is InitialDoctorState) {
            fetchData();
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      margin: EdgeInsets.all(paddingDefault),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white),
                      child: Center(
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
                    ),
                  ),
                  Material(
                    child: InkWell(
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),),
                        child: Center(child: Icon(Icons.sort)),
                      ),
                      onTap: () {

                      },
                      borderRadius: BorderRadius.circular(8),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  SizedBox(width: paddingDefault,)
                ],
              ),
              Container(
                height: 45,
                width: double.infinity,
                child: _widgetCategory(listMajor),
              ),
              SizedBox(height: heightSpaceSmall,),
              Expanded(
                child: BlocBuilder<DoctorBloc, DoctorState>(
                  builder: (context, state) {
                    if (state is LoadingFetchDoctor) {
                      return _widgetBuildListData(listDoctor);
                    } else if (state is LoadErrorFetchDoctor) {
                      return Text('ErrorFetchSchedule ...');
                    } else if (state is LoadSuccessDoctorLoadMore) {
                      listDoctor.clear();
                      final List<UserObj> ls = [];
                      state.list.forEach((item) {
                        if (widget.currentLocation != null && widget.currentLocation.latitude != null && widget.currentLocation.longitude != null) {
                          item.location.distance = calculateDistance(item.location.latitude, item.location.longitude, widget.currentLocation.latitude, widget.currentLocation.longitude);
                        }
                        ls.add(item);
                      });
                      listDoctor.addAll(ls);
                      if (state.list.length < 10) {
                        isEnableLoading = false;
                      }
                      return _widgetBuildListData(listDoctor);
                    }
                    return Text('Loading...');
                  },
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
      padding: EdgeInsets.only(left: paddingDefault, right: paddingDefault),
      itemBuilder: (context, index) {
        final item = majors[index];
        return Material(
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: colorIcon, width: 0.7),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text(item.value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: indexSelected == index ? Colors.white : textColor),),
                ),
              ),
            ),
            onTap: () {
              listDoctor.clear();
              setState(() {
                indexSelected = index;
              });
              fetchData();
            },
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          color: indexSelected == index ? Colors.blueGrey : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        );
      },
    );
  }

  _widgetBuildListData(List<UserObj> data) {
    if (data.length == 0) {
      return Center(
        child: Text("Empty"),
      );
    }
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: isEnableLoading,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.separated(
        itemBuilder: (context, index) {
          final item = data[index];
          return _buildDoctor(item, () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => DoctorDetailsPage(userObj: item,),
            ));
          });
        },
        padding: EdgeInsets.only(top: 5, bottom: paddingDefault),
        separatorBuilder: (context, index) {
          return SizedBox(height: paddingDefault,);
        },
        itemCount: data.length),
    );
  }

  _buildDoctor(UserObj item, Function function) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(right: paddingDefault, left: paddingDefault),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 1),
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipOval(
                    child: _buildImageAvatar(item),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(item.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),),
                    SizedBox(height: 5,),
                    Text(item.getNameMajor(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor), maxLines: 2, overflow: TextOverflow.ellipsis,),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.star, color: Colors.yellow, size: 20,),
                            Text(' 4.5',style: TextStyle(
                                fontSize: 15, color: textColor, fontWeight: FontWeight.w400
                            ),),
                            Text(' (20 reviews)',style: TextStyle(
                                fontSize: 15, color: textColor, fontWeight: FontWeight.w400
                            ),),
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: colorIcon, size: 18,),
                            Text('${item.location.distance.toStringAsFixed(1)} km', style: TextStyle(
                                fontSize: 15, color: textColor, fontWeight: FontWeight.w400
                            ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: function,
    );
  }

  _buildImageAvatar(UserObj item) {
    if (item.avatar != null) {
      return CachedNetworkImage(
        imageUrl: item.avatar,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Center(
          child: Icon(Icons.perm_identity),
        ),
      );
    } else {
      return Center(
        child: Icon(Icons.perm_identity),
      );
    }
  }

}

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length+1).toString());
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.separated(
          itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
          separatorBuilder: (context, index) => Container(height: 50,),
          itemCount: items.length,
        ),
      ),
    );
  }
}

