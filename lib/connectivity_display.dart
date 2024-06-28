import 'package:flutter/material.dart';
import 'package:flutter_connectivity_checker/connectivity_checker.dart';
import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_status.dart';
import 'package:info_popup/info_popup.dart';

class ConnectivityIcon extends StatelessWidget {
  final ConnectivityConfig config;
  final ConnectivityStatus status;
  const ConnectivityIcon(this.config, this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    var displayConfig = config.displayConfig.get(status.type);

    // don't show anything
    if (!displayConfig.display) {
      return Container();
    }

    // show Icon

    // prepare message
    var message = displayConfig.message;
    if (displayConfig.showPingValue) {
      message += ' (${status.ping!.inMilliseconds}ms)';
    }

    return InfoPopupWidget(
        contentTitle: message,
        arrowTheme: InfoPopupArrowTheme(
          color: displayConfig.iconColor,
        ),
        child: Icon(
          displayConfig.icon.icon,
          color: displayConfig.iconColor,
        ));
  }
}

class ConnectivityDisplay extends StatelessWidget {
  final ConnectivityConfig config;
  const ConnectivityDisplay(this.config, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ConnectivityChecker.stream(config),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ConnectivityStatus status = snapshot.data!;
            return ConnectivityIcon(config, status);
          } else {
            // still loading
            return CircularProgressIndicator(
              color: config.displayConfig.loadingIndicatorColor,
            );
          }
        });
  }
}
