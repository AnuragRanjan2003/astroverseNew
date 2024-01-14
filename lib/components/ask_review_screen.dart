import 'package:astroverse/controllers/order_controller.dart';
import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskReviewBottomSheet extends StatefulWidget {
  final Purchase purchase;

  const AskReviewBottomSheet({super.key, required this.purchase});

  @override
  State<AskReviewBottomSheet> createState() => _AskReviewScreen();
}

class _AskReviewScreen extends State<AskReviewBottomSheet> {
  late int starsSelected;
  late bool dismiss;
  late OrderController order;
  late bool postingReview;

  late bool reviewPosted;

  @override
  void initState() {
    starsSelected = 0;
    dismiss = false;
    postingReview = false;
    reviewPosted = false;
    order = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !dismiss,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: postingReview
              ? const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: ProjectColors.primary,
                  ),
                )
              : IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Please Review",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "please take a moment to share your experience with a quick review? Your feedback means a lot to us!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                              5,
                              (index) => IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (starsSelected == index + 1) {
                                        starsSelected = 0;
                                      } else {
                                        starsSelected = index + 1;
                                      }
                                    });
                                  },
                                  icon: (index < starsSelected)
                                      ? const Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                        )
                                      : const Icon(Icons.star_border)))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton(
                              onPressed: starsSelected == 0
                                  ? null
                                  : () {
                                      postingReview = true;
                                      reviewPosted = false;
                                      order.postReview(
                                          starsSelected,
                                          widget.purchase.purchaseId,
                                          widget.purchase.itemId,
                                          widget.purchase.buyerId,
                                          widget.purchase.sellerId, (p0) {
                                        if (p0.isSuccess) {
                                          setState(() {
                                            postingReview = false;
                                            dismiss = true;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text("review posted")));
                                        } else {
                                          setState(() {
                                            postingReview = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "some error occurred")));
                                        }
                                      });
                                    },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      starsSelected == 0
                                          ? ProjectColors.disabled
                                          : ProjectColors.primary)),
                              child: const Text(
                                "Done",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  dismiss = true;
                                });
                              },
                              child: const Text("Next Time")),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
