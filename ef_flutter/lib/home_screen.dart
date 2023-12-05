import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';

// * Once the onboarding process is completed you will be taken to this screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // * Getting the AtClientManager instance to use below
    final AtClientManager atClientManager = AtClientManager.getInstance();
    final AtClient atClient = atClientManager.atClient;
    const String esp32 = '@tastelessbanana'; // esp32's atSign
    final String flutter = atClient.getCurrentAtSign()!; // '@jeremy_0'

    return Scaffold(
      appBar: AppBar(
        title: const Text('What\'s my current @sign?'),
      ),
      body: Center(
        child: Column(children: [
          const Text('Successfully onboarded and navigated to FirstAppScreen'),

          // * Use the AtClientManager instance to get the AtClient
          // * Then use the AtClient to get the current @sign
          Text('Current @sign: ${atClientManager.atClient.getCurrentAtSign()}'),

          ElevatedButton(
            onPressed: () async {
              // 1. get code
              // get key
              // @flutter:num.soccer0@esp32
              final AtKey sharedWithUs = AtKey()
                ..sharedWith = flutter
                ..namespace = 'soccer0'
                ..key = 'num'
                ..sharedBy = esp32;

              int num = int.parse((await atClient.get(sharedWithUs)).value);

              int newNum = num + 1;

              // 2. put code
              // put key
              // @esp32:num.soccer0@flutter
              final AtKey sharedWithESP32 = AtKey()
                ..sharedWith = esp32
                ..key = 'num'
                ..namespace = 'soccer0'
                ..sharedBy = flutter;

              bool success =
                  await atClient.put(sharedWithESP32, newNum.toString());
              atClient.syncService.sync();
              
              print('write succes? $success');

              print('current num $num');
              print('new num $newNum');
            },
            child: Text('Do Thing'),
          ),
        ]),
      ),
    );
  }
}
