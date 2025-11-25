import 'package:flutter/material.dart';
import 'login_screen.dart';

class ForgetPasswordCodeScreen extends StatefulWidget {
  const ForgetPasswordCodeScreen({super.key});

  @override
  State<ForgetPasswordCodeScreen> createState() =>
      _ForgetPasswordCodeScreenState();
}

class _ForgetPasswordCodeScreenState extends State<ForgetPasswordCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // make sure background covers status bar
      body: Stack(
        children: [
          /// Background Image (fills full screen)
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_2.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Transparent overlay (optional)
          Container(color: Colors.white.withOpacity(0.0)),

          /// Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Password Recovery",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  "A recovery email will be sent to your email address. Enter the 6 digit code below",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                /// 6 Digit Code Input Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      height: 55,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFFF6F6F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => _onDigitChanged(value, index),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 50),

                /// Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9DF5AE),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // Combine the code
                      String code =
                          _controllers.map((c) => c.text).join().trim();
                      if (code.length == 6) {
                        // Example action — navigate to login
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const LoginScreen(),
                        //   ),
                        // );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter all 6 digits."),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                /// Back to Login
                GestureDetector(
                  onTap: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const LoginScreen(),
                    //   ),
                    // );
                  },
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
