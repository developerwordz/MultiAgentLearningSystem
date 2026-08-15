# multi_agent_learning_system

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

Day 1
-> Hour 1 : 
Folder Structure = Clean Architecture

lib/ - 
Screens/ => auth/ home/ teaching/
auth/ => signIn.dart , signUp.dart
home/ => home_screen.dart
teaching/ => teaching_screen.dart

config/ => supabase_config.dart
models/ => user_model.dart , session_model.dart
providers/ => auth_provider.dart , session_provider
services/ => supabase_service.dart , llm_service.dart
utils=> constant , validators

-> Hour 2 :
Supabase setup & Config

config file-
project URl.co
projectUrl publish Key - anon depricated
Future async initialize

main
WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  before runApp

-> Hour 3 :
Models & Auth Provider setup

=>user_model.dart
-take id,email,createdAt and put it in constructor
-namedConstructor fromMap to convert JSON-> Dart (fetch)
-toMap to convert Dart object to JSON

=>session_model.dart
-teaching session manager
-id,userId,topic,created,updated

Auth provider and SupaBase service do the heavy lifting for login/logout behaviour

=>auth_provider.dart
-state management
-signup/login/logout
-getters user,isLoading,error,authenticated etc..
- security and keeps track of user's authentication

Login Screen
    ↓    user enters email/password 
AuthProvider
     ↓
Supabase
     ↓
Authentication system

extends ChangeNotifier - provides the notifyListeners() method whicl allows this object to tell other parts of the app that something changed e.g, _isloading 

Supabase.instance.client gives your application the object it uses to communicate with Supabase.

UserProfile? is the class from user_model
checkAuthState() .. used when app starts
