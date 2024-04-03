import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/challenge_screen_controller.dart';
import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/models/voter.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChallengePortrait extends StatefulWidget {
  final Challenge challenge;
  final BoxConstraints cons;

  const ChallengePortrait(
      {super.key, required this.challenge, required this.cons});

  @override
  State<ChallengePortrait> createState() => _ChallengePortraitState();
}

class _ChallengePortraitState extends State<ChallengePortrait> {
  late ChallengeScreenController controller;
  late AuthController auth;

  @override
  void initState() {
    controller = Get.put(ChallengeScreenController());
    auth = Get.find();
    controller.initVotes(widget.challenge);
    if (auth.user.value != null) {
      controller.getVoter(widget.challenge.id, auth.user.value!.uid);
    }
    controller.voter.listen((p0) {
      controller.votedFor.value = _getInitialVote(p0);
    });

    super.initState();
  }

  int _getInitialVote(Voter? p0) {
    if (p0 == null) {
      return -1;
    } else {
      return p0.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                )),
            flexibleSpace: FlexibleSpaceBar(
              background: ColoredBox(
                color: Colors.orange,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.challenge.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
            sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _dataItem(Icons.history,
                            toTimeDelay(widget.challenge.publishDate)),
                        _dataItem(Icons.how_to_vote,
                            NumberFormat.compact().format(widget.challenge.optionsVotes.reduce((value, element) => value+element))),

                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.challenge.body,
                style: const TextStyle(
                  color: ProjectColors.disabled,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "What do you think?",
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: ProjectColors.disabled),
              ),
              const SizedBox(
                height: 10,
              ),

              Obx(() {
                final votes = controller.currentVotes;

                return Column(
                  children: List.generate(
                      widget.challenge.optionsCount,
                      (index) => VoteItem(
                          lable: widget.challenge.optionsName[index],
                          selected: controller.votedFor.value == index,
                          width: MediaQuery.of(context).size.width,
                          votes: votes[index],
                          totalVotes: controller.currentVotesTotal.value,
                          onTap: () {
                            controller.voteItemClicked(
                                index, widget.challenge.id);
                          })),
                );
              }),
              const SizedBox(
                height: 20,
              ),

              // Obx(() {
              //   return VoteItem(
              //     selected: controller.votedFor.value ==
              //         VoteType.AGAINST.index,
              //     width: MediaQuery
              //         .of(context)
              //         .size
              //         .width,
              //     votes: controller.currentVotesAgainst.value,
              //     totalVotes: controller.currentVotesTotal.value,
              //     onTap: () {
              //       controller.voteItemClicked(
              //         VoteType.AGAINST,
              //         widget.challenge.id,
              //       );
              //     },
              //   );
              // }),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () async {
                  if (auth.user.value == null) return;
                  final res = await controller.updateVotedData(
                    widget.challenge.id,
                    controller.votedFor.value,
                    auth.user.value!,
                    _getInitialVote(controller.voter.value),
                  );
                  if (res is Success<Map<String, dynamic>>) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("vote updated")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Some error occurred")));
                  }
                },
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: ProjectColors.lightBlack,
                child: const Text(
                  "Vote",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ])),
          )
        ],
      ),
    );
  }
}

String toTimeDelay(DateTime date) {
  final now = DateTime.now();
  final delay = now.difference(date);
  final days = delay.inDays;
  String str = "";
  if (days == 0) {
    str = "today";
  } else if (days == 1) {
    str = "yesterday";
  } else {
    str = "$days days ago";
  }
  return str;
}

// String _calculateScore(Challenge challenge) {
//   if (challenge.totalVotes == 0) return "0";
//   return (challenge.votesFor / challenge.totalVotes).toStringAsFixed(2);
// }

Widget _dataItem(IconData icon, String data) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    constraints: const BoxConstraints(minWidth: 60),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(width: 1.3, color: Colors.grey)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: ProjectColors.disabled,
          size: 20,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(data,
            style: const TextStyle(
              fontSize: 13,
              color: ProjectColors.disabled,
              fontWeight: FontWeight.w500,
            ))
      ],
    ),
  );
}

class VoteItem extends StatelessWidget {
  final String lable;
  final double width;
  final int votes;
  final int totalVotes;
  final bool selected;
  final Function() onTap;

  const VoteItem(
      {super.key,
      required this.lable,
      required this.selected,
      required this.width,
      required this.votes,
      required this.totalVotes,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lable ,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: ProjectColors.disabled),),
            const SizedBox(height: 10,),
            Container(
              width: width,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: selected ? Colors.green : Colors.transparent,
                    width: 1.5,
                  ),
                  color: ProjectColors.greyBackground),
              child: Stack(
                children: [
                  AnimatedContainer(
                    width: _toVotes(votes, totalVotes) * width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.black),
                    duration: const Duration(milliseconds: 200),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      votes.toString(),
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _toVotes(int votes, int total) {
    if (total == 0) return 0;
    return (votes / totalVotes);
  }
}

extension on DateTime {
  String formatted() {
    return DateFormat("dd MMM , yyyy").format(this);
  }
}
