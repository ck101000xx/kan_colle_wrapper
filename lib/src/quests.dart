part of kan_colle_wrapper.homeport;

class Quests extends Observable {
  final List<Map<int, Quest>> _questPages;
  @observable UnmodifiableListView<Quest> all;
  @observable UnmodifiableListView<Quest> current;
  @observable bool isUntaken;
  @observable bool isEmpty;

  Quests(KanColleProxy proxy) : _questPages = new List() {
    isUntaken = true;
    all = current = new UnmodifiableListView([]);

    proxy["api_get_member_questlist"]
      .asyncMap(serialize)
      .where((x) => x != null)
      .listen(update);
  }

  static Future serialize(Session session) {
    return getResponseAsJson(session).then(JSON.decode).then((djson) {
      var questlist = {
        "api_count": djson["api_data"]["api_count"],
        "api_disp_page": djson["api_data"]["api_disp_page"],
        "api_page_count": djson["api_data"]["api_page_count"],
        "api_exec_count": djson["api_data"]["api_exec_count"],
      };

      if (djson["api_data"].hasProperty("api_list")) {
        var list = new List();
        for (var x in djson["api_data"]["api_list"]) {
          try {
            list.add(JSON.decode(x.toString()));
          }
          catch (ex) {
            // 最後のページで任務数が 5 に満たないとき、api_list が -1 で埋められるというクソ API のせい
            print(ex);
          }
        }
        questlist["api_list"] = list;
      }
      return questlist;
    }, onError: (ex) {
      print(ex);
      return null;
    });
  }

  void update(questlist) {
    this.isUntaken = false;

    // キャッシュしてるページの数が、取得したページ数 (api_page_count) より大きいとき
    // 取得したページ数と同じ数になるようにキャッシュしてるページを減らす
    if (_questPages.length > questlist["api_page_count"]) {
      while (_questPages.length > questlist["api_page_count"])
        _questPages.removeAt(_questPages.length - 1);
    } else if (_questPages.length < questlist["api_page_count"]) {
      // 小さいときは、キャッシュしたページ数と同じ数になるようにページを増やす
      while (_questPages.length < questlist["api_page_count"]) _questPages.add(null);
    }

    if (!questlist.hasProperty("api_list")) {
      isEmpty = true;
      all = current = new UnmodifiableListView([]);
    } else {
      var page = questlist["api_disp_page"] - 1;
      if (page >= _questPages.length) page = _questPages.length - 1;

      _questPages[page] = new Map();

      this.isEmpty = false;

      questlist["api_list"].map((x) => new Quest(x))
        .forEach((x) => _questPages[page][x.id] = x);

      this.all = new UnmodifiableListView(new SplayTreeMap.fromIterable(_questPages
          .where((x) => x != null)
          .expand((x) => x.values), key: (x) => x.id).values);

      var current = all
          .where((x) => x.state == QuestState.takeOn || x.state == QuestState.accomplished)
          .toList()
          ..sort((a, b) => a.id.compareTo(b.id));
      // 遂行中の任務数に満たない場合、未取得分として null で埋める
      while (current.length < questlist["api_exec_count"]) current.add(null);
      this.current = new UnmodifiableListView(current);
    }
  }
}
