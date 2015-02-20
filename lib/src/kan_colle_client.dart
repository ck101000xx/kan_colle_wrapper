library kan_colle_wrapper.client;

import "dart:async";
import "package:observe/observe.dart";
import "caculator.dart";
import "homeport.dart";
import "master.dart";
import "models.dart";
import "kan_colle_proxy.dart";

part "kan_colle_client_settings.dart";

class KanColleClient extends Observable {

  static final KanColleClient current = new KanColleClient();

  final KanColleProxy proxy;

  Master master;

  Homeport homeport;

  @observable bool isStarted;

  @observable bool isInSortie;

  @observable KanColleClientSettings settings;


  KanColleClient() : proxy = new KanColleProxy() {
    initialieze();

    var start = proxy["api_req_map_start"];
    var end = proxy["api_port"];

    start.listen((_) => this.isInSortie = true);
    end.listen((_) => this.isInSortie = false);
  }


  Future initialieze() {
    var basic = tryParse(proxy["api_get_member_basic"]).first;
    var kdock = tryParse(proxy["api_get_member_kdock"]).first;
    var sitem = tryParse(proxy["api_get_member_slot_item"]).first;

    return proxy["api_start2"].first.then((session) {
      Future.wait(
          [
              basic,
              kdock,
              sitem]).timeout(
                  new Duration(seconds: 20),
                  onTimeout: () => null).then((result) {
        SvData.tryParse(session).then((svd) {
          if (svd == null) return;
          master = new Master(svd.data);
          if (homeport == null) homeport = new Homeport(proxy);

          if (result != null) {
            homeport.updateAdmiral(result[0].data);
            homeport.itemyard.updateSlotItems(result[3].data);
            homeport.dockyard.update(result[2].data);
          }
          this.isStarted = true;
        });
      });
    });
  }
}
