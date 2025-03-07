import 'package:deepseek_client/chat_view.dart';
import 'package:deepseek_client/chat_view_model.dart';
import 'package:deepseek_client/data_store.dart';
import 'package:deepseek_client/session_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await DataStore.instance.initialize();
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SessionViewModel sessionViewModel = SessionViewModel();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ChangeNotifierProvider(
      create: (context) => sessionViewModel,
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            actions: [
              IconButton(
                onPressed: () {
                  sessionViewModel = context.read<SessionViewModel>();
                  sessionViewModel.prepareNewSession();
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: Consumer<SessionViewModel>(
              builder: (context, value, child) {
                return ChangeNotifierProvider(
                    create: (context) => ChatViewModel(),
                    builder: (context, child) {
                      return ChatView(sessionId: value.currentSessionId,);
                    }
                );
              }
          ),// This trailing comma makes auto-formatting nicer for build methods.
          drawer: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Consumer<SessionViewModel>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        itemCount: value.sessionCount,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(value.sessionTitle(index)),
                            onTap: () {
                              value.changeCurrentSession(index);
                              _scaffoldKey.currentState?.closeDrawer();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                    icon: const Icon(Icons.settings),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
