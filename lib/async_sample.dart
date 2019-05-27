// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
/*
import 'dart:async';

Future<int> printAuth() async {
  var authId = await gatherAuth();
  print('inside $authId');
  return authId;
}

Future<int> printUser() async {
  var userId = await gatherUser();
  print('inside $userId');
  return userId;
}

main()  async {
  var authId = await printAuth();
  print(authId);
  var userId = await printUser();
  print(userId);
  printWinningLotteryNumbers();
  printWeatherForecast();
  printBaseballScore();
}

printWinningLotteryNumbers() {
  print('Winning lotto numbers: [23, 63, 87, 26, 2]');
}

printWeatherForecast() {
  print("Tomorrow's forecast: 70F, sunny.");
}

printBaseballScore() {
  print('Baseball score: Red Sox 10, Yankees 0');
}

const authId = 1;
const userId = 2;
const oneSecond = Duration(seconds: 1);

// Imagine that this function is more complex and slow. :)
Future<int> gatherAuth() =>
    Future.delayed(oneSecond, () => authId);
Future<int> gatherUser() =>
    Future.delayed(oneSecond, () => userId);

// Alternatively, you can get news from a server using features
// from either dart:io or dart:html. For example:
//
// import 'dart:html';
//
// Future<String> gatherNewsReportsFromServer() => HttpRequest.getString(
//      'https://www.dartlang.org/f/dailyNewsDigest.txt',
//    );
*/