import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/num_parser.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeemMoreBottomSheet extends StatefulWidget {
  final User user;
  final ExtraInfo extraInfo;

  const SeemMoreBottomSheet(
      {super.key, required this.user, required this.extraInfo});

  @override
  State<SeemMoreBottomSheet> createState() => _SeemMoreBottomSheetState();
}

class _SeemMoreBottomSheetState extends State<SeemMoreBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.greyBackground,
      appBar: AppBar(
        title: Text(
          "${Crypt().decryptFromBase64String(widget.user.name)}'s Profile",
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SafeArea(
            child: Column(
              children: [
                _buildBox("Qualifications", Text(widget.user.qualifications.isEmpty?"empty":widget.user.qualifications)),
                _buildBox("Featured", Text(widget.user.featured?"Feature":"Not Featured")),

                _buildBox(
                  "Activity",
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "posts",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              NumberParser().toSocialMediaString(widget.extraInfo.posts),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: ProjectColors.disabled,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "sold services",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                                NumberParser().toSocialMediaString(widget.extraInfo.servicesSold),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: ProjectColors.disabled,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "profile views",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              NumberParser().toSocialMediaString(widget.user.profileViews),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: ProjectColors.disabled,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBox(
                  "dates",
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                ),
                                Text(
                                  "joining",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Text(
                              DateFormat("dd MMM , yyyy")
                                  .format(widget.extraInfo.joiningDate),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: ProjectColors.disabled,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                ),
                                Text(
                                  "last active",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Text(
                              DateFormat("dd MMM , yyyy")
                                  .format(widget.extraInfo.lastActive),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: ProjectColors.disabled,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildBox(String title, Widget content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 8,
          ),
          content,
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
