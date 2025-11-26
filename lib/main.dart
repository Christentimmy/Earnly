import 'package:earnly/app/bindings/app_bindings.dart';
import 'package:earnly/app/routes/app_pages.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const EarnlyApp());
}

class EarnlyApp extends StatelessWidget {
  const EarnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Earnly",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),
      initialRoute: AppRoutes.splashScreen,
    );
  }
}
