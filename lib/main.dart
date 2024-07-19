import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'Venda.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Venda venda;
  late Socket socket;
  var contador = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socket = io(
        'http://192.168.3.221:8085',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });
    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));

    // socket.on('newVenda', (venda)=>print(venda));

    socket.on('newVenda', (newMessage) {
      print(newMessage);
      venda = Venda.fromJson(newMessage);
      contador = 1;
      setState(() {

      });

      // venda = Venda.fromJson(jsonDecode(newMessage) as Map<dynamic, dynamic>);
      // print('venda: ${venda}');

      // Venda.fromJson(Map<dynamic, dynamic> json) :
      //   id = json['id'],
      //   description = json['description'],
      //   value = json['value'],
      //   status = json['status'];
    });
  }

  void _processado (venda){
    socket.emit('vendaProcessada', venda);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('teste'),
      ),
      body: Column(
        children: [
          Builder(
              builder: (context){
                if(contador==0){
                  return Text('Nada');

                } else {
                  return Column(
                    children: [
                      Text('${venda.id}'),
                      Text('${venda.description}'),
                      Text(venda.value.toString()),
                      Text('${venda.status}'),
                      ElevatedButton(
                          onPressed: (){
                            _processado(venda.id);
                          },
                          child: Text('processado'))
                    ],
                  );
                }
              }
          )
          // Text('${venda.id}'),
          // Text('${venda.description}'),
          // Text('${venda.value}'),
          // Text('${venda.status}'),
        ],
      )
    );
  }
}
