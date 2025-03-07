import 'package:astroverse/components/delete_account_bottom_sheet.dart';
import 'package:astroverse/components/update_bank_bottomsheet.dart';
import 'package:astroverse/components/upgrade_features_bottom_sheet.dart';
import 'package:astroverse/components/upgrade_range_bottomsheet.dart';
import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/models/user_bank_details.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/num_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

class NamePlate extends StatelessWidget {
  final User user;
  final ExtraInfo info;
  final UserBankDetails? bankDetails;
  final void Function() onLogOut;
  final void Function() onEdit;
  static const _sizeIcon = 22.0;

  const NamePlate({
    super.key,
    required this.user,
    required this.onLogOut,
    required this.onEdit,
    required this.info,
    this.bankDetails,
  });

  @override
  Widget build(BuildContext context) {
    var divider = const Divider(
      thickness: 2,
      color: ProjectColors.greyBackground,
    );

    final crypto = Crypt();

    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: GlobalDims.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 65,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(120)),
                    child: Image(
                      image: NetworkImage(user.image),
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  crypto.decryptFromBase64String(user.name),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SelectableText(
                  user.uid,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Personal Information",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          nameItem(
                              const Icon(
                                Icons.email_outlined,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'Email',
                              crypto.decryptFromBase64String(user.email)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.phone_android_outlined,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'Phone',
                              crypto.decryptFromBase64String(user.phNo)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.wallet,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'Plan',
                              user.plan.toString()),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.account_box_outlined,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'Role',
                              user.astro ? "astrologer" : "general"),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Activity",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          nameItem(
                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'Profile Views',
                              NumberParser()
                                  .toSocialMediaString(user.profileViews)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'Posts',
                              NumberParser().toSocialMediaString(info.posts)),
                          if (user.astro == true) divider,
                          if (user.astro == true)
                            nameItem(
                                const Icon(
                                  Icons.data_thresholding_outlined,
                                  color: Colors.blue,
                                  size: _sizeIcon,
                                ),
                                'Sales',
                                NumberParser()
                                    .toSocialMediaString(info.servicesSold)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.calendar_month,
                                size: _sizeIcon,
                                color: Colors.blue,
                              ),
                              'joined',
                              DateFormat('dd MMM yyyy')
                                  .format(info.joiningDate)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.calendar_today_sharp,
                                size: _sizeIcon,
                                color: Colors.blue,
                              ),
                              'last',
                              DateFormat('dd MMM yyyy')
                                  .format(info.lastActive)),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 5.0,
                          children: [
                            Visibility(
                              visible: warningVisible(),
                              child: const Tooltip(
                                triggerMode: TooltipTriggerMode.tap,
                                showDuration: Duration(seconds: 6),
                                message:
                                    "one of UPI or Bank account details are required for astrologers to receive payments.",
                                child: Icon(
                                  Icons.warning,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                            const Text(
                              "Account",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              Scaffold.of(context).showBottomSheet(
                                  (context) => UpdateBankBottomSheet(
                                      bankDetails: bankDetails != null
                                          ? bankDetails!.decrypted()
                                          : UserBankDetails(
                                              accountNumber: "",
                                              ifscCode: "",
                                              branch: "",
                                              upiId: "")),
                                  constraints: BoxConstraints(
                                      maxHeight: Get.height * 0.7));
                            },
                            icon: const Icon(
                              Icons.mode_edit_outline,
                              color: Colors.blue,
                            ))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          nameItem(
                              const Icon(
                                Icons.account_balance_wallet,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'UPI',
                              bankDetails == null
                                  ? "unavailable"
                                  : crypto.decryptFromBase64String(
                                      bankDetails!.upiId)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.numbers_sharp,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'Account No.',
                              bankDetails == null
                                  ? "unavailable"
                                  : crypto.decryptFromBase64String(
                                      bankDetails!.accountNumber)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.numbers,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'IFSC Code',
                              bankDetails == null
                                  ? "unavailable"
                                  : crypto.decryptFromBase64String(
                                      bankDetails!.ifscCode)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.alt_route,
                                size: _sizeIcon,
                                color: Colors.blue,
                              ),
                              'branch',
                              bankDetails == null
                                  ? "unavailable"
                                  : crypto.decryptFromBase64String(
                                      bankDetails!.branch)),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Utilities",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          nameItemWithButton(
                            const Icon(
                              Icons.logout,
                              color: Colors.blue,
                              size: _sizeIcon,
                            ),
                            'logout',
                            onLogOut,
                          ),
                          divider,
                          nameItemWithButton(
                              const Icon(
                                Icons.request_page_outlined,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'terms of service',
                              () {}),
                          divider,
                          nameItemWithButton(
                              const Icon(
                                Icons.upgrade_rounded,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'upgrade', () {
                            Scaffold.of(context).showBottomSheet((context) {
                              if (user.astro == false) {
                                return UpgradeFeaturesBottomSheet(user: user);
                              }
                              return UpgradeRangeBottomSheet(
                                user: user,
                              );
                            });
                          }),
                          divider,
                          nameItemWithButton(
                              const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: _sizeIcon,
                              ),
                              'delete', () {
                            Scaffold.of(context).showBottomSheet((context) {
                              return const DeleteAccountBottomSheet();
                            });
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Contact Us",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          nameItem(
                              const Icon(
                                Icons.call_outlined,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'Ph.no',
                              "+91 8210693766"),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.mail_outline,
                                color: Colors.blue,
                                size: _sizeIcon,
                              ),
                              'Email',
                              'Demouser9@gmail.com'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  bool warningVisible() {
    if (!user.astro) return false;
    if (bankDetails == null) return true;
    return !bankDetails!.areValid();
  }

  Widget nameItem(
    Icon icon,
    String label,
    String? value,
  ) {
    if (value.isBlank == true || value == null) {
      value = "unavailable";
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              icon,
              Text(
                label,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  color: ProjectColors.disabled,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis),
            ),
          )
        ],
      ),
    );
  }

  Widget nameItemWithButton(Icon icon, String label, void Function() onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              icon,
              Text(
                label,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: 35,
            child: IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.blue,
                )),
          )
        ],
      ),
    );
  }
}
