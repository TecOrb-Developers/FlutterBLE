import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  const CharacteristicTile({
    Key? key,
    required this.characteristic,
    required this.onReadPressed,
    required this.onWritePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Characteristic"),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(characteristic.uuid.toString()),
          StreamBuilder<List<int>>(
              stream: characteristic.value,
              initialData: characteristic.lastValue,
              builder: (context, snapshot) {
                return Text(snapshot.data.toString());
              }),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onReadPressed,
            icon: const Icon(
              Icons.download_rounded,
              size: 18,
            ),
            splashRadius: 21,
          ),
          IconButton(
            onPressed: onWritePressed,
            icon: const Icon(
              Icons.upload_rounded,
              size: 18,
            ),
            splashRadius: 21,
          ),
        ],
      ),
    );
  }
}
