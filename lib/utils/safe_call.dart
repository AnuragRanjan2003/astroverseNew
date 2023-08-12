import 'package:astroverse/utils/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SafeCall {
  Future<Resource<T>> authCall<T>(Future<T?> Function() task) async {
    try {
      var res = await task();
      debugPrint("is res null : ${res==null}");
      if (res == null) return Failure("returned null");
      return Success(res);
    } on FirebaseAuthException catch (e) {
      return Failure("auth :${e.message}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Resource<T>> fireStoreCall<T>(Future<T> Function() task) async {
    try {
      var res = await task();
      return Success(res);
    } on FirebaseException catch (e) {
      return Failure("store:${e.message}");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Resource<T>> storageCall<T>(Future<T?> Function() task) async {
    try {
      var res = await task();
      if (res != null) return Success(res);
      return Failure("storage : returned null");
    } on FirebaseException catch (e) {
      return Failure("storage:${e.message}");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
