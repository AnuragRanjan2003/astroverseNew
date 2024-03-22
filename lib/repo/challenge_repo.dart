import 'package:astroverse/db/db.dart';
import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/models/voter.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/vote_type_enum.dart';

class ChallengeRepo {
  final _db = Database();

  Future<Resource<List<Challenge>>> getChallenges() => _db.fetchChallenges();

  Future<Resource<Json>> voteForChallenge(
          String challengeId, User user, bool isFirstTime) =>
      _db.addVoteInChallenge(challengeId, user, false, isFirstTime , false ,-1);

  Future<Resource<Challenge>> getChallengeById(String id) =>
      _db.fetchChallengeById(id);

  Future<Resource<Voter>> getVoterById(String challengeId, String uid) =>
      _db.findVoterById(challengeId, uid);

  Future<Resource<Json>> removeChallengeVote(
          String challengeId, User user, VoteType prevVote) =>
      _db.addVoteInChallenge(
          challengeId, user, false, false, true, prevVote.index);

  Future<Resource<Json>> voteAgainstChallenge(String challengeId, User user,
          bool isFirstTime) =>
      _db.addVoteInChallenge(challengeId, user, true, isFirstTime, false, -1);
}
