
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/features/shop/controllers/Review/ReviewController.dart';
import 'package:tea/navigation_menu.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/constants/text_strings.dart';
import 'package:tea/utils/helpers/exports.dart';


class AddReviewScreen extends StatefulWidget {
  final int weekNumber;
  const AddReviewScreen({required this.weekNumber, super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  // Text editing controllers for form fields
  final TextEditingController _question1Controller = TextEditingController();
  final TextEditingController _question2Controller = TextEditingController();
  final TextEditingController _question3Controller = TextEditingController();
  final TextEditingController _question4Controller = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  int _selectedRating = 0;  // Store the selected rating value

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final int? userId = box.read('userId');

    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [

                  const SizedBox(width: 25),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Review - Week ${widget.weekNumber}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 45),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            bottom: TSizes.defaultSpace,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Text(
              //   TTexts.reviewHeading + ' ${widget.weekNumber}',
              //   style: Theme.of(context).textTheme.headlineMedium,
              // ),
              // const SizedBox(height: TSizes.spaceBtwSections),
              // const Divider(),
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          TTexts.weekQuesFirst,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: _question1Controller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          TTexts.weekQuesSecond,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: _question2Controller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          TTexts.weekQuesThird,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: _question3Controller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          TTexts.weekQuesFourth,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: _question4Controller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          TTexts.ratingText,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: List.generate(10, (index) {
                        final rating = index + 1;
                        final isSelected = _selectedRating == rating;

                        return ChoiceChip(
                          label: Text(
                            rating.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: Colors.blue,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedRating = selected ? rating : 0;
                            });
                          },
                        );
                      }),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          TTexts.whatMade10,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child:
                      FilledButton(
                        onPressed: () async {

                          try {
                            await ReviewController.instance.submitReview(
                              weekNumber: widget.weekNumber,
                              question1: _question1Controller.text,
                              question2: _question2Controller.text,
                              question3: _question3Controller.text,
                              question4: _question4Controller.text,
                              rating: _selectedRating,
                              comment: _commentController.text,
                            );

                            _question1Controller.clear();
                            _question2Controller.clear();
                            _question3Controller.clear();
                            _question4Controller.clear();
                            _commentController.clear();

                            setState(() {
                              _selectedRating = 0;
                            });

                            Get.offAll(() => NavigationMenu());
                          } catch (e) {
                            print("ERROR WHILE SUBMITTING REVIEW: $e");
                            Get.snackbar(
                              "Error",
                              "Something went wrong while submitting!",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },

                        style: FilledButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(TTexts.submit),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}