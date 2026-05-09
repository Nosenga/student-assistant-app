import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://fesevypeonmbuvgtrdxp.supabase.co',
    anonKey: 'sb_publishable_au93zY2pe6rJbWt5DowUVQ_B5YveVJo',
  );
  runApp(MyApp());
}

1class MyApp extends StatelessWidget {
2  const MyApp({super.key});
3
4  @override
5  Widget build(BuildContext context) {
6    return const MaterialApp(
7      title: 'Todos',
8      home: HomePage(),
9    );
10  }
11}
12
13class HomePage extends StatefulWidget {
14  const HomePage({super.key});
15
16  @override
17  State<HomePage> createState() => _HomePageState();
18}
19
20class _HomePageState extends State<HomePage> {
21  final _future = Supabase.instance.client
22      .from('todos')
23      .select();
24
25  @override
26  Widget build(BuildContext context) {
27    return Scaffold(
28      body: FutureBuilder(
29        future: _future,
30        builder: (context, snapshot) {
31          if (!snapshot.hasData) {
32            return const Center(child: CircularProgressIndicator());
33          }
34          final todos = snapshot.data!;
35          return ListView.builder(
36            itemCount: todos.length,
37            itemBuilder: ((context, index) {
38              final todo = todos[index];
39              return ListTile(
40                title: Text(todo['name']),
41              );
42            }),
43          );
44        },
45      ),
46    );
47  }
48}
