import 'package:astroverse/components/upgrade_features_bottom_sheet.dart';
import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeUtils {
  final CollectionReference<Challenge> _challengeCollection = FirebaseFirestore
      .instance
      .collection(BackEndStrings.challengesCollection)
      .withConverter<Challenge>(
        fromFirestore: (snapshot, options) =>
            Challenge.fromJson(snapshot.data()),
        toFirestore: (value, options) => value.toJson(),
      );

  Future<Resource<List<Challenge>>> getChallenges() async {
    try {
      final data = await _challengeCollection
          .where("status", isEqualTo: "active")
          .orderBy("totalVotes", descending: true)
          .limit(5)
          .get();
      final list = <Challenge>[];
      for (var it in data.docs) {
        if (it.exists) list.add(it.data());
      }
      return Success(list);
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Resource<Challenge>> getChallengeById(String id) async {
    try {
      final data = await _challengeCollection.doc(id).get();
      if (data.exists && data.data() != null) {
        return Success(data.data()!);
      }
      return Failure("challenge not found");
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Resource<Json>> addVoteInChallenge(
      String challengeId, User user, bool isAgainst) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      batch.update(_challengeCollection.doc(challengeId), {
        'totalVotes': FieldValue.increment(1),
        'votesFor': FieldValue.increment(1),
      });

      final voter = {
        'uid': user.uid,
        'name': user.name,
        'time': Timestamp.now()
      };

      batch.update(
          _challengeCollection
              .doc(challengeId)
              .collection(isAgainst ? "againstChallenge" : "forChallenge")
              .doc(user.uid),
          voter);

      await batch.commit();

      return Success(voter);
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
