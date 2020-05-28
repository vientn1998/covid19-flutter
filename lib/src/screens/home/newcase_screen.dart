import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/src/blocs/covid19/bloc.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/styles.dart';

class NewCasePage extends StatefulWidget {

  bool isNewCase = false;
  NewCasePage({Key key,@required this.isNewCase}): super(key: key);

  @override
  _NewCasePageState createState() => _NewCasePageState();
}

class _NewCasePageState extends State<NewCasePage> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.isNewCase) {
      BlocProvider.of<Covid19Bloc>(context).add(FetchAllCountryNewCase(isNewCase: true));
    } else {
      BlocProvider.of<Covid19Bloc>(context).add(FetchAllCountryNewCase(isNewCase: false));
    }

  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewCase ? 'New Case' : 'Deaths'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 0),
                    )
                  ],
                  shape: BoxShape.rectangle,
                  color: backgroundSearch

              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        hintText: "Search country name...",
                        border: InputBorder.none,
                      ),
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      autocorrect: false,
                      textInputAction: TextInputAction.search,
                      controller: _textEditingController,
                      onChanged: (value) {
                        if (widget.isNewCase) {
                          BlocProvider.of<Covid19Bloc>(context).add(FetchAllCountryNewCase(keySearch: value));
                        } else {
                          BlocProvider.of<Covid19Bloc>(context).add(FetchAllCountryNewCase(keySearch: value, isNewCase: true));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<Covid19Bloc, Covid19State>(
                builder: (context, state) {
                  if (state is Covid19LoadedNewCase) {
                    final list = state.list;
                    return NotificationListener(
                      child: ListView.builder(
                        itemCount: list.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return Container(
                              margin: EdgeInsets.only(
                                  left: 22, top: 8, right: 22, bottom: 8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: item.isTypeTotal ? Colors.yellow.withOpacity(0.4) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 0,
                                    blurRadius: item.isTypeTotal ? 0 : 8,
                                    offset: item.isTypeTotal ? Offset(0, 0) : Offset(0, 0.2), // changes position of shadow
                                  ),
                                ],
                              ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 16, right: 16, bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(item.country, style: kBodyBold,),
                                  Text(widget.isNewCase ? item.newCases : item.newDeaths, style: kBodyBoldW600,),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      onNotification: (notification) {
                        if (notification is ScrollStartNotification) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
