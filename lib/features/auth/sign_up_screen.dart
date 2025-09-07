
import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_modal.dart';
import '../../providers/signUpController.dart';
import '../../routes/app_router.dart';

@RoutePage()
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _visible = false;
  bool _agree = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(signUpViewModelProvider);
    final vmNotifier = ref.read(signUpViewModelProvider);

    // MediaQuery se screen size lena
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [

 /// ************************************************ top container

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),

                  Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Enter your details below & free sign up",
                    style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: AppColors.grey),
                  ),
                ],
              ),
            ),


/// ********************************************************* Expanded part
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.03),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Your Email",
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: AppColors.grey)),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: screenWidth * 0.045),
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.035,
                            vertical: screenHeight * 0.02),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Password",
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: AppColors.grey)),
                    ),


                    SizedBox(height: screenHeight * 0.01),


                    TextField(
                      controller: passwordController,
                      obscureText: !_visible,
                      style: TextStyle(fontSize: screenWidth * 0.045),
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.035,
                            vertical: screenHeight * 0.02),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_visible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () =>
                              setState(() => _visible = !_visible),
                        ),
                      ),
                    ),


                    SizedBox(height: screenHeight * 0.025),


                    Row(
                      children: [
                        Checkbox(
                          value: _agree,
                          onChanged: (val) =>
                              setState(() => _agree = val ?? false),
                        ),
                        Expanded(
                          child: Text(
                            "By creating an account you have to agree with our terms & conditions.",
                            style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: AppColors.lightGrey),
                          ),
                        ),
                      ],
                    ),


                    SizedBox(height: screenHeight * 0.02),

                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _agree && !vm.isLoading
                            ? () {
                          vmNotifier.signUp(context,UserModel(
                              email: emailController.text.trim(),
                              password: passwordController.text));
                        }
                            : null,
                        child: vm.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Create account",
                          style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),


                    SizedBox(height: screenHeight * 0.015),


                    if (vm.errorMessage.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Text(
                          vm.errorMessage,
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: AppColors.googleRed),
                        ),
                      ),


                    SizedBox(height: screenHeight * 0.03),


                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.router.replace(const LoginRoute());
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: AppColors.grey),
                            children: const [
                              TextSpan(text: "Already have an account ? "),
                              TextSpan(
                                text: "Log in",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: screenHeight * 0.05),


                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
