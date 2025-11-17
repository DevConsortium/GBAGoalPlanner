import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/features/authentication/controller/signup/signup_controller.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/constants/text_strings.dart';
import 'package:tea/utils/helpers/exports.dart';
import 'package:tea/utils/validators/validation.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.signUpText,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              Form(
                key: controller.signupFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstName,
                            validator: (value) => TValidator.validateEmptyText('First name', value),
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: TTexts.firstName,
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastName,
                            validator: (value) => TValidator.validateEmptyText('Last name', value),
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: TTexts.lastName,
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // User Name
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.userName,
                      validator: (value) => TValidator.validateEmptyText('Username', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: TTexts.userName,
                        prefixIcon: Icon(Iconsax.user_edit),
                      ),
                    ),

                    // Email
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.email,
                      validator: (value) => TValidator.validateEmail(value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: TTexts.email,
                        prefixIcon: Icon(Iconsax.direct),
                      ),
                    ),

                    // phone Number
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.phoneNumber,
                      validator: (value) => TValidator.validatePhoneNumber(value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: TTexts.phoneNo,
                        prefixIcon: Icon(Iconsax.call),
                      ),
                    ),

                    // Domain
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.domain,
                      validator: (value) =>
                          TValidator.validateEmptyText('Domain', value),
                      decoration: const InputDecoration(
                        labelText: "Domain (Doctor, Businessman, etc)",
                        prefixIcon: Icon(Iconsax.category),
                      ),
                    ),

                    // Post
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.post,
                      validator: (value) =>
                          TValidator.validateEmptyText('Post', value),
                      decoration: const InputDecoration(
                        labelText: "Post",
                        prefixIcon: Icon(Iconsax.briefcase),
                      ),
                    ),

                    // Industry
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.industry,
                      validator: (value) =>
                          TValidator.validateEmptyText('Industry', value),
                      decoration: const InputDecoration(
                        labelText: "Industry",
                        prefixIcon: Icon(Iconsax.building),
                      ),
                    ),

                    // Income
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.income,
                      validator: (value) =>
                          TValidator.validateEmptyText('Income', value),
                      decoration: const InputDecoration(
                        labelText: "Income (Anually)",
                        prefixIcon: Icon(Iconsax.money),
                      ),
                    ),

                    // Priority
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.priority,
                      validator: (value) =>
                          TValidator.validateEmptyText('Priority', value),
                      decoration: const InputDecoration(
                        labelText: "Priority  (Family, Income, Lifestyle, etc)",
                        prefixIcon: Icon(Iconsax.activity),
                      ),
                    ),


                    // Password
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

                    // Terms and Condition Checkbox
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child:

                          Obx(()=> Checkbox(value: controller.privacyPolicy.value,
                              onChanged: (value)=> controller.privacyPolicy.value =! controller.privacyPolicy.value)),

                        ),
                        SizedBox(width: TSizes.spaceBtwItems),
                        // Ensure TSizes.spaceBtwItems is a constant or not
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: TTexts.isAgree,
                                // Removed unnecessary string interpolation
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: TTexts.privacyPolicy,
                                style:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.apply(
                                      // Use ?. to avoid null pointer exception
                                      color: dark
                                          ? TColors.white
                                          : TColors.accent,
                                      decoration: TextDecoration.underline,
                                      decorationColor: dark
                                          ? TColors.white
                                          : TColors.accent,
                                    ) ??
                                    Theme.of(context)
                                        .textTheme
                                        .bodyMedium, // Fallback to default style if null
                              ),
                              TextSpan(
                                text: TTexts.and,
                                // Removed unnecessary string interpolation
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: TTexts.termsOfUse,
                                style:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.apply(
                                      color: dark
                                          ? TColors.white
                                          : TColors.accent,
                                      decoration: TextDecoration.underline,
                                      decorationColor: dark
                                          ? TColors.white
                                          : TColors.accent,
                                    ) ??
                                    Theme.of(context)
                                        .textTheme
                                        .bodyMedium, // Fallback to default style if null
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Sign Up button
                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,

                      child:
                      // FilledButton(
                      //   onPressed: controller.signup,
                      //   child: Text(TTexts.tSignup),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.blue,
                      //     foregroundColor: Colors.white,
                      //
                      //   ),
                      // ),
                      FilledButton.icon(
                        onPressed: controller.signup,
                        icon: const Icon(Icons.person_add, size: 20, color: Colors.white),
                        label: Text(
                          TTexts.tSignup,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3, // subtle shadow like Login + Logout
                        ),
                      )


                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),
              // TFormDivider(),
              //
              // const SizedBox(height: TSizes.spaceBtwSections),
              // // Footer
              // TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
