import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ozfcujyqjxznhkjocjuu.supabase.co',
    anonKey: 'sb_publishable_41wcaUGIT231HTSkFC4PVg_A504D0Kb',
  );
  runApp(MyApp());
}


