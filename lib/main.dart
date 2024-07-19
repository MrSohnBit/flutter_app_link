import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_link/deep_link.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _displayText = '';

  Future<void> _openWebPageLandingUrl(DeepLink data) async {
    String payload =
        '{'
        '"type": "${data.type}",'
        '"landingType": "${data.landingType}",'
        '"landingUrl": "${data.landingUrl}",'
        '"storeId": ${_displayText == '' ? -1 : int.parse(_displayText)},'
        '"bankAccountId": "${data.bankAccountId}",'
        '"reportMessageId": "${data.reportMessageId}"'
        '}';
    print(payload);
    _openWebPage(payload);
  }
  // Future<void> _openWebPageLandingUrl(String landingUrl) async {
  //   String payload =
  //       "{"
  //       "'type': 'storeInfo',"
  //       "'landingType': 'inapp',"
  //       "'landingUrl': '$landingUrl',"
  //       "'storeId': $_displayText,"
  //       "'bankAccountId': '0',"
  //       "'reportMessageId': '0'"
  //       "}";
  //   _openWebPage(payload);
  // }

  Future<void> _openWebPage(String payload) async {
    const String baseUrl = 'https://todaymoney.page.link/?'
                            'apn=com.okpos.merchant.dev'
                            '&ibi=howmuch.okpos.co.kr'
                            '&isi=1605931675'
                            '&link=https://www.todaysales.co.kr?'
                            'payload=';
    // final String inputText = _controller.text;

    // URL 인코딩
    final String encodedText = Uri.encodeComponent(payload);
    final String url = '$baseUrl$encodedText';

    final String closeScript = '''
    <script>
      setTimeout(function() {
        window.close();
      }, 3000); // 3초 후에 창 닫기
    </script>
    ''';

    // 웹페이지를 열기
    final Uri webPageUri = Uri.parse(url);

    if (await canLaunchUrl(webPageUri)) {
      await launchUrl(webPageUri);

      // 새로운 창에 closeScript를 추가하여 자동으로 닫히도록 설정
      final String closeUrl = 'data:text/html;base64,${base64Encode(utf8.encode(closeScript))}';
      final Uri closeUri = Uri.parse(closeUrl);
      if (await canLaunchUrl(closeUri)) {
        await Future.delayed(Duration(seconds: 1)); // 잠시 대기 후 스크립트 실행
        await launchUrl(closeUri);
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var array = getDeepLinkDatas();

    return Scaffold(
      appBar: AppBar(
        title: const Text('DeepLink Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Store ID 입력',
              ),
              onChanged: (text) {
                setState(() {
                  _displayText = text;
                });
              },
            ),

            const SizedBox(height: 4),
            Flexible(child:  ListView.separated(
              itemCount: array.length,
              itemBuilder: (BuildContext context, int i) {
                var data = array[i];
                return ListTile(
                  title: Text("${data.name}(${data.landingUrl})"),
                  onTap: () {
                    _openWebPageLandingUrl(data);
                  },
                );
              },
              separatorBuilder: (BuildContext ctx, int i) {
                return Divider();
              },
            ))

          ],
        ),
      ),
    );
  }
}
