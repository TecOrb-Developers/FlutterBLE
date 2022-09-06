import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: [
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => widget.device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => widget.device.connect();
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
              stream: widget.device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (context, snapshot) {
                return ListTile(
                  leading: (snapshot.data == BluetoothDeviceState.connected)
                      ? const Icon(Icons.bluetooth_connected)
                      : const Icon(Icons.bluetooth_disabled),
                  title: Text(
                      "Device is ${snapshot.data.toString().split('.')[1]}"),
                  subtitle: Text(
                    widget.device.id.toString(),
                  ),
                );
              },
            ),
            const Divider(),
            StreamBuilder<int>(
              stream: widget.device.mtu,
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
              stream: widget.device.isDiscoveringServices,
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
                    widget.device.discoverServices();
                  },
                  child: const Text("Discover Services"),
                );
              },
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: widget.device.services,
              initialData: const [],
              builder: (c, snapshot) {
                if (snapshot.data?.isNotEmpty ?? false) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (_, index) {
                        return ExpansionTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Service'),
                              Text(
                                '${snapshot.data![index].uuid}',
                              )
                            ],
                          ),
                          children: snapshot.data![index].characteristics
                              .map((e) => ExpansionTile(
                                    title: ListTile(
                                      title: const Text("Characteristic"),
                                      subtitle: Text(e.uuid.toString()),
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
