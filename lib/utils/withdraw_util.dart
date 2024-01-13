import 'package:astroverse/models/withdraw_request.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawUtils {
  final CollectionReference<WithdrawRequest> _withdrawCollection =
      FirebaseFirestore.instance
          .collection(BackEndStrings.withdrawCollection)
          .withConverter<WithdrawRequest>(
            fromFirestore: (snapshot, options) =>
                WithdrawRequest.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<Resource<WithdrawRequest>> addRequest(WithdrawRequest request) async {
    try {
      await _withdrawCollection.doc(request.requestId).set(request);
      return Success(request);
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Resource<Map<String, dynamic>>> updateRequest(
      Map<String, dynamic> data, String requestId) async {
    try {
      await _withdrawCollection.doc(requestId).update(data);
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
