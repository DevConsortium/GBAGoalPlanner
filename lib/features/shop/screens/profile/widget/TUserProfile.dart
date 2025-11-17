// import 'package:flutter/material.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:tea/common/widgets/images/t_circular_image.dart';
// import 'package:tea/utils/constants/colors.dart';
// import 'package:tea/utils/constants/image_strings.dart';
//
// class TUserProfileTile extends StatelessWidget {
//   const TUserProfileTile({
//     super.key,
//     required this.userName,
//     required this.userEmail,
//   });
//
//   final String? userName;
//   final String? userEmail;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: TCircularImage(
//         image: TImages.appleLogo,
//         width: 50,
//         height: 50,
//         padding: 0,
//       ),
//       title: Text('${userName ?? "Unknown"}', style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),),
//       subtitle: Text('${userEmail ?? "Unknown"}', style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),),
//       trailing: IconButton(onPressed: (){}, icon: Icon(Iconsax.edit_copy, color: TColors.white)),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/utils/constants/colors.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  final String? userName;
  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    final firstLetter = (userName != null && userName!.isNotEmpty)
        ? userName![0].toUpperCase()
        : '?';

    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: TColors.primary,
        child: Text(
          firstLetter,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        userName ?? "Unknown",
        style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),
      ),
      subtitle: Text(
        userEmail ?? "Unknown",
        style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),
      ),
      // trailing: IconButton(
      //   onPressed: () {},
      //   icon: Icon(Iconsax.edit_copy, color: TColors.white),
      // ),
    );
  }
}
