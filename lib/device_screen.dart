import 'package:flutter/material.dart';
import 'package:flutter_ble/characteristic_tile.dart';
import 'package:flutter_ble/descriptor_tile.dart';
import 'package:flutter_ble/utils.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: [
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = () {};
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                onPressed: onPressed,
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (context, snapshot) {
                return ListTile(
                  leading: (snapshot.data == BluetoothDeviceState.connected)
                      ? const Icon(Icons.bluetooth_connected)
                      : const Icon(Icons.bluetooth_disabled),
                  title: Text(
                      "Device is ${snapshot.data.toString().split('.')[1]}"),
                  subtitle: Text(
                    device.id.toString(),
                  ),
                );
              },
            ),
            const Divider(),
            StreamBuilder<int>(
              stream: device.mtu,
              builder: (ctx, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "MTU Size",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text("${snapshot.data} bytes"),
                    ],
                  ),
                );
              },
            ),
            const Divider(),
            StreamBuilder<bool>(
              stream: device.isDiscoveringServices,
              initialData: false,
              builder: (c, snapshot) {
                if (snapshot.data!) {
                  return const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(),
                  );
                }
                return TextButton(
                  onPressed: () {
                    device.discoverServices();
                  },
                  child: const Text("Discover Services"),
                );
              },
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: const [],
              builder: (c, snapshot) {
                var bleServiceList = snapshot.data;
                return Expanded(
                  child: ListView.builder(
                    itemCount: bleServiceList?.length ?? 0,
                    itemBuilder: (_, index) {
                      return ExpansionTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('Service'),
                            Text(
                              '${bleServiceList![index].uuid}',
                            ),
                          ],
                        ),
                        children: bleServiceList[index]
                            .characteristics
                            .map(
                              (e) => ExpansionTile(
                                title: CharacteristicTile(
                                  characteristic: e,
                                  onReadPressed: () async {
                                    var value = await e.read();
                                    print(value);
                                  },
                                  onWritePressed: () async =>
                                      await e.write(Utils.getRandomBytes()),
                                ),
                                children: e.descriptors
                                    .map(
                                      (e) => DescriptorTile(
                                        descriptor: e,
                                        onReadPressed: () async => e.read(),
                                        onWritePressed: () =>
                                            e.write(Utils.getRandomBytes()),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
