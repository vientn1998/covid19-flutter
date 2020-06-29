import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';

class MedicalExamination extends StatefulWidget {
  @override
  _MedicalExaminationState createState() => _MedicalExaminationState();
}

class _MedicalExaminationState extends State<MedicalExamination> with SingleTickerProviderStateMixin {
  TabController _tabController;
  static const heightFilter = 35.0;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("My Examination Schedule"),
        centerTitle: true,
        bottom: TabBar(
          indicator: UnderlineTabIndicator(
            insets: EdgeInsets.symmetric(horizontal: paddingNavi),
            borderSide: BorderSide(color: Colors.white, width: 3),
          ),
          labelColor: Colors.white,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15
          ),
          unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300
          ),
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          tabs: [
            new Tab(icon: new Icon(Icons.calendar_today, size: 20,)),
            new Tab(
              icon: new Icon(Icons.history, size: 20),
            )
          ],
          controller: _tabController,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          buildWidgetCalendar(),
          buildWidgetHistory(),
        ],
        controller: _tabController,),
    );
  }

  buildWidgetCalendar() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(paddingDefault),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('List Upcoming', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: heightFilter,
                width: heightFilter,
                child: Icon(Icons.sort),
              ),
            ],
          ),
        ),
        Expanded(
          child: buildListViewUpcoming(),
        )
      ],
    );
  }

  buildListViewUpcoming() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return buildUpcomingItem();
        },
        padding: EdgeInsets.only(top: 5, bottom: 10),
        separatorBuilder: (context, index) => Container(height: paddingDefault,),
        itemCount: 20
    );
  }

  buildUpcomingItem() {
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
          padding: const EdgeInsets.only(left: 12, top: 0, bottom: 0, right: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(top: 12, bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipOval(
                    child: Icon(Icons.calendar_today),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 10,),
              Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('07:00 - 08:00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor),),
                    SizedBox(height: 2,),
                    Text('Bs Nguyen Anh', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),),
                    SizedBox(height: 2,),
                    Text('Address',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textColor),),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 6,
                height: 94,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildWidgetHistory() {
    return Center(child: Text("This is notification Tab View"));
  }

}