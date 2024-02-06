import 'package:astroverse/db/db.dart';
import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/utils/resource.dart';

class ChallengeRepo {
  final _db = Database();

  Future<Resource<List<Challenge>>> getChallenges() => _db.fetchChallenges();

  Future<Resource<Json>> voteForChallenge(String challengeId, User user) =>
      _db.addVoteInChallenge(challengeId, user, false);

  Future<Resource<Challenge>> getChallengeById(String id) =>
      _db.fetchChallengeById(id);

  Future<Resource<Json>> voteAgainstChallenge(String challengeId, User user) =>
      _db.addVoteInChallenge(challengeId, user, true);
}
