import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

const supabaseURL = 'https://urvsgbuuxnpnefnxtoha.supabase.co';
const supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVydnNnYnV1eG5wbmVmbnh0b2hhIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjUyMzgyMDcsImV4cCI6MTk4MDgxNDIwN30.5Dr6OU0WmAShKgZ8Awnllkc2NkcSvoSQdD3cf5BjUgA';

const minimalVolunteerAge = 0;
const maximalVolunteerAge = 130;

const minimalVolunteerCount = 1;
const maximalVolunteerCount = 100;

const minimalPoints = 20;
const maximalPoints = 500;

const wroclawLat = 51.107883;
const wroclawLng = 17.038538;
