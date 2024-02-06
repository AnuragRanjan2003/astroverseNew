import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:astroverse/models/deleted_service.dart';
import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/models/transaction.dart' as t;
import 'package:astroverse/models/transaction.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/repo/service_repo.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/constants.dart';
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
import 'package:shortid/shortid.dart';

const tag = "SERVICE";

typedef Json = Map<String, dynamic>;

class ServiceController extends GetxController {
  final _repo = ServiceRepo();

  RxList<Service> serviceList = <Service>[].obs;
  Rx<bool> morePostsToLoad = true.obs;
  Rxn<QueryDocumentSnapshot<Service>> lastPostForLocality = Rxn();
  Rxn<QueryDocumentSnapshot<Service>> lastPostForCity = Rxn();
  Rxn<QueryDocumentSnapshot<Service>> lastPostForState = Rxn();
  Rxn<QueryDocumentSnapshot<Service>> lastPostForAll = Rxn();
  Rxn<QueryDocumentSnapshot<Service>> lastPostForFeatured = Rxn();
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
  RxInt selectedMode = 1.obs;
  Rxn<String> serviceProvider = Rxn();
  RxDouble selectedRange = 0.0.obs;
  RxList<SaveService> myServices = RxList();
  RxInt currPage = 0.obs;
  RxBool deletingService = false.obs;
  RxBool useCurrentLocation = false.obs;

  final searchController = TextEditingController(text: "");

  final razorPayUtils = RazorPayUtils();

  final _razorPay = Razorpay();

  void _handlePaymentSuccess(
      PaymentSuccessResponse response, User user, Service item) async {
    paymentLoading.value = false;
    log("success", name: "RAZOR");
    log(item.toString(), name: "RAZOR ITEM");
    final trans = t.Transaction(
        response.paymentId.toString(),
        user.uid,
        DateTime.now(),
        item.id,
        item.genre[0],
        item.price,
        response.orderId!,
        TransactionStatus.pending,
        null);
    final res = await _repo.addTransaction(trans);
    final purchase = Purchase(
        itemId: item.id,
        purchaseId: response.paymentId.toString(),
        paymentId: response.paymentId.toString(),
        secretCode: response.orderId.toString(),
        itemName: item.title,
        itemImage: item.imageUrl,
        itemPrice: (math.max(0,item.price - Constants.appConvenienceFee)).toString(),
        totalPrice: item.price.toString(),
        buyerId: user.uid,
        buyerName: user.name,
        sellerId: item.authorId,
        sellerName: item.authorName,
        deliveryMethod: item.deliveryMethod,
        boughtOn: DateTime.now(),
        delivered: false,
        review: null,
        refundId: null,
        active: true,
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

  Future<Resource<Service>> fetchService(String serviceId) =>
      _repo.fetchService(serviceId);

  void deleteService(
      DeletedService ss, String userId, Function(Resource<String>) updateUI) {
    deletingService.value = true;
    _repo.deleteService(ss, userId).then((value) {
      deletingService.value = false;
      updateUI(value);
    });
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

  void makePayment(Service item, String phNo, String email,
      void Function(String) onError) async {
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
      onError(response.error);
    }
  }

  selectImage(void Function(XFile? file) onSelect) async {
    final img = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    image.value = img;
  }

  fetchProviderDetails(String providerUid) {
    log("fetching provider", name: "PROVIDER");
    serviceProvider.value = null;
    _repo.fetchProviderData(providerUid).then((value) {
      if (value.isSuccess) {
        value = value as Success<DocumentSnapshot<User>>;
        log("${value.data.data()}", name: "PROVIDER INFO");
        if (value.data.data() != null) {
          serviceProvider.value = BackEndStrings.providerFound;
        } else {
          serviceProvider.value = BackEndStrings.providerNotFound;
        }
      }
      log(serviceProvider.value.toString(), name: "PROVIDER");
    });
  }

  postService(Service s, int coinCost, Function(Resource<Service>) updateUI) {
    final id = "service_${shortid.generate()}";
    s.id = id;
    s.price = _computeFinalPrice(s.price);
    loading.value = 1;
    if (image.value == null) {
      s.imageUrl = BackEndStrings.defaultServiceImage;
      _repo.saveService(s, id, coinCost).then((value) {
        loading.value = 0;
        updateUI(value);
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
        _repo.saveService(s, id, coinCost).then((value) {
          updateUI(value);
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

  fetchMyServices(String uid) {
    _repo.fetchMyServices(uid).then((value) {
      if (value.isSuccess) {
        value as Success<List<QueryDocumentSnapshot<SaveService>>>;
        log("got services ${value.data}", name: "MY SERVICES");
        myServices.value = value.data.map((e) => e.data()).toList();
      } else {
        value as Failure<List<QueryDocumentSnapshot<SaveService>>>;
        log("error  ${value.error}", name: "MY SERVICES");
      }
    });
  }

  deactivateService(
      String serviceId, String uid, Function(Resource<Json>) updateUi) {
    final data = {'active': false};
    _repo.updateService(data, serviceId, uid).then((value) {
      updateUi(value);
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
              if (s.data().range == Ranges.locality) {
                lastPostForLocality.value = s;
              }
              if (s.data().range == Ranges.city) lastPostForCity.value = s;
              if (s.data().range == Ranges.state) lastPostForState.value = s;
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
    if (lastPostForLocality.value == null &&
        lastPostForCity.value == null &&
        lastPostForState.value != null &&
        lastPostForAll.value != null &&
        lastPostForFeatured.value != null) {
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
        lastPostForState.value,
        lastPostForAll.value,
        lastPostForFeatured.value,
      )
          .then((value) {
        loadingMorePosts.value = false;
        if (value.isSuccess) {
          value = value as Success<List<QueryDocumentSnapshot<Service>>>;
          List<Service> list = [];
          for (var s in value.data) {
            if (s.exists) {
              if (s.data().authorId != uid) list.add(s.data());
              if (s.data().range == Ranges.locality) {
                lastPostForLocality.value = s;
              }
              if (s.data().range == Ranges.city) lastPostForCity.value = s;
              if (s.data().range == Ranges.state) lastPostForState.value = s;
              if (s.data().range == Ranges.all) lastPostForAll.value = s;
              if (s.data().featured) lastPostForFeatured.value = s;
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
        for (var s in value.data) {
          if (s.exists) {
            if (s.data().authorId != uid) list.add(s.data());
            if (s.data().range == Ranges.locality) {
              lastPostForLocality.value = s;
            }
            if (s.data().range == Ranges.city) lastPostForCity.value = s;
            if (s.data().range == Ranges.state) lastPostForState.value = s;
            if (s.data().range == Ranges.all) lastPostForAll.value = s;
            if (s.data().featured) lastPostForFeatured.value = s;
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

  void updateServiceView(String serviceId) {
    final data = {"views": FieldValue.increment(1)};
    _repo.updateService(data, serviceId, 'x').then((value) {
      if (value.isSuccess) {
        log("views updated", name: "SERVICE");
      } else {
        value as Failure<Json>;
        log("views updated failed : ${value.error}", name: "SERVICE");
      }
    });
  }

  static double _computeFinalPrice(double price) {
    return price + Constants.appConvenienceFee;
  }

  void resetServiceCreationValues() {
    price.value = 0.00;
    formValid.value = false;
    image.value = null;
    selectedItem.value = 0;
    selectedRange.value = 0.0;
    selectedMode.value = 0;
    useCurrentLocation.value = false;
  }

  bool hasPostedToday(DateTime lastPosted) {
    final now = DateTime.now();
    return (lastPosted.year == now.year &&
        lastPosted.month == now.month &&
        lastPosted.day == now.day);
  }
}
