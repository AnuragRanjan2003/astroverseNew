import 'package:astroverse/db/db.dart';
import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/models/voter.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/vote_type_enum.dart';

class ChallengeRepo {
  final _db = Database();

  Future<Resource<List<Challenge>>> getChallenges() => _db.fetchChallenges();



  Future<Resource<Challenge>> getChallengeById(String id) =>
      _db.fetchChallengeById(id);

  Future<Resource<Voter>> getVoterById(String challengeId, String uid) =>
      _db.findVoterById(challengeId, uid);

  Future<Resource<Json>> removeChallengeVote(
          String challengeId, User user, int prevVote) =>
      _db.addVoteInChallenge(
          challengeId, user, 0, false, true, prevVote);



  Future<Resource<Json>> voteForOptions(String challengeId, User user, int prevVote , int option) =>
      _db.addVoteInChallenge(
          challengeId, user, option, prevVote==-1, false, prevVote);


}
