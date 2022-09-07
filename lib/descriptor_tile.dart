import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  const DescriptorTile({
    Key? key,
    required this.descriptor,
    required this.onReadPressed,
    required this.onWritePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Descriptor"),
          Text(descriptor.uuid.toString()),
        ],
      ),
      subtitle: StreamBuilder<List<int>>(
          stream: descriptor.value,
          initialData: descriptor.lastValue,
          builder: (context, snapshot) {
            return Text(snapshot.data.toString());
          }),
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
