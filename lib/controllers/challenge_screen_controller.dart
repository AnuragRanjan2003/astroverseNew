import 'dart:developer';

import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/models/voter.dart';
import 'package:astroverse/repo/challenge_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/vote_type_enum.dart';
import 'package:get/get.dart';

class ChallengeScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt votedFor = (-1).obs;
  RxList<int> currentVotes = RxList();
  RxInt currentVotesTotal = 0.obs;
  Rxn<Voter> voter = Rxn();

  final ChallengeRepo _repo = ChallengeRepo();

  initVotes(Challenge ch) {
    currentVotes.value = ch.optionsVotes;
    currentVotesTotal.value =
        ch.optionsVotes.reduce((value, element) => value + element);
  }

  getVoter(String challengeId, String uid) {
    _repo.getVoterById(challengeId, uid).then((value) {
      if (value is Success<Voter>) {
        voter.value = value.data;
      } else {
        voter.value = null;
      }
    });
  }

  voteItemClicked(int option, String challengeId) {
    if (votedFor.value == -1) {
      incrementVotes(option);
      votedFor.value = option;
    } else if (votedFor.value == option) {
      decrementVotes(option);
      votedFor.value = -1;
    } else {
      incrementVotes(option);
      decrementVotes(votedFor.value);
      votedFor.value = option;
    }
  }

  incrementVotes(int option) {
    currentVotesTotal.value = currentVotesTotal.value + 1;
    currentVotes[option]++;
  }

  decrementVotes(int option) {
    currentVotesTotal.value = currentVotesTotal.value - 1;
    currentVotes[option]--;
  }

  Future<Resource<Map<String, dynamic>>> updateVotedData(
      String challengeId, int option, User user, int initVote) async {
    if (option == -1 && initVote == -1) {
      return Success({});
    } else if (option == -1 && initVote != -1) {
      final res = await _repo.removeChallengeVote(
          challengeId, user, initVote);
      return res;
    }
    log("updating challenges{id : $challengeId }", name: "CHALLENGES");
    if(option==initVote) return Failure("You have voted the same option");
    final res = await _repo.voteForOptions(challengeId, user, initVote, option);
    // if (opt == VoteType.FOR.index) {
    //   res = await _repo.voteForChallenge(challengeId, user, initVoteType == -1);
    // } else {
    //   res = await _repo.voteAgainstChallenge(
    //       challengeId, user, initVoteType == -1);
    // }
    return res;
  }
}
