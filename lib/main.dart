import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_flutter/pages/login_page.dart';
import 'package:hello_flutter/pages/main_page.dart';

import 'graphql/client.dart';

void main() async {
  final client = await initializeGraphqlClient();

  runApp(GraphQLProvider(
    client: client,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        routes: {
          '/login': (context) => LoginPage(),
        });
  }
}
