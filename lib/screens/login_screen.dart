// import 'package:earnly/app/controllers/auth_controller.dart';
// import 'package:earnly/app/widgets/custom_button.dart';
// import 'package:earnly/app/widgets/custom_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'register_screen.dart';
// import 'forget_password_screen.dart';
// import '../app/modules/home/views/home_screen.dart';

// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});

//   final formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final authController = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/background_2.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 "Login Account",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 40),

//               // Username or Email
//               // _buildTextField(
//               //   hintText: "Username or Email",
//               //   obscureText: false,
//               // ),
//               CustomTextField(hintText: "Email", controller: emailController),
//               const SizedBox(height: 16),

//               // Password
//               _buildTextField(hintText: "Password", obscureText: true),
//               CustomTextField(
//                 hintText: "Password",
//                 controller: passwordController,
//                 isObscure: true,
//               ),

//               // Forget password link
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ForgetPasswordScreen(),
//                       ),
//                     );
//                   },
//                   style: TextButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                     minimumSize: const Size(50, 20),
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                   child: const Text(
//                     "Forget password",
//                     style: TextStyle(color: Color(0xFF3D5AFE), fontSize: 14),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Login button
//               CustomButton(
//                 isLoading: authController.isloading,
//                 child: Text(
//                   "Login",
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white,
//                   ),
//                 ),
//                 ontap: () async {
//                   if (formKey.currentState!.validate()) {
//                     await authController.login(
//                       email: emailController.text,
//                       password: passwordController.text,
//                     );
//                   }
//                 },
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF9DF5AE),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 0,
//                   ),
//                   onPressed: () {
//                     // ✅ Navigate to HomeScreen after login
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (_) => HomeScreen()),
//                     );
//                   },
//                   child: const Text(
//                     "Login",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Bottom Register text
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Don’t have an account? ",
//                     style: TextStyle(color: Colors.black54, fontSize: 14),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const RegisterScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Register account",
//                       style: TextStyle(
//                         color: Color(0xFF36D986),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Custom text field widget
//   Widget _buildTextField({
//     required String hintText,
//     required bool obscureText,
//   }) {
//     return TextField(
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         hintText: hintText,
//         filled: true,
//         fillColor: const Color(0xFFF6F6F6),
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 16,
//           horizontal: 16,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
