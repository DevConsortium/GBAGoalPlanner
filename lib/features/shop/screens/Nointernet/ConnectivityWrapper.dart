import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tea/features/shop/screens/Nointernet/NoInternetScreen.dart';


class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnection() async {
    var result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _hasInternet = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      return NoInternetScreen(
        onRetry: _checkInitialConnection,
      );
    }

    return widget.child;
  }
}
