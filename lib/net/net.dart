import 'dart:io';

import 'package:process_run/shell.dart';

Future main() async {
  print('locahost: ${await getLanLocalhost()}');
}

/// ipv4 if possible, localhost in the worst case
Future<String> getLanLocalhost() async {
  String? hostname;
  try {
    if (Platform.isLinux) {
      // $ hostname -I
      // 192.168.1.69 192.168.122.1 172.17.0.1 2a01:cb1d:820e:c700:8824:d2af:7934:f840 2a01:cb1d:820e:c700:b5b9:abd0:d29b:f21c
      var lines = (await run('hostname -I', verbose: false)).outLines;
      for (var line in lines) {
        var words = line.split(' ');
        for (var word in words) {
          // Ipv4?
          word = word.trim();
          if (word.split('.').length == 4) {
            return word;
          }
        }
      }
      print(lines);
    }
  } catch (e) {
    print('Error $e getting localhost');
  }
  return hostname ?? 'localhost';
}
