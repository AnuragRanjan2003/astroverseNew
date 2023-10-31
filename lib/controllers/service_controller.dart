import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:astroverse/models/service.dart';
import 'package:astroverse/repo/service_repo.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

const tag = "SERVICE";

class ServiceController extends GetxController {
  final _repo = ServiceRepo();

  RxList<Service> serviceList = <Service>[].obs;
  Rx<bool> morePostsToLoad = true.obs;
  Rxn<QueryDocumentSnapshot<Service>> lastPost = Rxn();
  static const _maxPostLimit = 50;
  Rx<bool> nothingToShow = false.obs;
  Rx<bool> loadingMorePosts = false.obs;
  Rxn<XFile> image = Rxn();
  final _imagePicker = ImagePicker();
  Rx<int> selectedItem = 0.obs;
  Rx<double> price = 0.00.obs;
  Rx<bool> formValid = false.obs;
  Rx<int> selectedChip = Rx(-1);
  Rx<int> loading = 0.obs;

  selectImage() async {
    final img = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    image.value = img;
  }

  postService(Service s) {
    final id = const Uuid().v4();
    s.id = id;
    loading.value = 1;
    if (image.value == null) {
      s.imageUrl = BackEndStrings.defaultServiceImage;
      _repo.saveService(s, id).then((value) {
        loading.value = 0;
        if (value.isSuccess) {
          log('service posted', name: tag);
        } else {
          value = value as Failure<Service>;
          log('failed ${value.error}', name: tag);
        }
      });
      return;
    }
    final file = File(image.value!.path);
    _repo.storeServiceImage(file, id).then((value) {
      log(image.value!.path, name: 'FILE');
      if (value.isSuccess) {
        s.imageUrl = (value as Success<String>).data;
        _repo.saveService(s, id).then((value) {
          loading.value = 0;

          if (value.isSuccess) {
            log('service posted', name: tag);
          } else {
            value = value as Failure<Service>;
            log('failed ${value.error}', name: tag);
          }
        });
      } else {
        loading.value = 0;
        Get.snackbar('Error', (value as Failure<String>).error);
      }
    });
  }

  clearList() {
    serviceList.clear();
    lastPost.value = null;
    morePostsToLoad.value = true;
  }

  fetchMoreServices(String uid, List<String> genre,
      Function(List<Service>) onFetch) {
    log("loading more posts", name: "POST LIST");
    if (morePostsToLoad.value == false || serviceList.length >= _maxPostLimit) {
      return;
    }
    loadingMorePosts.value = true;
    _repo.fetchMorePost(lastPost.value!, genre, uid).then((value) {
      loadingMorePosts.value = false;
      if (value.isSuccess) {
        value = value as Success<List<QueryDocumentSnapshot<Service>>>;
        List<Service> list = [];
        for (var s in value.data) {
          if (s.exists) {
            list.add(s.data());
            lastPost.value = s;
          }
        }
        log("${lastPost.value!.data()}", name: "IS NULL");
        log(list.length.toString(), name: "GOT LIST SIZE");
        log(list.toString(), name: "GOT LIST");
        serviceList.addAll(list);
        morePostsToLoad.value = list.isNotEmpty;
        onFetch(list);
        log(serviceList.length.toString(), name: "POST LIST SUCCESS");
      } else {
        value = value as Failure<List<QueryDocumentSnapshot<Service>>>;
        log(value.error, name: tag);
      }
    });
  }

  void fetchServiceByGenreAndPage(List<String> genre, String uid,
      Function(List<Service>) onFetch) {
    log("loading  posts", name: "POST LIST");
    if (lastPost.value == null) {
      log("null", name: "LP");
    } else {
      log(lastPost.value!.data().toString(), name: "LP");
      return;
    }
    loadingMorePosts.value = true;
    _repo.fetchPostsByGenreAndPage(genre, uid).then((value) {
      loadingMorePosts.value = false;
      if (value.isSuccess) {
        value = value as Success<List<QueryDocumentSnapshot<Service>>>;
        List<Service> list = [];
        for (var element in value.data) {
          if (element.exists) {
            list.add(element.data());
            lastPost.value = element;
          }
        }
        //log("${lastPost.value!.data()}", name: "IS NULL");
        log(list.length.toString(), name: "GOT SERVICE LIST");
        log(list.toString(), name: "GOT SERVICE LIST");
        serviceList.value = list;
        nothingToShow.value = list.isEmpty;
        onFetch(list);
        log(serviceList.length.toString(), name: "SERVICE LIST SUCCESS");
      } else {
        value = value as Failure<List<QueryDocumentSnapshot<Service>>>;
        log(value.error, name: "SERVICE LIST FAILED");
      }
    });
  }

  Future<void> onRefresh(List<String> genre, String uid,
      Function(List<Service>) onFetch) async {
    clearList();
    log("loading  posts", name: "POST LIST");
    if (lastPost.value == null) {
      log("null", name: "LP");
    } else {
      log(lastPost.value!.data().toString(), name: "LP");
      return;
    }
    var value = await _repo.fetchPostsByGenreAndPage(genre, uid);
    if (value.isSuccess) {
      value = value as Success<List<QueryDocumentSnapshot<Service>>>;
      List<Service> list = [];
      for (var element in value.data) {
        if (element.exists) {
          list.add(element.data());
          lastPost.value = element;
        }
      }
      //log("${lastPost.value!.data()}", name: "IS NULL");
      log(list.length.toString(), name: "GOT SERVICE LIST");
      log(list.toString(), name: "GOT SERVICE LIST");
      serviceList.value = list;
      nothingToShow.value = list.isEmpty;
      onFetch(list);
      log(serviceList.length.toString(), name: "SERVICE LIST SUCCESS");
    } else {
      value = value as Failure<List<QueryDocumentSnapshot<Service>>>;
      log(value.error, name: "SERVICE LIST FAILED");
    }
  }

  Future<void> makePayment(Service item, Function(String) onError) async {
    try {
      final body = {
        'amount': "${(item.price * 100).toInt()}",
        'currency': 'INR'
      };

      final res = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${dotenv.env["SECRETKEY"]}',
            'Content-type': 'application/x-www-form-urlencoded'
          });
      final Map<String, dynamic> intent = jsonDecode(res.body.toString());

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: intent["client_secret"],
            merchantDisplayName: 'Astroverse',
            googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'GB' , testEnv: true)
          ));
      try {
         await Stripe.instance
            .presentPaymentSheet(options: const PaymentSheetPresentOptions()).then((value) {});

         //final item = Transaction(Uuid().v4(), uid, date, itemId, itemType, amount, method)
         //_repo.addTransaction(item);
        
      } on StripeException catch (e) {
        onError(e.toString());
      } on StripeConfigException catch (e) {
        onError(e.message);
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
