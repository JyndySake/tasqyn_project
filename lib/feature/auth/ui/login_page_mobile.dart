import 'package:flutter/material.dart';
import 'package:project_app/feature/main/ui/main_page_mobile.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginPageMobile(),
    debugShowCheckedModeBanner: false,
  ));
}

class LoginPageMobile extends StatefulWidget {
  const LoginPageMobile({Key? key}) : super(key: key);

  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {
  bool isLogin = true;
  bool isResetPassword = false;
  bool rememberMe = false;
  bool showPassword = false;

  // Controllers for form fields
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Validation states
  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _validateAndSubmit() {
    setState(() {
      _emailError = null;
      _usernameError = null;
      _passwordError = null;
      _confirmPasswordError = null;

      if (!isLogin) {
        if (_emailController.text.isEmpty) {
          _emailError = "Required field";
        }
        if (_usernameController.text.isEmpty) {
          _usernameError = "Required field";
        }
        if (_passwordController.text.isEmpty) {
          _passwordError = "Required field";
        }
        if (_confirmPasswordController.text.isEmpty) {
          _confirmPasswordError = "Required field";
        } else if (_passwordController.text != _confirmPasswordController.text) {
          _confirmPasswordError = "Passwords do not match";
        }
      } else {
        if (_usernameController.text.isEmpty) {
          _usernameError = "Required field";
        }
        if (_passwordController.text.isEmpty) {
          _passwordError = "Required field";
        }
      }
    });

    // If no errors, proceed with submission
    if (_emailError == null &&
        _usernameError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      if (isLogin) {
        // Handle login logic
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        // Handle signup logic
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Background image
                      Container(
                        height: MediaQuery.of(context).size.height * 0.34,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        top: MediaQuery.of(context).size.height * 0.24,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0xFF0B1D26),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Header
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.2,
                        left: 20,
                        right: 20,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                isResetPassword
                                    ? "Reset Password"
                                    : isLogin
                                        ? "Welcome!"
                                        : "Join Us!",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isResetPassword
                                    ? "Please enter your email address to request a password reset"
                                    : isLogin
                                        ? "Log in to our website simply"
                                        : "Sign up to our website simply",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Form section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        if (isResetPassword)
                          _buildResetPasswordForm()
                        else if (isLogin)
                          _buildLoginForm()
                        else
                          _buildRegisterForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _emailController,
          hint: "Enter your email",
          errorText: _emailError,
          isPassword: false,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            // Handle reset password logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBD784),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Send",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              isResetPassword = false;
            });
          },
          child: RichText(
            text: const TextSpan(
              text: "Back to ",
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: "Login",
                  style: TextStyle(
                    color: Color(0xFFFBD784),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Username",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _usernameController,
          hint: "Enter your username",
          errorText: _usernameError,
          isPassword: false,
        ),
        const SizedBox(height: 16),
        const Text(
          "Password",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _passwordController,
          hint: "Enter your password",
          errorText: _passwordError,
          isPassword: true,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                  activeColor: const Color(0xFFFBD784),
                ),
                const Text(
                  "Remember me",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isResetPassword = true;
                });
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _validateAndSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBD784),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Log In",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildLoginLink(),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _emailController,
          hint: "Enter your email",
          errorText: _emailError,
          isPassword: false,
        ),
        const SizedBox(height: 16),
        const Text(
          "Username",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _usernameController,
          hint: "Enter your username",
          errorText: _usernameError,
          isPassword: false,
        ),
        const SizedBox(height: 16),
        const Text(
          "Password",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _passwordController,
          hint: "Enter your password",
          errorText: _passwordError,
          isPassword: true,
        ),
        const SizedBox(height: 16),
        const Text(
          "Confirm Password",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _confirmPasswordController,
          hint: "Confirm your password",
          errorText: _confirmPasswordError,
          isPassword: true,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (value) {
                setState(() {
                  rememberMe = value!;
                });
              },
              activeColor: const Color(0xFFFBD784),
            ),
            const Text(
              "Remember me",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _validateAndSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBD784),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildLoginLink(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isPassword,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword ? !showPassword : false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  )
                : null,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
  Widget _buildLoginLink() {
  return Center(
    child: GestureDetector(
      onTap: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: RichText(
        text: TextSpan(
          text: isLogin
              ? "Don’t have an Account? "
              : "Already have an Account? ",
          style: const TextStyle(
            color: Colors.white, // White for the static text
            fontWeight: FontWeight.normal,
          ),
          children: [
            TextSpan(
              text: isLogin ? "Register" : "Login",
              style: const TextStyle(
                color: Color(0xFFFBD784), // Amber for the link
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
