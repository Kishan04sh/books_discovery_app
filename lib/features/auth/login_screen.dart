import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../models/user_modal.dart';
import '../../providers/LogInController.dart';
import '../../routes/app_router.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _visible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(loginViewModelProvider);
    final vmNotifier = ref.read(loginViewModelProvider);

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
                   "Log In",
                   style: TextStyle(
                       fontSize: screenWidth * 0.07,
                       fontWeight: FontWeight.bold),
                 ),

                 SizedBox(height: screenHeight * 0.01),

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


                   // Login Button
                   SizedBox(height: screenHeight * 0.03),

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
                       onPressed: !vm.isLoading
                           ? () {
                         vmNotifier.signIn(context, UserModel(
                           email: emailController.text.trim(),
                           password: passwordController.text,
                         ));
                       }
                           : null,
                       child: vm.isLoading
                           ? const CircularProgressIndicator(color: Colors.white)
                           : Text(
                         "Log In",
                         style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.w500, color: Colors.white),
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
                         context.router.replace(const SignUpRoute());
                       },
                       child: RichText(
                         text: TextSpan(
                           style: TextStyle(
                               fontSize: screenWidth * 0.04,
                               color: AppColors.grey),
                           children: const [
                             TextSpan(text: "Don't have an account ? "),
                             TextSpan(
                               text: "Sign up",
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


                   SizedBox(height: screenHeight * 0.035),

            /// ********************************* "or login with" section
                   const Row(
                     children: [
                       Expanded(
                         child: Divider(thickness: 1, color: AppColors.grey),
                       ),
                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 8.0),
                         child: Text(
                           "or login with",
                           style: TextStyle(
                             color: AppColors.grey,
                             fontSize: 12,
                             fontWeight: FontWeight.w500,
                           ),
                           textAlign: TextAlign.center,
                         ),
                       ),
                       Expanded(
                         child: Divider(thickness: 1, color: AppColors.grey),
                       ),
                     ],
                   ),

                   SizedBox(height: screenHeight * 0.035),

              /// ************************************** Google Login
                   Center(
                     child: InkWell(
                       onTap: () {
                         vmNotifier.signInWithGoogle(context);
                       },
                       child: Image.network(
                         'https://cdn-icons-png.flaticon.com/512/720/720255.png',
                         width: 40,
                         errorBuilder: (context, error, stackTrace) {
                           return const Icon(
                             Icons.g_mobiledata, // fallback icon
                             size: 40,
                             color:AppColors.googleRed,
                           );
                         },
                         loadingBuilder: (context, child, loadingProgress) {
                           if (loadingProgress == null) return child;
                           return const SizedBox(
                             width: 30,
                             height: 30,
                             child: CircularProgressIndicator(strokeWidth: 2,color: AppColors.primary,),
                           );
                         },
                       ),
                     ),
                   ),


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
