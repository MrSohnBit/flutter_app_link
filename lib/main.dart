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
  String _searchStoreIdText = '';

  final List<DeepLink> _allItems = getDeepLinkDatas();//List<String>.generate(50, (index) => 'Item ${index + 1}');
  List<DeepLink> _filteredItems = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  bool _isSearchingStoreId = false;
  List<String> _searchHistory = [];
  List<String> _searchStoreIdHistory = [];



  Future<void> _openWebPageLandingUrl(DeepLink data) async {
    String payload =
        '{'
        '"type":"${data.type}", '
        '"landingType":"${data.landingType}", '
        '"landingUrl":"${data.landingUrl}", '
        '"storeId":${_searchStoreIdText == '' ? -1 : _searchStoreIdText}, '
        '"bankAccountId":"${data.bankAccountId}", '
        '"reportMessageId":"${data.reportMessageId}", '
        '"referenceDate": "" '
        '}';
    print(payload);
    _openWebPage(payload);
  }

  Future<void> _openWebPage(String payload) async {
    const String baseUrl = 'https://todaymoney.page.link/?apn=com.okpos.merchant.dev&ibi=howmuch.okpos.co.kr&isi=1605931675&link=https://www.todaysales.co.kr?payload=';
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



    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text('Search Example'),
        actions: _buildActions(),
      ),
      // appBar: AppBar(
      //   title: const Text('DeepLink Test'),
      // ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            const SizedBox(height: 18),
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
                  _searchStoreIdText = text;
                });
              },
            ),

            const SizedBox(height: 4),
            Expanded(child:  ListView.separated(
              itemCount: _filteredItems.length,
              itemBuilder: (BuildContext context, int i) {
                var data = _filteredItems[i];
                return ListTile(
                  title: Text("${data.name}(${data.landingUrl})"),
                  onTap: () {
                    _openWebPageLandingUrl(data);
                    _saveSearchHistory(data.name);
                    _saveSearchStoreIdHistory(_searchStoreIdText);

                  },
                );
              },
              separatorBuilder: (BuildContext ctx, int i) {
                return Divider();
              },
            )),


            if (_isSearching) ...[
              Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('검색어 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _searchHistory.map((query) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _selectSearchHistory(query);
                        },
                        child: Text(query),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            if (_isSearchingStoreId) ...[
              Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('StoreId 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _searchStoreIdHistory.map((query) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _selectSearchIdHistory(query);
                        },
                        child: Text(query),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

          ],
        ),
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

  void _searchItems(String query) {
    final filteredItems = _allItems.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredItems = filteredItems;
    });
  }

  void _saveSearchHistory(String query) {
    _searchHistory.remove(query); // 중복된 검색어 제거
    _searchHistory.insert(0, query); // 맨 앞에 추가
    setState(() {});
  }
  
  void _saveSearchStoreIdHistory(String query) {
    _searchStoreIdHistory.remove(query); // 중복된 검색어 제거
    _searchStoreIdHistory.insert(0, query); // 맨 앞에 추가
    setState(() {});
  }

  void _selectSearchHistory(String query) {
    _searchController.text = query;
    _searchItems(query);
  }

  void _selectSearchIdHistory(String query) {
    _controller.text = query;
    _searchItems(query);
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
            _searchItems('');
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

}
