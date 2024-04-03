import 'dart:developer';

import 'package:astroverse/components/upgrade_features_bottom_sheet.dart';
import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/models/voter.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/vote_type_enum.dart';
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

  CollectionReference<Voter> _voterCollection(String challengeId) =>
      FirebaseFirestore.instance
          .collection(BackEndStrings.challengesCollection)
          .doc(challengeId)
          .collection(BackEndStrings.votersCollection)
          .withConverter<Voter>(
            fromFirestore: (snapshot, options) =>
                Voter.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<Resource<List<Challenge>>> getChallenges() async {
    try {
      final data = await _challengeCollection
          .where("status", isEqualTo: "active")

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

  Future<Resource<Voter>> findVoterById(
      String challengeId, String voterId) async {
    try {
      final data = await _voterCollection(challengeId).doc(voterId).get();
      if (data.exists && data.data() != null) {
        return Success(data.data()!);
      }
      return Failure("Voter not found");
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Resource<Json>> addVoteInChallenge(String challengeId, User user,
      int option, bool isFirstTime, bool removeAll, int prevVote) async {
    try {

      log("ref : ${_challengeCollection.doc(challengeId).path}",
          name: "CHALLENGE ADD VOTE");

      final voter = {
        'uid': user.uid,
        'name': user.name,
        'type': option,
        'time': Timestamp.now()
      };

      if (!isFirstTime && removeAll) {
        // batch.delete(_voterCollection(challengeId).doc(user.uid));
        // batch.update(_challengeCollection.doc(challengeId), {
        //   'options' : FieldValue.
        // });
        // await batch.commit();
        await FirebaseFirestore.instance.runTransaction((transaction) async{

            final ch = await transaction.get(_challengeCollection.doc(challengeId));

            final list = ch.data()!.optionsVotes;
            list[prevVote] = list[prevVote]-1;

            transaction.delete(_voterCollection(challengeId).doc(user.uid));
            transaction.update(_challengeCollection.doc(challengeId), {
              'optionsVotes' : list
            });


        });
        return Success(voter);
      }
      // if (!isAgainst) {
      //   batch.update(
      //       FirebaseFirestore.instance
      //           .collection(BackEndStrings.challengesCollection)
      //           .doc(challengeId),
      //       {
      //         'votesFor': FieldValue.increment(1),
      //         'votesAgainst': FieldValue.increment(isFirstTime ? 0 : -1)
      //       });
      // } else {
      //   batch.update(
      //       FirebaseFirestore.instance
      //           .collection(BackEndStrings.challengesCollection)
      //           .doc(challengeId),
      //       {
      //         'votesAgainst': FieldValue.increment(1),
      //         'votesFor': FieldValue.increment(isFirstTime ? 0 : -1)
      //       });
      // }

      await FirebaseFirestore.instance.runTransaction((transaction)  async {
        final ch = await transaction.get(_challengeCollection.doc(challengeId));
        final votes = ch.data()!.optionsVotes;
        if(!isFirstTime){
          votes[prevVote]--;
        }
        votes[option]++;
        transaction.update(_challengeCollection.doc(challengeId), {
          'optionsVotes' : votes
        });
        transaction.set(_challengeCollection
            .doc(challengeId)
            .collection(BackEndStrings.votersCollection)
            .doc(user.uid), voter , SetOptions(merge: true));

      });

      // batch.set(
      //     _challengeCollection
      //         .doc(challengeId)
      //         .collection(BackEndStrings.votersCollection)
      //         .doc(user.uid),
      //     voter,
      //     SetOptions(merge: true));

      // await batch.commit();

      return Success(voter);
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
