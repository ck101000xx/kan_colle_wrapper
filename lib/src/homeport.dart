library kan_colle_wrapper.homeport;

import "dart:async";
import "dart:collection";
import "dart:convert";
import "package:observe/observe.dart";
import "internal/extensions.dart";
import "kan_colle_client.dart";
import "kan_colle_proxy.dart";
import "models.dart";

part "member_table.dart";
part "dockyard.dart";
part "itemyard.dart";
part "logger.dart";
part "materials.dart";
part "organization.dart";
part "quests.dart";
part "repairyard.dart";

class Homeport extends Observable {
  @observable Organization organization;
  @observable Materials materials;
  @observable Itemyard itemyard;
  @observable Dockyard dockyard;
  @observable Repairyard repairyard;
  @observable Quests quests;
  @observable Logger logger;
  @observable Admiral admiral;

  Homeport(KanColleProxy proxy) {
    materials = new Materials(proxy);
    itemyard = new Itemyard(proxy);
    organization = new Organization(this, proxy);
    repairyard = new Repairyard(this, proxy);
    dockyard = new Dockyard(proxy);
    quests = new Quests(proxy);
    logger = new Logger(proxy);

    tryParse(proxy["api_port"]).listen((x) {
      organization.updateShips(x.data["api_ship"]);
      repairyard.update(x.data["api_ndock"]);
      organization.updateFleets(x.data["api_deck_port"]);
      organization.combined = x.data["api_combined_flag"] == 1;
      materials.update(x.data["api_material"]);
    });
    tryParse(
        proxy["api_get_member_basic"]).listen((x) => updateAdmiral(x.data));
    tryParse(proxy["api_req_member_updatecomment"]).listen(updateComment);
  }
  updateAdmiral(data) {
    admiral = new Admiral(data);
  }
  updateComment(SvData data) {
    if (data == null || !data.isSuccess) return;
    try {
      admiral.comment = data.request["api_cmt"];
    } catch (ex) {
      print("艦隊名の変更に失敗しました: ${ex}");
    }
  }


  void startConditionCount() {
    //Observable.Timer(TimeSpan.FromSeconds(10), TimeSpan.FromMinutes(3))
  }
}
