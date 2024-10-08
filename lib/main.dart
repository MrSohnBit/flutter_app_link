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
  final List<DeepLink> _allItems = getDeepLinkDatas();//List<String>.generate(50, (index) => 'Item ${index + 1}');
  final List<DeepLink> _searchHistory = [];
  List<DeepLink> _filteredItems = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // StoreId 검색 기록
  final TextEditingController _storeIdcontroller = TextEditingController();
  String _searchStoreIdText = '';
  bool _isSearchingStoreId = false;

  final List<String> _searchStoreIdHistory = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = getDeepLinkDatas();
  }


  Future<void> _openWebPageLandingUrl(DeepLink data) async {
    StringBuffer sb = StringBuffer();
    sb.write('{');
    sb.write('"type":"${data.type}", ');
    sb.write('"landingType":"${data.landingType}", ');
    sb.write('"landingUrl":"${data.landingUrl}", ');
    sb.write('"storeId":${_searchStoreIdText == '' ? -1 : _searchStoreIdText}, ');
    sb.write('"bankAccountId":"${data.bankAccountId}", ');
    sb.write('"reportMessageId":"${data.reportMessageId}", ');
    sb.write('"referenceDate": "",');
    sb.write('"linkType": "kakao"');


    if(data.landingType == FCM_LANDING_TYPE_WEBVIEW_EXT_CJ) {
      sb.write(',');
      sb.write('"cjEventId": "1"');
    }

    sb.write('}');


    String payload = sb.toString();
    print(payload);
    _openWebPage(payload);
  }

  Future<void> _openWebPage(String payload) async {
    const String baseUrl = 'https://todaymoney.page.link/?apn=com.okpos.merchant.dev&ibi=howmuch.okpos.co.kr&isi=1605931675&link=https://www.todaysales.co.kr?data=';
    // final String inputText = _controller.text;

    // URL 인코딩
    final String encodedText = Uri.encodeComponent(payload);
    final String url = '$baseUrl$encodedText';

    const String closeScript = '''
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
        await Future.delayed(const Duration(seconds: 1)); // 잠시 대기 후 스크립트 실행
        await launchUrl(closeUri);
      }
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // title: _isSearching ? _buildSearchField() : Text('딥링크 테스트'),
        title: _isSearching ? _buildSearchField() : const Text('딥링크 테스트'),
        actions: _buildActions(),
      ),
      // appBar: AppBar(
      //   title: const Text('DeepLink Test'),
      // ),
      body: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _storeIdcontroller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Store ID 입력',
              ),
              onChanged: (text) {
                setState(() {
                  _searchStoreIdText = text;
                });
              },
              onTap: () {
                _startSearchStoreId();
              },

            ),
          ),

          const SizedBox(height: 4),
          Expanded(child: ListView.separated(
            itemCount: _filteredItems.length,
            itemBuilder: (BuildContext context, int i) {
              var data = _filteredItems[i];
              return ListTile(
                // title: Text("${data.name}(${data.landingUrl})"),
                title: _buildHighlightedText(data, _searchController.text),
                onTap: () {
                  _openWebPageLandingUrl(data);
                  _saveSearchHistory(data);
                  _saveSearchStoreIdHistory(_searchStoreIdText);
                  _stopSearchStoreId();
                },
              );
            },
            separatorBuilder: (BuildContext ctx, int i) {
              return Divider();
            },
          )),

          if (_isSearchingStoreId && _searchStoreIdHistory.isNotEmpty) ...[
            Container(
              color: const Color.fromARGB(100, 230, 168, 176),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const Text('StoreId 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _searchStoreIdHistory.map((storeId) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _selectStoreIdHistory(storeId);
                                },
                                child: Text(storeId),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // IconButton(icon: const Icon(Icons.clear),
                    //   onPressed: () {
                    //
                    // })
                  ],
                ),
              ),
            )

          ],

          // if (_isSearching && _searchHistory.isNotEmpty) ...[
          if (_searchHistory.isNotEmpty) ...[
            Container(
              color: const Color.fromARGB(100, 200, 230, 186),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const Text('검색기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _searchHistory.map((query) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _selectSearchHistory(query);
                                },
                                child: Text(query.name),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // IconButton(icon: const Icon(Icons.clear),
                    //   onPressed: () {
                    //
                    //   })
                  ],
                ),
              ),
            )
          ],


        ],
      ),
    );
  }



  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _filteredItems = _allItems;
      _searchController.clear();
    });
  }

  void _startSearchStoreId() {
    setState(() {
      _isSearchingStoreId = true;
    });
  }

  void _stopSearchStoreId() {
    setState(() {
      _isSearchingStoreId = false;
    });
  }

  void _searchItems(String query) {
    final filteredItems = _allItems.where((item) {
      String landingText = "${item.landingUrl}/${item.landingType}/${item.type}";
      return item.name.toLowerCase().contains(query.toLowerCase()) || landingText.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredItems = filteredItems;
    });
  }

  void _saveSearchHistory(DeepLink data) {
    _searchHistory.remove(data); // 중복된 검색어 제거
    _searchHistory.insert(0, data); // 맨 앞에 추가
    setState(() {});
  }
  
  void _saveSearchStoreIdHistory(String storeId) {
    if(storeId.isNotEmpty) {
      _searchStoreIdHistory.remove(storeId); // 중복된 검색어 제거
      _searchStoreIdHistory.insert(0, storeId); // 맨 앞에 추가
      setState(() {});
    }
  }

  void _selectSearchHistory(DeepLink data) {
    _openWebPageLandingUrl(data);
  }

  void _selectStoreIdHistory(String storeId) {
    _storeIdcontroller.text = storeId;
    _stopSearchStoreId();
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (_searchController.text.isEmpty) {
              _stopSearch();
              return;
            }
            _searchController.clear();
            // _storeIdcontroller.clear();
            _searchItems('');
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  Widget _buildHighlightedText(DeepLink data, String query) {
    if (query.isEmpty) {
      // return Text(data.name);
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(data.name, style: const TextStyle(fontSize: 16)),
        Text("${data.landingUrl}/${data.landingType}/${data.type}", style: const TextStyle(fontSize: 12),)
      ],);
    }

    final List<TextSpan> spans = _getTextSpans(data.name, query);
    String landingText = "${data.landingUrl}/${data.landingType}/${data.type}";
    final List<TextSpan> spansLandignUrl = _getTextSpans(landingText, query);

    // return RichText(text: TextSpan(style: const TextStyle(color: Colors.black), children: spans));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(text: TextSpan(style: const TextStyle(color: Colors.black, fontSize: 16), children: spans)),
        RichText(text: TextSpan(style: const TextStyle(color: Colors.black, fontSize: 12), children: spansLandignUrl)),
        // Text(data.landingUrl, style: const TextStyle(fontSize: 12),)
      ],);
  }


  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: _searchItems,
    );
  }


  List<TextSpan> _getTextSpans(String title, String query) {
    final List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;
    while ((indexOfHighlight = title.toLowerCase().indexOf(query.toLowerCase(), start)) != -1) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(text: title.substring(start, indexOfHighlight)));
      }

      spans.add(TextSpan(
        text: title.substring(indexOfHighlight, indexOfHighlight + query.length),
        style: const TextStyle(backgroundColor: Colors.yellow),
      ));

      start = indexOfHighlight + query.length;
    }

    if (start < title.length) {
      spans.add(TextSpan(text: title.substring(start)));
    }
    return spans;
  }

}
