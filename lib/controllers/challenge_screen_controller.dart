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
  RxInt currentVotesFor = 0.obs;
  RxInt currentVotesAgainst = 0.obs;
  RxInt currentVotesTotal = 0.obs;
  Rxn<Voter> voter = Rxn();

  final ChallengeRepo _repo = ChallengeRepo();

  initVotes(Challenge ch) {
    currentVotesFor.value = ch.votesFor;
    currentVotesAgainst.value = ch.votesAgainst;
    currentVotesTotal.value = ch.totalVotes;
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

  voteItemClicked(VoteType voteType, String challengeId) {
    if (votedFor.value == -1) {
      incrementVotes(voteType);
      votedFor.value = voteType.index;
    } else if (votedFor.value == voteType.index) {
      decrementVotes(voteType);
      votedFor.value = -1;
    } else {
      incrementVotes(voteType);
      decrementVotes(
          voteType == VoteType.FOR ? VoteType.AGAINST : VoteType.FOR);
      votedFor.value = voteType.index;
    }
  }

  incrementVotes(VoteType voteType) {
    currentVotesTotal.value = currentVotesTotal.value + 1;
    switch (voteType) {
      case VoteType.FOR:
        currentVotesFor++;
        break;

      case VoteType.AGAINST:
        currentVotesAgainst++;
        break;
    }
  }

  decrementVotes(VoteType voteType) {
    currentVotesTotal.value = currentVotesTotal.value - 1;
    switch (voteType) {
      case VoteType.FOR:
        currentVotesFor--;
        break;

      case VoteType.AGAINST:
        currentVotesAgainst--;
        break;
    }
  }

  Future<Resource<Map<String, dynamic>>> updateVotedData(
      String challengeId, int votedType, User user, int initVoteType) async {
    if (votedType == -1 && initVoteType==-1) {
      return Success({});
    } else if(votedType==-1 && initVoteType!=-1){
      final res = await _repo.removeChallengeVote(challengeId, user, VoteType.values[initVoteType]);
      return res;
    }
    log("updating challenges{id : $challengeId }", name: "CHALLENGES");
    Resource<Map<String, dynamic>> res;
    if (votedType == VoteType.FOR.index) {
      res = await _repo.voteForChallenge(challengeId, user, initVoteType == -1);
    } else {
      res = await _repo.voteAgainstChallenge(
          challengeId, user, initVoteType == -1);
    }
    return res;
  }
}
