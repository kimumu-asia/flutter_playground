import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_flutter/models/store_item.dart';

import 'main_map_page.dart';

class MainPage extends StatelessWidget {
  static const String getStoresQuery = r'''
    query getStores {
      stores {
        storeName
      }
    }
  ''';

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  }),
            ],
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(120.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: 'Search',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          searchQuery = value;
                        },
                      ),
                    ),
                    TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.store)),
                        Tab(icon: Icon(Icons.map_outlined)),
                      ],
                    ),
                  ],
                ))),
        body: TabBarView(children: [
          Column(
            children: [
              Expanded(
                child: Query(
                  options: QueryOptions(
                    document: gql(getStoresQuery),
                  ),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (result.hasException) {
                      return Center(child: Text(result.exception.toString()));
                    }

                    final List<StoreItem> items =
                        (result.data?['stores'] as List)
                            .map((item) => StoreItem(
                                  storeName: item['storeName'],
                                  imageUrl: 'assets/images/burger.png',
                                ))
                            .toList();

                    return GridView.builder(
                      padding: EdgeInsets.all(7.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                      ),
                      itemCount: items
                          .where((item) => item.storeName.contains(searchQuery))
                          .length,
                      itemBuilder: (context, index) {
                        var filteredItems = items
                            .where(
                                (item) => item.storeName.contains(searchQuery))
                            .toList();
                        if (filteredItems.isEmpty) {
                          return Center(child: Text('No items found'));
                        }
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          elevation: 2,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage(filteredItems[index].imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                filteredItems[index].storeName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          MainMap(),
        ]),
      ),
    );
  }
}
