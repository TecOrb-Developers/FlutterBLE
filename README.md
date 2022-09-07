# FlutterBLE
### Connect bluetooth device to android/ios phone with Flutter app

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

FLutterBLE is an app built using flutter framework to connect any Bluetooth Low Energy device with your android or ios phone and perform operations on it.

## Features
- FlutterBlusPlus plugin used
- Search for bluetooth devices
- Connect to bluetooth device
- Get all services provided by the device
- Read/Write operations using UUIDs
- Listen to notifications given by the device using streams



## HOW IT WORKS

There is some setup required to work with bluetooth in Flutter application. To start with, add flutter_blue_plus plugin in pubspec.yaml file and do the following for android and ios setups respectively.

### Android Setup
1. Change the minSdkVersion for Android in android/app/build.gradle:
```
Android {
  defaultConfig {
     minSdkVersion: 19
```

2. Add this in android manifest.xml file
```
     <uses-permission android:name="android.permission.BLUETOOTH" />  
	 <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />  
	 <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
	 <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>

     <!-- For Android 12+ support-->
    <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

### IOS Setup
In the ios/Runner/Info.plist let’s add:
```
<dict>  
	    <key>NSBluetoothAlwaysUsageDescription</key>  
	    <string>Need BLE permission</string>  
	    <key>NSBluetoothPeripheralUsageDescription</key>  
	    <string>Need BLE permission</string>  
	    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>  
	    <string>Need Location permission</string>  
	    <key>NSLocationAlwaysUsageDescription</key>  
	    <string>Need Location permission</string>  
	    <key>NSLocationWhenInUseUsageDescription</key>  
	    <string>Need Location permission</string>
```

## Let's breakdown into code now:

1. Get an instance for flutter blue plus.
```
FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
```
2. Start scanning for devices and listen to results
```
// Start scanning
flutterBlue.startScan(timeout: Duration(seconds: 4));

// Listen to scan results
var subscription = flutterBlue.scanResults.listen((results) {
    // do something with scan results
    for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
    }
});

// Stop scanning
flutterBlue.stopScan();
```
3. Connect/Disconnect to a device
```
// Connect to the device
await device.connect();

// Disconnect from device
device.disconnect();
```
4. Discover for services provided by bluetooth device
```
List<BluetoothService> services = await device.discoverServices();
services.forEach((service) {
    // do something with service
});
```
5. After getting all services get characteristics and descriptors. And with perform operations on ble device with unique UUIDs.
```
// Reads all characteristics
var characteristics = service.characteristics;
for(BluetoothCharacteristic c in characteristics) {
    List<int> value = await c.read();
    print(value);
}

// Writes to a characteristic
await c.write([0x12, 0x34])


// Reads all descriptors
var descriptors = characteristic.descriptors;
for(BluetoothDescriptor d in descriptors) {
    List<int> value = await d.read();
    print(value);
}

// Writes to a descriptor
await d.write([0x12, 0x34])
```

6. Also subscribe to notifications emitted by the ble device.
```
await characteristic.setNotifyValue(true);
characteristic.value.listen((value) {
    // do something with new value
});
```
7. Read the MTU and request larger size
```
final mtu = await device.mtu.first;
await device.requestMtu(512);
```

## Developers
MIT License

Copyright (c) 2019 TecOrb Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
