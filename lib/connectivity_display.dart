import 'package:flutter/material.dart';
import 'package:flutter_connectivity_checker/connectivity_checker.dart';
import 'package:flutter_connectivity_checker/connectivity_config.dart';
import 'package:flutter_connectivity_checker/connectivity_status.dart';
import 'package:info_popup/info_popup.dart';

class ConnectivityDisplay extends StatelessWidget {
  final ConnectivityConfig config;
  const ConnectivityDisplay(this.config, {super.key, required status});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ConnectivityChecker.stream(config),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ConnectivityStatus status = snapshot.data!;
            var displayConfig = config.displayConfig.get(status.type);

            if (!displayConfig.display) {
              // don't show anything
              return Container();
            }

            // show Icon
            var message = displayConfig.message;
            if (displayConfig.showPingValue) {
              message += ' (${status.ping!.inMilliseconds}ms)';
            }
            return InfoPopupWidget(
              contentTitle: message,
              arrowTheme: InfoPopupArrowTheme(
                color: displayConfig.iconColor,
              ),
              child: displayConfig.icon,
            );
          } else {
            // still loading
            return CircularProgressIndicator(
              color: config.displayConfig.loadingIndicatorColor,
            );
          }
        });
  }
}
