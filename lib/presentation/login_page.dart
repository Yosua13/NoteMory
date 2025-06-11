import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_mory/presentation/home_page.dart';
import 'package:note_mory/presentation/register_page.dart';
import 'package:note_mory/providers/google_sign_in_provider.dart';
import 'package:note_mory/providers/onboarding_provider.dart';
import 'package:note_mory/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Color statusBarColor = Colors.white;
    // const Brightness iconBrighness = Brightness.dark;

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: statusBarColor,
    //     statusBarIconBrightness: iconBrighness,
    //     systemNavigationBarColor: statusBarColor,
    //     systemNavigationBarIconBrightness: iconBrighness,
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        backgroundColor: const Color(0xFF440C0C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xFF440C0C),
          ),
          padding: const EdgeInsets.only(top: 54, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome to Note Mory",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                "Make Your Memory",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              _buildFormContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          /// Email Field
          text(text: 'Email', fontSize: 16, fontWeight: FontWeight.bold),
          textField(
            controller: _emailController,
            hint: 'Enter your email address',
            suffixIcon: const Icon(Icons.email),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          /// Password Field
          text(text: 'Password', fontSize: 16, fontWeight: FontWeight.bold),
          textField(
            controller: _passwordController,
            hint: 'Enter your password',
            obscureText: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 48),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);

              try {
                // Lakukan login Google
                bool isSuccess = await provider.googleLogin(context);

                // Jika login berhasil
                if (isSuccess && context.mounted) {
                  // onboarding
                  await Provider.of<OnboardingProvider>(context, listen: false)
                      .setLoggedIn(true);

                  showSuccessDialog(
                      context, 'Login Success', 'Welcome to Note Mory!');

                  // Delay sebentar untuk dialog sukses
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  });
                } else {
                  // Jika gagal
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Login gagal. Silakan coba lagi.")),
                  );
                }
              } catch (e) {
                // Tangkap dan tampilkan error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Login gagal: $e")),
                );
              }
            },
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Colors.red,
            ),
            label: const Text("Sign In with Google"),
          ),

          const SizedBox(height: 48),

          // Login Button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool isLoginSuccessful =
                      await Provider.of<UserProvider>(context, listen: false)
                          .loginUser(
                              _emailController.text, _passwordController.text);

                  if (isLoginSuccessful) {
                    // onboarding
                    await Provider.of<OnboardingProvider>(context,
                            listen: false)
                        .setLoggedIn(true);

                    // Navigate to HomePage if login is successful
                    showSuccessDialog(
                        context, 'Login Success', 'Welcome to Note Mory!');
                    Future.delayed(
                      const Duration(milliseconds: 1500),
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                    );
                  } else if (isLoginSuccessful == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid credentials')),
                    );
                  }
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Register Link with TextSpan
          Center(
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "Register",
                    style: const TextStyle(
                      color: Color(0xFFFFCE3C),
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to RegisterPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amber),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }

  Widget text({String? text, double? fontSize, FontWeight? fontWeight}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            '$text',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ],
    );
  }

  void showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Timer untuk menutup dialog setelah 1 detik
        Future.delayed(const Duration(seconds: 1), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          backgroundColor: const Color(0xFFFFB300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
