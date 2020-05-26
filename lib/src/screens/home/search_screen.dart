import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/src/blocs/local_search/bloc.dart';
import 'package:template_flutter/src/models/covid19/country.dart';
import 'package:template_flutter/src/utils/color.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<SearchBloc>(context).listCountryLocal.length > 0) {
      BlocProvider.of<SearchBloc>(context).add(LoadingSearch());
    } else {
      BlocProvider.of<SearchBloc>(context).add(LoadingSearchFile(context: context));
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
        title: Text('Search'),

      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: backgroundSearch
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  hintText: "Search country name...",
                  border: InputBorder.none,
                ),
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                textInputAction: TextInputAction.search,
                controller: _textEditingController,
                onChanged: (value) {
                  print('text change $value');
                  BlocProvider.of<SearchBloc>(context).add(FetchSearchFile(keySearch: value));
                },
              ),
            ),
            Expanded(
              child: Container(
                child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is LoadingSearchLocal) {
                    return Center(
                      child: Text('Loading LoadingSearchLocal'),
                    );
                  }
                  if (state is LoadedSearchLocal) {
                    final data = state.list;
                    return _buildDataLocal(data);
                  }
                  if (state is LoadingFile) {
                    return Center(
                      child: Text('Loading LoadingSearchFile'),
                    );
                  }
                  if (state is LoadedSearchFile) {
                    final data = state.list;
                    return _buildDataFile(data, context);
                  }
                  return Center(
                    child: Text('Loading default'),
                  );
                },
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDataLocal(List<CountryObj> data) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (BuildContext ctx, int i) {
          final item = data[i];
          return ListTile(
              leading: Icon(Icons.history),
              title: Text(item.countryName),

              onTap: () {
                Navigator.pop(context, item);
              },

              trailing: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    BlocProvider.of<SearchBloc>(context).add(DeleteSearch(countryObj: item));
                  }
              )
          );
        }
    );
  }

  _buildDataFile(List<CountryObj> data, BuildContext context) {
    print('length ${data.length}');
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (ctx, i) {
          final item = data[i];
          return ListTile(
              leading: Icon(Icons.location_on),
              title: Text(item.countryName),

              onTap: () {
                BlocProvider.of<SearchBloc>(context).add(AddSearch(countryObj: CountryObj(country: item.country, countryName: item.countryName, countrySearch: item.countrySearch)));
                Navigator.pop(context, item);
              },
          );
        }
    );
  }
}
