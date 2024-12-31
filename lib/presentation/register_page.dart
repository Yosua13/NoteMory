import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:note_mory/models/user.dart';
import 'package:note_mory/presentation/login_page.dart';
import 'package:note_mory/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  String _selectedGender = "Laki-laki";
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisibleP = false;
  bool _isPasswordVisibleCP = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      /// Format tanggal menjadi tanggal-bulan-tahun
      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
      setState(() {
        _tanggalLahirController.text = formatter.format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF440C0C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xFF440C0C),
          ),
          padding: const EdgeInsets.only(
            top: 16,
            right: 16,
            left: 16,
            bottom: 84,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your personal data correctly!",
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
          /// Username Field
          text(text: 'User Name', fontSize: 16, fontWeight: FontWeight.bold),
          textField(
            controller: _usernameController,
            hint: 'Enter your username',
            suffixIcon: const Icon(Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

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

          /// Phone Number Field
          text(text: 'Phone Number', fontSize: 16, fontWeight: FontWeight.bold),
          textField(
            controller: _phoneNumberController,
            hint: 'Enter your phone number',
            suffixIcon: const Icon(Icons.phone),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(13)
            ],
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          /// Date of Birth Field
          text(
              text: 'Date of Birth', fontSize: 16, fontWeight: FontWeight.bold),
          dateField(
            controller: _tanggalLahirController,
            hint: 'Enter your Date of Birth',
            onTap: () => _selectDate(context),
            suffixIcon: const Icon(Icons.date_range),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your date of birth';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          /// Gender Field
          text(text: 'Gender', fontSize: 16, fontWeight: FontWeight.bold),
          dropDownGender(
            selectedGender: _selectedGender,
            onChanged: (String? value) {
              setState(() {
                _selectedGender = value!;
              });
            },
          ),
          const SizedBox(height: 16),

          /// Password Field
          text(text: 'Password', fontSize: 16, fontWeight: FontWeight.bold),
          textField(
            controller: _passwordController,
            hint: 'Enter your password',
            obscureText: !_isPasswordVisibleP,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisibleP ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisibleP = !_isPasswordVisibleP;
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
          const SizedBox(height: 16),

          /// Confirm Password Field
          text(
              text: 'Confirm Password',
              fontSize: 16,
              fontWeight: FontWeight.bold),
          textField(
            controller: _confirmPasswordController,
            hint: 'Confirm your password',
            obscureText: !_isPasswordVisibleCP,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisibleCP ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisibleCP = !_isPasswordVisibleCP;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 48),

          /// Register Button
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  User newUser = User(
                    username: _usernameController.text,
                    email: _emailController.text,
                    phoneNumber: _phoneNumberController.text,
                    birth: _tanggalLahirController.text,
                    gender: _selectedGender,
                    password: _passwordController.text,
                  );
                  Provider.of<UserProvider>(context, listen: false)
                      .registerUser(newUser);

                  showSuccessDialog(context, 'Register Success',
                      'Congratulations, You have successfully registered');

                  Future.delayed(const Duration(milliseconds: 1500), () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  });
                }
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          /// Register Link with TextSpan
          Center(
            child: RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "Login",
                    style: const TextStyle(
                      color: Color(0xFFe6c068),
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to LoginPage
                        Navigator.of(context).pop();
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
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
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
          labelStyle: const TextStyle(color: Colors.black),
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
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget dateField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    Function()? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
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
          labelStyle: const TextStyle(color: Colors.black),
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
        onTap: onTap,
        readOnly: true,
      ),
    );
  }

  Widget dropDownGender({
    required String? selectedGender,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value:
            selectedGender, // Make sure the value matches one of the options or is null
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Pilih Jenis Kelamin',
          labelStyle: const TextStyle(color: Colors.black),
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
        ),
        items: const [
          DropdownMenuItem<String>(
            value: 'Laki-laki',
            child: Text('Laki-laki'),
          ),
          DropdownMenuItem<String>(
            value: 'Perempuan',
            child: Text('Perempuan'),
          ),
        ],
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
        /// Timer untuk menutup dialog setelah 1 detik
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
