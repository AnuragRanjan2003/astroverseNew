import 'package:astroverse/components/buy_coins.dart';
import 'package:astroverse/components/delete_account_bottom_sheet.dart';
import 'package:astroverse/components/update_bank_bottomsheet.dart';
import 'package:astroverse/components/update_qualifications_bottom_sheet.dart';
import 'package:astroverse/components/upgrade_features_bottom_sheet.dart';
import 'package:astroverse/components/upgrade_range_bottomsheet.dart';
import 'package:astroverse/components/withdraw_request_bottom_sheet.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/db/plans_db.dart';
import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/models/qualifications.dart';
import 'package:astroverse/models/user_bank_details.dart';
import 'package:astroverse/models/withdraw_request.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/geo.dart';
import 'package:astroverse/utils/num_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user.dart';

class NamePlate extends StatelessWidget {
  final User user;
  final ExtraInfo info;
  final String address;
  final void Function() refreshAddress;
  final UserBankDetails? bankDetails;
  final void Function() onLogOut;
  final void Function() onEdit;
  final void Function(Qualification) onQualificationUpdate;
  static const _sizeIcon = 22.0;

  const NamePlate({
    super.key,
    required this.user,
    required this.onLogOut,
    required this.onEdit,
    required this.info,
    this.bankDetails,
    required this.onQualificationUpdate,
    required this.address,
    required this.refreshAddress,
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
                  "uid: ${user.uid}",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Visibility(
                  visible: user.astro,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            children: [
                              Visibility(
                                visible: user.qualifications.isEmpty,
                                child: const Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    message:
                                        "Add your qualifications for a better engagement.",
                                    child: Icon(
                                      Icons.warning_rounded,
                                      size: 20,
                                      color: Colors.orangeAccent,
                                    )),
                              ),
                              const Text(
                                "Qualifications",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Scaffold.of(context).showBottomSheet(
                                  (context) => UpdateQualificationsBottomSheet(
                                        previousQualifications:
                                            user.qualifications,
                                        onUpdate: onQualificationUpdate,
                                      ),
                                  constraints:
                                      const BoxConstraints(maxHeight: 570));
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 22,
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          user.qualifications.isNotEmpty
                              ? user.qualifications
                              : "empty",
                          style: const TextStyle(
                            color: ProjectColors.disabled,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Business Location",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            onPressed: () {
                              refreshAddress();
                            },
                            icon: const Icon(Icons.refresh_sharp))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white),
                      child: Text(
                        address,
                        style: const TextStyle(
                          color: ProjectColors.disabled,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
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
                                color: ProjectColors.primary,
                                size: _sizeIcon,
                              ),
                              'Email',
                              crypto.decryptFromBase64String(user.email)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.phone_android_outlined,
                                color: ProjectColors.primary,
                                size: _sizeIcon,
                              ),
                              'Phone',
                              crypto.decryptFromBase64String(user.phNo)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.wallet,
                                color: ProjectColors.primary,
                                size: _sizeIcon,
                              ),
                              'Plan',
                              _planToName(
                                  user.plan, user.astro, user.featured)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.account_box_outlined,
                                color: ProjectColors.primary,
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
                                color: ProjectColors.primary,
                                size: _sizeIcon,
                              ),
                              'Profile Views',
                              NumberParser()
                                  .toSocialMediaString(user.profileViews)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.chat_bubble_outline,
                                color: ProjectColors.primary,
                                size: _sizeIcon,
                              ),
                              'Posts',
                              NumberParser().toSocialMediaString(info.posts)),
                          if (user.astro == true) ...[
                            divider,
                            nameItem(
                                const Icon(
                                  Icons.data_thresholding_outlined,
                                  color: ProjectColors.primary,
                                  size: _sizeIcon,
                                ),
                                'Sales',
                                NumberParser()
                                    .toSocialMediaString(info.servicesSold)),
                            divider,
                            nameItem(
                                const Icon(
                                  Icons.monetization_on_outlined,
                                  color: ProjectColors.primary,
                                  size: _sizeIcon,
                                ),
                                'money generated',
                                NumberParser()
                                    .toSocialMediaString(info.moneyGenerated)),
                            divider,
                            nameItem(
                                const Icon(
                                  Icons.monetization_on_outlined,
                                  color: ProjectColors.primary,
                                  size: _sizeIcon,
                                ),
                                'money withdrawn',
                                NumberParser()
                                    .toSocialMediaString(info.moneyWithdrawn)),
                          ],
                          divider,
                          nameItem(
                              const Icon(
                                Icons.calendar_month,
                                size: _sizeIcon,
                                color: ProjectColors.primary,
                              ),
                              'joined',
                              DateFormat('dd MMM yyyy')
                                  .format(info.joiningDate)),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.calendar_today_sharp,
                                size: _sizeIcon,
                                color: ProjectColors.primary,
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
                                color: ProjectColors.primary,
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
                                color: ProjectColors.primary,
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
                                color: ProjectColors.primary,
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
                                color: ProjectColors.primary,
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
                              color: ProjectColors.primary,
                              size: _sizeIcon,
                            ),
                            'logout',
                            onLogOut,
                          ),
                          divider,
                          nameItemWithButton(
                              const Icon(
                                Icons.request_page_outlined,
                                color: ProjectColors.primary,
                                size: _sizeIcon,
                              ),
                              'terms of service', () async {
                            final url = Uri.parse(BackEndStrings.tnCUrl);
                            if (!await launchUrl(url)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("could not open url")));
                            }
                          }),
                          divider,
                          nameItemWithButton(
                              const Icon(
                                Icons.upgrade_rounded,
                                color: ProjectColors.primary,
                                size: _sizeIcon,
                              ),
                              'upgrade', () {
                            if (user.featured) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "featured users can't upgrade")));
                              return;
                            }

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
                                Icons.add_circle,
                                color: ProjectColors.primary,
                              ),
                              "buy coins", () {
                            Scaffold.of(context).showBottomSheet(
                              (context) => const BuyCoinsSheet(),
                              constraints:
                                  BoxConstraints(maxHeight: Get.height * 0.8),
                            );
                          }),
                          user.astro ? divider : const SizedBox.shrink(),
                          user.astro
                              ? nameItemWithButton(
                                  const Icon(
                                    Icons.monetization_on_outlined,
                                    color: ProjectColors.primary,
                                  ),
                                  "withdraw money", () {
                                  Scaffold.of(context).showBottomSheet(
                                    (context) => WithdrawRequestBottomSheet(
                                        user: user,
                                        onConfirm: (wr) => _handleOnConfirm(
                                              wr,
                                              Get.find<AuthController>(),
                                              context,
                                            )),
                                    constraints: BoxConstraints(
                                        maxHeight: Get.height * 0.55),
                                  );
                                })
                              : const SizedBox.shrink(),
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
                                color: ProjectColors.primary,
                                size: _sizeIcon,
                              ),
                              'Ph.no',
                              "+91 8210693766"),
                          divider,
                          nameItem(
                              const Icon(
                                Icons.mail_outline,
                                color: ProjectColors.primary,
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
                  color: ProjectColors.primary,
                )),
          )
        ],
      ),
    );
  }

  String? _planToName(int plan, bool astro, bool featured) {
    if (featured) return "featured";

    if (astro) {
      return Plans.astroPlans
          .firstWhere((element) => element.value == plan)
          .name;
    } else {
      if (plan == 0) return Plans.plans.first.name;
      return Plans.plans
          .firstWhere(
              (element) => element.value + VisibilityPlans.all + 1 == plan)
          .name;
    }
  }

  _handleOnConfirm(
      WithdrawRequest wr, AuthController auth, BuildContext context) {
    auth.addWithdrawRequest(wr, (p0) {
      Navigator.of(context).pop();
      if (p0.isSuccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("request submitted")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("some error occurred")));
      }
    });
  }
}
