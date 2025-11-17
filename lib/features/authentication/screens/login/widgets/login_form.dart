import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/features/authentication/controller/login/login_controller.dart';
import 'package:tea/features/authentication/screens/signup/signup.dart';
import 'package:tea/navigation_menu.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/constants/text_strings.dart';
import 'package:tea/utils/validators/validation.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {


    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: TSizes.spaceBtwSections,
        ),
        child: Column(
          children: [
            TextFormField(
              controller: controller.email,
              validator: (value) => TValidator.validateEmptyText('Username is required',value),

              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),

            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Obx(
                  ()=> TextFormField(
                controller: controller.password,
                validator: (value) => TValidator.validatePassword(value),
                expands: false,
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: TTexts.password,
                  prefixIcon: Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                      onPressed: ()=>controller.hidePassword.value = !controller.hidePassword.value,
                      icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash: Iconsax.eye)),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields / 2),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Row(
                  children: [
                    Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) =>
                      controller.rememberMe.value = value ?? false,
                    ),
                    const Text(TTexts.tRememberMe),
                  ],
                )),
                TextButton(
                  onPressed: () {},
                  child: const Text(TTexts.tForgetPassword),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),


            SizedBox(
              width: double.infinity,
              child:
              FilledButton.icon(
                onPressed: () => controller.loginUser(),
                icon: const Icon(Icons.login, size: 20, color: Colors.white),
                label: const Text(
                  TTexts.tLogin,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3, // Subtle modern shadow
                ),
              )

            ),

            const SizedBox(height: 10.0),

            SizedBox(
              width: double.infinity,
              child:
              ElevatedButton(
                onPressed: ()=> Get.to(() => const SignupScreen()),
                child: Text(TTexts.tSignup),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,

                ),
              ),
            ),

            // Create Account
          ],
        ),
      ),
    );
  }
}
