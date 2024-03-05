import 'package:flutter/material.dart';
import 'package:vivo_vivo_police_app/src/commons/permissions.dart';

import '../../../utils/app_styles.dart';

class PermissionLocation extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  PermissionLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Uso de su Ubicación",
                      style: Styles.textStyleTitle,
                    ),
                    const Image(image: AssetImage("assets/image/location.png")),
                    Text(
                        style: Styles.textStyleTitle.copyWith(
                            fontSize: 17, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.justify,
                        'Para observar a las personas en emergencia se requiere del uso de su ubicación en tiempo real.'),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Styles.secondaryColor),
                            onPressed: (() {
                              Navigator.of(context).pop();
                            }),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            child: const Text("Aceptar"),
                            onPressed: () => _requestPermissions(context),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _requestPermissions(BuildContext context) {
    Permissions.handleLocationPermission(context);
    Navigator.of(context).pop();
  }
}
