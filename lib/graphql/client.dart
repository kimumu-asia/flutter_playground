// lib/graphql/client.dart
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<ValueNotifier<GraphQLClient>> initializeGraphqlClient() async {
  //  1. 초기화
  await initHiveForFlutter();

  //  2. endpoint 설정
  final HttpLink baseUrl = HttpLink('https://gs-user-api.mutainer.com/graphql');

  //  3. 클라이언트 설정
  return ValueNotifier(
    GraphQLClient(
      link: baseUrl,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
}
