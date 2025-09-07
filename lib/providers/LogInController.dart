import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_modal.dart';
import '../routes/app_router.dart';

/// ***************************************************************************
final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
  return LoginViewModel(ref);
});

/// **********************************************************************
class LoginViewModel extends ChangeNotifier {
  final Ref _ref;

  LoginViewModel(this._ref);

  bool isLoading = false;
  String errorMessage = '';

  /// *********************************************** Sign in using email and password
  Future<void> signIn(BuildContext context, UserModel user) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await _ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      // ✅ Navigate to HomeScreen on successful sign-in
      context.router.replace(const HomeRoute());
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Sign in failed';
      print("errorMessage $errorMessage");
    } catch (e) {
      errorMessage = 'Something went wrong';
    }

    isLoading = false;
    notifyListeners();
  }

  /// ***********************************************************************
  Future<void> signInWithGoogle(BuildContext context) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        errorMessage = 'Google sign-in aborted';
        isLoading = false;
        notifyListeners();
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _ref.read(firebaseAuthProvider).signInWithCredential(credential);

      context.router.replace(const HomeRoute());
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Google sign-in failed';
      print("errorMessage $errorMessage");
    } catch (e) {
      errorMessage = 'Something went wrong';
    }

    isLoading = false;
    notifyListeners();
  }

  /// **********************************************************************************
}



/// ***********************************************************************
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});


final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// *********************************************************************