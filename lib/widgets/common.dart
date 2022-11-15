import 'package:flutter/material.dart';

Widget button(String label, Function onClick,
    {bool flat = false, Color? txtColor, Color? bgColor}) {
  Widget content = text(label, color: txtColor);

  if (flat) {
    return TextButton(
      onPressed: () => onClick(),
      child: content,
    );
  } else {
    return ElevatedButton(
      onPressed: () => onClick(),
      style: ElevatedButton.styleFrom(primary: bgColor),
      child: content,
    );
  }
}

FloatingActionButton fab(IconData icon, Function onClick) {
  return FloatingActionButton(
    onPressed: () => onClick(),
    child: Icon(icon),
  );
}

Widget card({bool isSelected = false, Widget child = const Text('card')}) {
  return Card(
    color: isSelected ? Colors.grey[300] : Colors.white,
    child: child,
  );
}

Text text(
  String data, {
  Color? color = Colors.black,
  FontWeight? weight = FontWeight.normal,
  double? size = 14,
  bool italic = false,
  bool overflow = true,
  bool justify = false,
  bool center = false,
}) {
  return Text(
    data,
    textAlign: center
        ? TextAlign.center
        : justify
            ? TextAlign.justify
            : TextAlign.start,
    style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal),
    overflow: overflow ? TextOverflow.visible : TextOverflow.fade,
  );
}

Text headingTitle(
  String data, {
  Color? color = Colors.black,
  FontWeight? weight = FontWeight.bold,
  bool italic = false,
}) {
  return text(data,
      color: color, weight: weight, size: 24, italic: italic, overflow: false);
}

Text title(String data,
    {Color? color = Colors.black,
    FontWeight? weight = FontWeight.bold,
    bool italic = false}) {
  return text(data,
      color: color, weight: weight, size: 20, italic: italic, overflow: false);
}

Text subTitle(String data,
    {Color? color = Colors.black,
    FontWeight? weight = FontWeight.w600,
    bool italic = false}) {
  return text(data,
      color: color, weight: weight, size: 16, italic: italic, overflow: false);
}

Text paragraph(
  String data, {
  Color? color = Colors.black45,
  FontWeight? weight = FontWeight.normal,
  bool italic = false,
  bool center = false,
}) {
  return text(
    data,
    color: color,
    weight: weight,
    size: 12,
    italic: italic,
    overflow: true,
    center: center,
    justify: true,
  );
}

EdgeInsetsGeometry useEdge(List<double> edges) {
  EdgeInsetsGeometry p = EdgeInsets.zero;

  if (edges.isEmpty) {
    p = EdgeInsets.zero;
  } else if (edges.length == 1) {
    p = EdgeInsets.all(edges[0]);
  } else if (edges.length == 2) {
    p = EdgeInsets.symmetric(vertical: edges[0], horizontal: edges[1]);
  } else if (edges.length == 3) {
    p = EdgeInsets.fromLTRB(0, edges[0], edges[1], edges[2]);
  } else if (edges.length > 3) {
    p = EdgeInsets.fromLTRB(edges[3], edges[0], edges[1], edges[2]);
  }

  return p;
}

Widget padding(List<double> padding, Widget child) {
  return Padding(padding: useEdge(padding), child: child);
}

Widget input(TextEditingController controller,
    {String placeholder = '',
    int? max,
    TextInputType type = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none}) {
  return TextField(
    controller: controller,
    maxLength: max,
    decoration: InputDecoration(hintText: placeholder),
    keyboardType: type,
    textCapitalization: capitalization,
  );
}

Widget checkbox(bool value, Function(bool?) onChanged) {
  return Checkbox(value: value, onChanged: onChanged);
}

Widget icon(IconData icon, {Color? color, double? size}) {
  return Icon(
    icon,
    size: size,
    color: color,
  );
}

Widget image(String name, {double height = 50, double width = 50}) {
  return Image.asset(
    name,
    height: height,
    width: width,
  );
}

Widget column({
  List<Widget> children = const [],
  MainAxisAlignment mainAlignment = MainAxisAlignment.start,
  MainAxisSize mainSize = MainAxisSize.min,
  CrossAxisAlignment crossAlignment = CrossAxisAlignment.start,
}) {
  return Column(
    mainAxisAlignment: mainAlignment,
    crossAxisAlignment: crossAlignment,
    mainAxisSize: mainSize,
    children: children,
  );
}

Widget row({
  List<Widget> children = const [],
  MainAxisAlignment mainAlignment = MainAxisAlignment.start,
  MainAxisSize mainSize = MainAxisSize.min,
  CrossAxisAlignment crossAlignment = CrossAxisAlignment.center,
}) {
  return Row(
    mainAxisAlignment: mainAlignment,
    crossAxisAlignment: crossAlignment,
    mainAxisSize: mainSize,
    children: children,
  );
}

Widget flexible(Widget child) {
  return Flexible(child: child);
}

Widget inkWell({
  Widget? child,
  void Function()? onClick,
  void Function()? onHold,
}) {
  return InkWell(
    onTap: onClick,
    onLongPress: onHold,
    child: child,
  );
}

Widget dialog({
  IconData? iconName,
  String? title,
  Widget? content,
  List<Widget> actions = const [],
  BuildContext? context,
  bool dismissible = true,
}) {
  return WillPopScope(
    onWillPop: () async {
      return dismissible ? true : false;
    },
    child: AlertDialog(
      title: row(children: [
        if (iconName != null) padding([0, 8, 0, 0], icon(iconName)),
        if (title != null) subTitle(title)
      ]),
      content: content,
      actions: [
        ...actions,
        if (context != null)
          button(
            'Cancel',
            () {
              Navigator.pop(context);
            },
            flat: true,
          )
      ],
    ),
  );
}

class AppBarButton {
  String label;
  Function onClick;

  AppBarButton(this.label, this.onClick);
}

AppBar appBar(String title,
    {List<AppBarButton> actions = const [],
    bool showReturnButton = false,
    Color? bgColor,
    Color? txtColor}) {
  return AppBar(
    automaticallyImplyLeading: showReturnButton,
    backgroundColor: bgColor,
    title: subTitle(title, color: txtColor),
    actions: actions
        .map((btn) => button(
              btn.label,
              btn.onClick,
              flat: true,
              txtColor: txtColor,
            ))
        .toList(),
  );
}

Widget divider() {
  return Divider(
    color: Colors.blueGrey[100],
  );
}

Widget titleWithIcon(
  String label,
  IconData iconData, {
  double size = 12,
  Color? color,
  MainAxisAlignment alignment = MainAxisAlignment.center,
}) {
  return padding(
      [0, 6],
      row(mainAlignment: alignment, children: [
        padding(
          [0, size * 0.4, 0, 0],
          icon(iconData, color: color, size: size * 1.66),
        ),
        text(label, color: color, size: size),
      ]));
}
