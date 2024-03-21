import 'package:flutter/material.dart';
import 'package:vivo_vivo_police_app/src/data/datasource/mongo/api_repository_family_group_impl.dart';
import 'package:vivo_vivo_police_app/src/domain/models/user_alert.dart';
import 'package:vivo_vivo_police_app/src/screens/Alerts/components/card_alert.dart';
import 'package:vivo_vivo_police_app/src/screens/Home/Drawer/components/family_group.dart';
import 'package:vivo_vivo_police_app/src/screens/Home/controllers/home_controller.dart';

import '../../utils/app_styles.dart';

/// It's a StatelessWidget that receives a list of UserAlerts and displays them in a ListView.builder
class Alerts extends StatefulWidget {
  final int userID;

  const Alerts({super.key, required this.userID});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  ApiRepositoryFamilyGroupImpl familyGroupService =
      ApiRepositoryFamilyGroupImpl();
  late final HomeController homeController;

  late Future<List<UserAlert>> _familyGroupFuture;
  final String errorMessage = "No se encontró personas en emergencia";

  Future<List<UserAlert>> getPoliceGroupByUserID(int userID) async {
    var res = await familyGroupService.getPoliceGroupByUserId(userID);

    if (res.data == null || res.error as bool) return List<UserAlert>.empty();
    List<UserAlert> usersAlerts = (res.data as List)
        .map(
          (p) => UserAlert.fromJson(p),
        )
        .toList();
    return usersAlerts;
  }

  Future<void> reloadData() async {
    if (!mounted) return;
    setState(() {
      _familyGroupFuture = getPoliceGroupByUserID(widget.userID);
    });
  }

  @override
  void initState() {
    super.initState();
    homeController = HomeController(context);
    homeController.onRequestPolicePosition(widget.userID);
    homeController.onAlerts(() {
      reloadData();
    });
    _familyGroupFuture = getPoliceGroupByUserID(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            title: const Text('Alertas de Emergencia')),
        body: SafeArea(
            bottom: false,
            child: FutureBuilder(
                initialData: const [],
                future: _familyGroupFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.isNotEmpty
                        ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final user = snapshot.data![index];
                              return CardAlert(
                                userAlert: user,
                              );
                            },
                          )
                        : Center(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: MessageIsEmptyCoreTrust(
                                    errorMessage: errorMessage)),
                          );
                  } else if (snapshot.hasError) {
                    return MessageIsEmptyCoreTrust(errorMessage: errorMessage);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Styles.primaryColor,
                      ),
                    );
                  }
                })),
      ),
    );
  }
}
