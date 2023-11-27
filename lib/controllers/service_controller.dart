import 'dart:developer';
import 'dart:io';

import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/models/transaction.dart' as t;
import 'package:astroverse/models/user.dart';
import 'package:astroverse/repo/service_repo.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/env_vars.dart';
import 'package:astroverse/utils/geo.dart';
import 'package:astroverse/utils/razor_pay_utils.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

const tag = "SERVICE";

typedef Json = Map<String, dynamic>;

class ServiceController extends GetxController {
  final _repo = ServiceRepo();

  RxList<Service> serviceList = <Service>[].obs;
  Rx<bool> morePostsToLoad = true.obs;
  Rxn<QueryDocumentSnapshot<Service>> lastPostForLocality = Rxn();
  Rxn<QueryDocumentSnapshot<Service>> lastPostForCity = Rxn();
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
  RxString searchText = "".obs;
  RxBool paymentLoading = false.obs;
  RxDouble imageSize = 0.45.obs;
  Rxn<String> serviceProvider = Rxn();

  final searchController = TextEditingController(text: "");

  final razorPayUtils = RazorPayUtils();

  final _razorPay = Razorpay();

  void _handlePaymentSuccess(
      PaymentSuccessResponse response, User user, Service item) async {
    paymentLoading.value = false;
    log("success", name: "RAZOR");
    log(item.toString(), name: "RAZOR ITEM");
    final trans = t.Transaction(response.paymentId.toString(), user.uid,
        DateTime.now(), item.id, item.genre[0], item.price, response.orderId!);
    final res = await _repo.addTransaction(trans);
    final purchase = Purchase(
        itemId: item.id,
        purchaseId: response.orderId.toString(),
        paymentId: response.paymentId.toString(),
        itemName: item.title,
        itemImage: item.imageUrl,
        itemPrice: item.price.toString(),
        totalPrice: _computeFinalPrice(item.price).toString(),
        buyerId: user.uid,
        buyerName: user.name,
        sellerId: item.authorId,
        sellerName: item.authorName,
        boughtOn: DateTime.now(),
        delivered: false,
        review: null,
        deliveredOn: null);
    final res1 = await _repo.postPurchase(purchase);
    final res2 = await _repo.updateService(
        {"lastDate": FieldValue.serverTimestamp()}, item.id, item.authorId);

    if (res is Success<void> && res1.isSuccess && res2.isSuccess) {
      log("transaction recorder", name: "TRANSACTION");
      log("purchase recorder", name: "PURCHASE");
    } else {
      try {
        res as Failure<void>;
        log("error", name: "TRANSACTION");
      } on TypeError catch (e) {
        log(e.toString(), name: "TRANSACTION");
      }
      try {
        res1 as Failure<Purchase>;
        log(res1.error, name: "PURCHASE");
      } on TypeError catch (e) {
        log(e.toString(), name: "TRANSACTION");
      }

      try {
        res2 as Failure<Json>;
        log(res2.error, name: "UPDATE SERVICE");
      } on TypeError catch (e) {
        log(e.toString(), name: "TRANSACTION");
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    paymentLoading.value = false;
    log("fail", name: "RAZOR");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    paymentLoading.value = false;
    log("wallet", name: "RAZOR");
  }

  @override
  void onClose() {
    _razorPay.clear();
  }

  attachPaymentEventListeners(User user, Service item) {
    log(item.toString(), name: "ITEM GOT");
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (p0) => _handlePaymentSuccess(p0, user, item));
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<Resource<Json>> callOrderApi(Service item) async {
    final key = dotenv.get(EnvVars.razorPayKey);
    final secret = dotenv.get(EnvVars.razorPaySecret);
    final order = RazorPayUtils.createOrderBody(item.price.toInt(), 'INR');
    final header = RazorPayUtils.createOrderAuthorizationHeader(key, secret);
    return await razorPayUtils.createOrder(header, order);
  }

  void openGateWay(Json options) {
    _razorPay.open(options);
  }

  void makePayment(Service item, String phNo, String email) async {
    paymentLoading.value = true;
    final key = dotenv.get(EnvVars.razorPayKey);
    final response = await callOrderApi(item);
    if (response.isSuccess) {
      response as Success<Json>;
      final orderId = response.data["id"];
      final options = RazorPayUtils.createOptions(
          key, orderId, (item.price * 100).toInt(), 'buying item', phNo, email);
      openGateWay(options);
    } else {
      paymentLoading.value = false;
      response as Failure<Json>;
      Get.snackbar('fail', response.error);
    }
  }

  selectImage() async {
    final img = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    image.value = img;
  }

  fetchProviderDetails(String providerUid) {
    log("fetching provider" , name:"PROVIDER");
    serviceProvider.value = null;
    _repo.fetchProviderData(providerUid).then((value) {
      if (value.isSuccess) {
        value = value as Success<DocumentSnapshot<User>>;
        log("${value.data.data()}" , name:"PROVIDER INFO");
        if(value.data.data()!=null) {
          serviceProvider.value = BackEndStrings.providerFound;
        }else{
          serviceProvider.value = BackEndStrings.providerNotFound;
        }
      }
      log(serviceProvider.value.toString() , name:"PROVIDER");
    });
  }

  postService(Service s, Function() updateUI) {
    final id = const Uuid().v4();
    s.id = id;
    loading.value = 1;
    if (image.value == null) {
      s.imageUrl = BackEndStrings.defaultServiceImage;
      _repo.saveService(s, id).then((value) {
        loading.value = 0;
        updateUI();
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
          updateUI();
          if (value.isSuccess) {
            log('service posted', name: tag);
            updateUI();
          } else {
            value = value as Failure<Service>;
            log('failed ${value.error}', name: tag);
            updateUI();
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
    lastPostForLocality.value = null;
    lastPostForCity.value = null;
    morePostsToLoad.value = true;
  }

  fetchMoreServices(
      String uid, List<String> genre, Function(List<Service>) onFetch) {
    log("loading more posts", name: "POST LIST");
    if (morePostsToLoad.value == false || serviceList.length >= _maxPostLimit) {
      return;
    }
    loadingMorePosts.value = true;
    if (lastPostForLocality.value == null && lastPostForCity.value == null) {
      fetchServiceByGenreAndPage(genre, uid, (p0) {
        onFetch(p0);
      });
    } else {
      _repo.fetchMorePost(lastPostForCity.value!, genre, uid).then((value) {
        loadingMorePosts.value = false;
        if (value.isSuccess) {
          value = value as Success<List<QueryDocumentSnapshot<Service>>>;
          List<Service> list = [];
          for (var s in value.data) {
            if (s.exists) {
              list.add(s.data());
              if (s.data().range == Ranges.locality)
                lastPostForLocality.value = s;
              if (s.data().range == Ranges.city) lastPostForCity.value = s;
            }
          }
          log("${lastPostForLocality.value!.data()}", name: "IS NULL");
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
  }

  fetchMoreServicesByLocation(
      String uid, GeoPoint userLocation, Function(List<Service>) onFetch) {
    log("loading more posts", name: "POST LIST");
    if (morePostsToLoad.value == false || serviceList.length >= _maxPostLimit) {
      return;
    }
    loadingMorePosts.value = true;
    if (lastPostForLocality.value == null && lastPostForCity.value == null) {
      fetchServiceByLocation(uid, (p0) {
        onFetch(p0);
      }, userLocation);
    } else {
      _repo
          .fetchMoreByLocation(
        uid,
        userLocation,
        lastPostForLocality.value,
        lastPostForCity.value,
      )
          .then((value) {
        loadingMorePosts.value = false;
        if (value.isSuccess) {
          value = value as Success<List<QueryDocumentSnapshot<Service>>>;
          List<Service> list = [];
          for (var s in value.data) {
            if (s.exists) {
              list.add(s.data());
              if (s.data().range == Ranges.locality)
                lastPostForLocality.value = s;
              if (s.data().range == Ranges.city) lastPostForCity.value = s;
            }
          }
          log("${lastPostForLocality.value!.data()}", name: "IS NULL");
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
  }

  void fetchServiceByLocation(
      String uid, Function(List<Service>) onFetch, GeoPoint userLocation) {
    log("loading  posts", name: "POST LIST");
    if (lastPostForLocality.value == null || lastPostForCity.value == null) {
      log("null", name: "LP");
    } else {
      log(lastPostForLocality.value!.data().toString(), name: "LP");
      return;
    }
    loadingMorePosts.value = true;
    _repo.fetchByLocation(uid, userLocation).then((value) {
      loadingMorePosts.value = false;
      if (value.isSuccess) {
        value = value as Success<List<QueryDocumentSnapshot<Service>>>;
        List<Service> list = [];
        for (var element in value.data) {
          if (element.exists) {
            if (element.data().authorId != uid) list.add(element.data());
            if (element.data().range == Ranges.locality) {
              lastPostForLocality.value = element;
            }
            if (element.data().range == Ranges.city)
              lastPostForCity.value = element;
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

  void fetchServiceByGenreAndPage(
      List<String> genre, String uid, Function(List<Service>) onFetch) {
    log("loading  posts", name: "POST LIST");
    if (lastPostForLocality.value == null) {
      log("null", name: "LP");
    } else {
      log(lastPostForLocality.value!.data().toString(), name: "LP");
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
            lastPostForLocality.value = element;
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

  Future<void> onRefresh(String uid, Function(List<Service>) onFetch,
      GeoPoint userLocation) async {
    clearList();
    log("loading  posts", name: "POST LIST");
    if (lastPostForLocality.value == null && lastPostForCity.value == null) {
      log("null", name: "LP");
    } else {
      log(lastPostForLocality.value!.data().toString(), name: "LP");
      return;
    }
    var value = await _repo.fetchByLocation(uid, userLocation);
    if (value.isSuccess) {
      value = value as Success<List<QueryDocumentSnapshot<Service>>>;
      List<Service> list = [];
      for (var element in value.data) {
        if (element.exists && element.data().authorId != uid) {
          list.add(element.data());
          lastPostForLocality.value = element;
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

  static double _computeFinalPrice(double price) {
    return price;
  }
}
