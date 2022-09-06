import 'package:flutter/material.dart';

class BluetoohOffDialog extends StatelessWidget {
  const BluetoohOffDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Uh-Oh!"),
      backgroundColor: Colors.teal[50],
      children: const [
        Text("Turn on the bluetooth"),
      ],
    );
    // Dialog(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   elevation: 10,
    //   backgroundColor: Colors.transparent,
    //   child: Stack(
    //     children: <Widget>[
    //       Container(
    //         padding: const EdgeInsets.only(
    //             left: 20, top: 45 + 20, right: 20, bottom: 20),
    //         margin: const EdgeInsets.only(top: 0),
    //         decoration: BoxDecoration(
    //           shape: BoxShape.rectangle,
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(20),
    //         ),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: const <Widget>[
    //             Text(
    //               "Uh-Oh!",
    //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    //             ),
    //             SizedBox(
    //               height: 15,
    //             ),
    //             Text(
    //               "Looks like bluetooth is turned off",
    //               style: TextStyle(fontSize: 14),
    //               textAlign: TextAlign.center,
    //             ),
    //           ],
    //         ),
    //       ),
    //       const Positioned(
    //         left: 20,
    //         right: 20,
    //         child: CircleAvatar(
    //           backgroundColor: Colors.transparent,
    //           radius: 45,
    //           child: Icon(
    //             Icons.bluetooth,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
