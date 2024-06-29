import 'package:flutter/material.dart';
import 'package:flutter_connectivity_checker/connectivity_checker.dart';
import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_status.dart';
import 'package:info_popup/info_popup.dart';

class ConnectivityIcon extends StatelessWidget {
  final DisplayConfig displayConfig;
  final ConnectivityStatus status;
  const ConnectivityIcon(this.displayConfig, this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    var displayConfig = this.displayConfig.get(status.type);

    // don't show anything
    if (!displayConfig.display) {
      return Container();
    }

    // prepare icon
    Widget icon = Icon(
      displayConfig.icon.icon,
      color: displayConfig.iconColor,
    );

    // prepare message
    var message = displayConfig.message;
    if (displayConfig.showPingValue) {
      message += ' (${status.ping!.inMilliseconds}ms)';
    }

    // check to show error or not
    if (status.errorMsg != null && displayConfig.showErrorMessage) {
      // create a SnackBar
      message += ': ${status.errorMsg!}';
      SnackBar snackBar = SnackBar(
        content: Text(message),
      );

      // return a icon that will show the SnackBar when clicked
      return IconButton(
          icon: icon,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
    }

    // return a icon with a "tooltip" message
    return InfoPopupWidget(
        contentTitle: message,
        arrowTheme: InfoPopupArrowTheme(
          color: displayConfig.iconColor,
        ),
        child: icon);
  }
}

class ConnectivityDisplay extends StatelessWidget {
  final ConnectivityConfig config;
  final DisplayConfig displayConfig;

  ConnectivityDisplay(
      {super.key, required this.config, DisplayConfig? displayConfig})
      : displayConfig =
            displayConfig ?? DisplayConfig(loadingIndicatorColor: Colors.white);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ConnectivityChecker.stream(config),
        builder: (context, snapshot) {
          if (!snapshot.hasError && snapshot.hasData) {
            ConnectivityStatus status = snapshot.data!;
            return ConnectivityIcon(displayConfig, status);
          } else {
            return CircularProgressIndicator(
              color: displayConfig.loadingIndicatorColor,
            );
          }
        });
  }
}
