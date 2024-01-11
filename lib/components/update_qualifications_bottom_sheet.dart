import 'package:astroverse/models/qualifications.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';

import '../controllers/service_controller.dart';

class UpdateQualificationsBottomSheet extends StatefulWidget {
  final String previousQualifications;
  final void Function(Qualification) onUpdate;

  const UpdateQualificationsBottomSheet(
      {super.key,
      required this.previousQualifications,
      required this.onUpdate});

  @override
  State<UpdateQualificationsBottomSheet> createState() =>
      _UpdateQualificationsBottomSheetState();
}

class _UpdateQualificationsBottomSheetState
    extends State<UpdateQualificationsBottomSheet> {
  late TextEditingController qualification;
  late String error;

  @override
  void initState() {
    super.initState();
    error = "";
    qualification = TextEditingController(text: widget.previousQualifications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Update Qualifications",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: qualification,
                maxLength: 300,
                maxLines: 10,
                decoration: InputDecoration(
                    errorText: error.isEmpty ? null : error,
                    border: const OutlineInputBorder(),
                    hintText: "Enter your qualifications",
                    helperStyle:
                        const TextStyle(color: ProjectColors.disabled)),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  if (qualification.value.text.isEmpty) {
                    setState(() {
                      error = "Qualifications Empty";
                    });
                    return;
                  }
                  if (qualification.value.text ==
                      widget.previousQualifications) {
                    setState(() {
                      error = "Qualifications Unchanged";
                    });
                    return;
                  }

                  widget.onUpdate(Qualification(qualification.value.text));

                },
                padding: const EdgeInsets.symmetric(vertical: 10),
                disabledColor: ProjectColors.disabled,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: ProjectColors.primary,
                child: const Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
