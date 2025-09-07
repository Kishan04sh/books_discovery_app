
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/core/app_colors.dart';
import 'package:books_discovery_app/routes/app_router.dart';
import 'package:flutter/material.dart';


@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      //"image": "https://cdn-icons-png.flaticon.com/512/747/747376.png",
      "image": "https://img.freepik.com/premium-vector/flat-vector-illustration-social-platform_9206-2914.jpg",
      "title": "Numerous free \ntrial courses",
      "subtitle": "Free courses for you to \nfind your way to learning"
    },
    {
      // "image": "https://cdn-icons-png.flaticon.com/512/2910/2910768.png",
      "image": "https://www.creativefabrica.com/wp-content/uploads/2024/11/17/young-man-holding-cellphone-with-happy-Graphics-110075491-1-312x208.jpg",
      "title": "Quick and easy\nlearning",
      "subtitle": "Easy and fast learning at\nany time to help you\nimprove various skills"
    },
    {
     // "image": "https://cdn-icons-png.flaticon.com/512/1048/1048953.png",
      "image": "https://www.remotebooksonline.com/blog/wp-content/uploads/Accountant-1.jpg",
      "title": "Create your own \nstudy plan",
      "subtitle": "Study according to the \nstudy plan, make study \nmore motivated"
    },
  ];


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.topRight,
                child: _currentPage != onboardingData.length - 1
                    ? Padding(
                  padding: const EdgeInsets.only(right: 6, top: 8),
                  child: TextButton(
                    onPressed: () {
                      context.router.push(const SignUpRoute());
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
                    : const SizedBox(height: 40),
              ),

              // PageView for 3 screens
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [

                        const SizedBox(height: 20),

                        Container(
                          height: 260,
                          width: 260,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: Image.network(
                            onboardingData[index]["image"]!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.grey,
                              ); // Agar image load fail ho jaye
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator(); // Loading ke time spinner
                            },
                          ),
                        ),


                        const SizedBox(height: 20),

                        Text(
                          onboardingData[index]["title"]!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          onboardingData[index]["subtitle"]!,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500
                          ),
                          textAlign: TextAlign.center,
                        )


                      ],
                    );
                  },
                ),
              ),

              // Dot indicator
              buildDotsIndicator(),

              const SizedBox(height: 50),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: buildBottomButtons(),
              ),


            ],
          ),
        ),
      ),
    );
  }


/// ************************************* buildDotsIndicator

  Widget buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentPage == index
                ? AppColors.primary
                : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  /// ***************************buildBottomButtons******************************

  Widget buildBottomButtons() {
    if (_currentPage == onboardingData.length - 1) {
      // Last page: Sign Up + Log In
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                context.router.push(const SignUpRoute());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: OutlinedButton(
              onPressed: (){
                context.router.replace(const LoginRoute());
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.lightGrey),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Log In",
                style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),


        ],
      );
    } else {
      // Next button
      return ElevatedButton(
        onPressed: () => _controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Next",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }
  }


/// ********************************************************************



}
