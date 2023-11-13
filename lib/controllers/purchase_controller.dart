import 'dart:developer';

import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/repo/purchase_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {
  final PurchaseRepo _repo = PurchaseRepo();

  RxList<Purchase> purchaseList = <Purchase>[].obs;
  RxList<Purchase> soldList = <Purchase>[].obs;
  Rx<bool> morePostsToLoad = true.obs;
  Rx<bool> morePostsToLoadForSold = true.obs;
  Rxn<QueryDocumentSnapshot<Purchase>> lastPost = Rxn();
  Rxn<QueryDocumentSnapshot<Purchase>> lastPostForSold = Rxn();
  static const _maxPostLimit = 50;
  Rx<bool> nothingToShow = false.obs;
  Rx<bool> nothingToShowForSold = false.obs;
  Rx<bool> loadingMorePosts = false.obs;
  Rx<bool> loadingMorePostsForSold = false.obs;
  RxString searchText = "".obs;
  RxString searchTextForSold = "".obs;
  final searchController = TextEditingController(text: "");
  final searchControllerForSold = TextEditingController(text: "");

  void fetchPurchases(String buyerId) {
    loadingMorePosts.value = true;
    _repo.fetchPurchases(buyerId).then((value) {
      loadingMorePosts.value = false;
      if (value.isSuccess) {
        value as Success<List<QueryDocumentSnapshot<Purchase>>>;

        final list = <Purchase>[];
        for (var it in value.data) {
          list.add(it.data());
          lastPost.value = it;
        }
        purchaseList.value = list;
        nothingToShow.value = list.isEmpty;
        log(list.toString(), name: "PURCH");
      } else {
        value = value as Failure<List<QueryDocumentSnapshot<Purchase>>>;
        log(value.error, name: "PURCH");
      }
    });
  }

  void fetchSoldItems(String sellerId) {
    loadingMorePostsForSold.value = true;
    _repo.fetchSoldItems(sellerId).then((value) {
      loadingMorePostsForSold.value = false;
      if (value.isSuccess) {
        value as Success<List<QueryDocumentSnapshot<Purchase>>>;

        final list = <Purchase>[];
        for (var it in value.data) {
          list.add(it.data());
          lastPostForSold.value = it;
        }
        soldList.value = list;
        nothingToShowForSold.value = list.isEmpty;
        log(list.toString(), name: "SOLD");
      } else {
        value = value as Failure<List<QueryDocumentSnapshot<Purchase>>>;
        log(value.error, name: "SOLD");
      }
    });
  }

  void fetchMorePurchases(String buyerId) {
    log("loading more posts", name: "POST LIST");
    if (morePostsToLoad.value == false ||
        purchaseList.length >= _maxPostLimit) {
      return;
    }
    loadingMorePosts.value = true;
    if (lastPost.value == null) {
      fetchPurchases(
        buyerId,
      );
    } else {
      _repo.fetchMorePurchases(lastPost.value!, buyerId).then((value) {
        loadingMorePosts.value = false;
        if (value.isSuccess) {
          value = value as Success<List<QueryDocumentSnapshot<Purchase>>>;
          List<Purchase> list = [];
          for (var s in value.data) {
            if (s.exists) {
              list.add(s.data());
              lastPost.value = s;
            }
          }
          log("${lastPost.value!.data()}", name: "IS NULL");
          log(list.length.toString(), name: "GOT LIST SIZE");
          log(list.toString(), name: "GOT LIST");
          purchaseList.addAll(list);
          morePostsToLoad.value = list.isNotEmpty;
        } else {
          value = value as Failure<List<QueryDocumentSnapshot<Purchase>>>;
        }
      });
    }
  }

  void fetchMoreSoldItems(String sellerId) {
    log("loading more posts", name: "SOLD LIST");
    if (morePostsToLoadForSold.value == false ||
        soldList.length >= _maxPostLimit) {
      return;
    }
    loadingMorePostsForSold.value = true;
    if (lastPostForSold.value == null) {
      fetchPurchases(
        sellerId,
      );
    } else {
      _repo.fetchMorePurchases(lastPost.value!, sellerId).then((value) {
        loadingMorePostsForSold.value = false;
        if (value.isSuccess) {
          value = value as Success<List<QueryDocumentSnapshot<Purchase>>>;
          List<Purchase> list = [];
          for (var s in value.data) {
            if (s.exists) {
              list.add(s.data());
              lastPostForSold.value = s;
            }
          }
          log("${lastPostForSold.value!.data()}", name: "IS NULL");
          log(list.length.toString(), name: "GOT LIST SIZE");
          log(list.toString(), name: "GOT LIST");
          soldList.addAll(list);
          morePostsToLoadForSold.value = list.isNotEmpty;
        } else {
          value = value as Failure<List<QueryDocumentSnapshot<Purchase>>>;
        }
      });
    }
  }

  postPurchase(Purchase p) {
    _repo.postPurchase(p).then((value) {
      log("posted", name: "SOLD");
    });
  }
}
