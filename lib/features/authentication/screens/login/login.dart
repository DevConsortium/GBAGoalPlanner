import 'package:flutter/material.dart';
import 'package:tea/common/widgets/styles/spacing_styles.dart';
import 'package:tea/features/authentication/screens/login/widgets/login_form.dart';
import 'package:tea/features/authentication/screens/login/widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // logo, title, subtitle
              TLoginHeader(),

              // Form
              TLoginForm(),

              // Divider
              // TFormDivider(),

              // const SizedBox(height: TSizes.spaceBtwSections),
              // Footer
              // TSocialButtons(),

            ],
          ),
        ),
      ),
    );
  }
}
