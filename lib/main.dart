import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://fesevypeonmbuvgtrdxp.supabase.co',
    anonKey: 'sb_publishable_au93zY2pe6rJbWt5DowUVQ_B5YveVJo',
  );
  runApp(MyApp());
}


