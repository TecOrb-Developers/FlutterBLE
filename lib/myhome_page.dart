import 'package:flutter/material.dart';
import 'package:flutter_ble/device_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter BLE"),
      ),
      body: SafeArea(
        child: StreamBuilder<List<ScanResult>>(
          stream: FlutterBluePlus.instance.scanResults,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (c, index) {
                    var device = snapshot.data![index];
                    return ListTile(
                      title: Text(
                        device.device.name.isNotEmpty
                            ? device.device.name
                            : "Device ${index + 1}",
                      ),
                      subtitle: Text(
                        device.device.id.toString(),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          device.device.connect();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    DeviceScreen(device: device.device)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                        ),
                        child: const Text("CONNECT"),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    "Make sure device's bluetooth and location\nservices are turned on",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                );
              }
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.instance.isScanning,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return FloatingActionButton(
              onPressed: () {
                FlutterBluePlus.instance.stopScan();
              },
              child: const Icon(Icons.stop_circle_rounded),
            );
          } else {
            return FloatingActionButton(
              onPressed: () {
                FlutterBluePlus.instance
                    .startScan(timeout: const Duration(seconds: 20));
              },
              child: const Icon(Icons.search),
            );
          }
        },
      ),
    );
  }
}
