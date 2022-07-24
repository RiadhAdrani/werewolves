import 'package:localstorage/localstorage.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/transformers/objects/convert_role_id.dart';

final LocalStorage storage = LocalStorage("storage");

const String selectedList = "list";

void getCurrentlySelectedRoles() {
  // var item = storage.getItem(selectedList);
}

void updateCurrentlySelectedRoles(List<Role> list) {
  storage.setItem(
    selectedList, 
    makeSerializableListOfRoles(list)
    .map((e) => e.toString())
    .toList()
  );
}
