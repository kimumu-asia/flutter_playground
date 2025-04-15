import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_flutter/pages/login_page.dart';
import 'package:hello_flutter/pages/main_page.dart';
import 'package:provider/provider.dart';

import 'graphql/client.dart';
import 'viewModels/store_detail_view_model.dart';

void main() async {
  final client = await initializeGraphqlClient();

  runApp(
    GraphQLProvider(
      client: client,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => StoreDetailViewModel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, // 전체 배경색을 흰색으로 설정
        ),
        routes: {
          '/login': (context) => LoginPage(),
        });
  }
}
