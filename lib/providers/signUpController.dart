import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/routes/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_modal.dart';
import 'LogInController.dart';

/// *****************************************************************************

final signUpViewModelProvider = ChangeNotifierProvider<SignUpViewModel>((ref) {
  return SignUpViewModel(ref);
});

/// ************************************* controller ***********************************

class SignUpViewModel extends ChangeNotifier {
  final Ref _ref; //

  //  Constructor to initialize the Ref object
  SignUpViewModel(this._ref);

  bool isLoading = false;
  String errorMessage = '';

  /// ********************* signUp ****************************

  Future<void> signUp(BuildContext context,UserModel user) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // ✅ Create a new user account using email and password
      await _ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      context.router.replace(const HomeRoute());
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Signup failed';
    } catch (e) {
      errorMessage = 'Something went wrong';
    }
    isLoading = false;
    notifyListeners();
  }


/// *************************************************************


}
