import 'package:astroverse/utils/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SafeCall {
  Future<Resource<T>> authCall<T>(Future<T?> Function() task) async {
    try {
      var res = await task();
      if (res != null) return Success(res);
      return Failure("returned null");
    } on FirebaseAuthException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Resource<T>> fireStoreCall<T>(Future<T?> Function() task ) async {
    try {
      var res = await task();
      if (res != null) return Success(res);
      return Failure("returned null");
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }


}
