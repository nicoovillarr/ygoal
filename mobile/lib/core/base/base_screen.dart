import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/store/index.dart';
import 'package:redux/redux.dart';

abstract class BaseScreen<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
    customInitState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstBuild(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: useAppBar
          ? AppBar(
              leading: addBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
              title: title != null ? Text(title!) : null,
              elevation: 1,
              actions: actions,
            )
          : null,
      floatingActionButton: fab,
      body: body(context),
    );
  }

  Widget? body(BuildContext context) => null;

  void customInitState() {}

  void afterFirstBuild(BuildContext context) {}

  void simpleBottomSheet(
      {required Widget child, String? title, int height = 350}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) Text(title),
            SingleChildScrollView(
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  void draggableBottomSheet(
      {required Widget child, String? title, double initialHeight = 0.5}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: DraggableScrollableSheet(
          minChildSize: 0.25,
          maxChildSize: 0.9,
          builder: (_, controller) => Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: ListView(
              controller: controller,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  width: 40.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Store<AppState> get store => StoreProvider.of<AppState>(context);

  bool get useAppBar => true;

  bool get addBackButton => true;

  String? get title => appName;

  List<Widget> get actions => [];

  FloatingActionButton? get fab => null;
}