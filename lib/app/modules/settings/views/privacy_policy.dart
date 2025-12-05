

import 'package:earnly/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: Colors.white,
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            """ 
      
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean id ligula vulputate, fermentum leo vitae, vestibulum tortor. Etiam aliquet urna sed nibh ullamcorper condimentum. Aenean eu dui sit amet nunc consectetur pellentesque nec et tortor. Sed sit amet tristique est. Nulla urna sem, lobortis non condimentum non, porta a lectus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Sed convallis semper euismod. Morbi sodales dui nisl, ut iaculis mauris consequat eget. Maecenas aliquet pharetra ex id dapibus. Cras condimentum elit at libero rutrum, pharetra fermentum dui mollis. Fusce hendrerit lorem nulla, non facilisis velit faucibus vel. Morbi feugiat mollis tincidunt. Nam eleifend sagittis eros, sed gravida lorem tincidunt vitae. Morbi eleifend nec massa et aliquet.

In hac habitasse platea dictumst. Aliquam et erat ac ipsum accumsan pretium in vitae leo. Vivamus leo leo, vestibulum eu tellus sed, laoreet tristique nunc. Nullam semper pulvinar purus id malesuada. Sed in consectetur lectus, nec volutpat quam. Sed id erat vitae lorem volutpat ornare. Ut eu auctor libero, eu varius ante. Integer dictum ornare sapien, eu lacinia ex.

Curabitur a accumsan ligula. Phasellus aliquet ipsum erat, quis mollis ex finibus eu. Nullam porttitor nisi eget magna elementum rutrum. Fusce mollis imperdiet consectetur. Vestibulum massa eros, mollis eu est eget, feugiat semper ipsum. Integer vehicula ultrices sapien eget feugiat. Integer vulputate urna nec lacinia semper. Donec varius tellus metus, quis viverra orci elementum quis. In semper vulputate erat, at luctus massa ultrices vel. Ut pharetra nec dui nec tincidunt. Nam vitae velit ullamcorper, porta orci luctus, tempus odio. In condimentum gravida felis vitae luctus. Praesent sit amet dapibus eros.

Vestibulum tincidunt metus massa, vel scelerisque augue consectetur non. Aliquam id diam malesuada, ornare diam ut, molestie dolor. Nunc egestas, massa vel luctus commodo, magna magna accumsan sem, ultricies pulvinar ex ipsum ut ex. Vivamus suscipit, turpis vitae ornare auctor, elit libero porta orci, rutrum convallis magna urna sit amet purus. Morbi lobortis volutpat risus vel commodo. Nullam at nulla id nisi vulputate lobortis. Praesent et nibh vel leo consectetur volutpat. Proin suscipit purus ut felis sodales pharetra. Nullam maximus sed mi eget vehicula.

Vivamus vitae facilisis massa. Sed lobortis pellentesque neque ac euismod. Duis venenatis ligula eget ante consectetur facilisis. Vivamus sit amet nisi nec arcu consequat ullamcorper. Proin vitae egestas elit. Fusce sit amet hendrerit velit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus vehicula vulputate fringilla. Proin nec arcu facilisis, suscipit lectus ac, sodales ex. Morbi nec pulvinar sapien. Praesent non felis laoreet, ultrices ipsum et, fermentum urna. Suspendisse vitae viverra urna. Nullam sed sem commodo, rutrum lectus nec, consectetur felis.
      """,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
