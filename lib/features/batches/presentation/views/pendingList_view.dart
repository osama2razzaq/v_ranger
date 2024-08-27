import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_strings.dart';
import 'package:v_ranger/features/Survey/presentation/views/survey_details_view.dart';

import 'package:v_ranger/features/batches/presentation/controllers/bataches_file_list_Controller.dart';

class PendingList extends StatelessWidget with SnackBarHelper {
  final BatachesFileListController controller;

  PendingList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.data.value == null) {
        return const Center(
            child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ));
      } else if (controller.data.value!.data!.pendingDetails!.isEmpty) {
        return const Center(child: Text('No pending batches'));
      } else {
        var pendingList = controller.data.value!.data!.pendingDetails;

        var reversedPendingList = controller.isReversed.value == true
            ? pendingList!.reversed.toList()
            : pendingList;

        return Column(
          children: [
            // "All Select" option at the top of the list
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: AppColors.colorWhite,
                          activeColor: AppColors.primaryColor,
                          value: controller.isAllSelected(),
                          onChanged: (value) {
                            controller.toggleAllSelection();
                          },
                        ),
                        Text(
                          controller.isAllSelected()
                              ? 'Deselect All'
                              : 'Select All',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      controller.toggleAllSelection();
                    },
                  ),
                  controller.selectedBatchIds.isEmpty
                      ? Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Row(
                            children: [
                              const Text(
                                'Sort by Distance',
                                style: TextStyle(
                                  fontFamily: AppStrings.fontFamilyPrompt,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                  fontSize: 14,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                    color: AppColors.black,
                                    controller.isReversed.value
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward),
                                onPressed: () {
                                  // Toggle the sorting order

                                  controller.isReversed.value =
                                      !controller.isReversed.value;
                                  // Sort the data based on the current order
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 40,
                          width: 120,
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: SingleButton(
                              bgColor: AppColors.primaryColor,
                              buttonName: 'Next',
                              onTap: () => {
                                    print(controller.selectedBatchIds),
                                    Get.to(() => SurveyDetailsPage(
                                        controller: controller,
                                        index: 1,
                                        isEdit: false,
                                        isBulkUpdate: true))
                                  } // controller.login, //{Get.offAllNamed(Routes.dashboard)},
                              ),
                        )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: reversedPendingList!.length,
                itemBuilder: (context, index) {
                  final batch = reversedPendingList[index];
                  final isSelected =
                      controller.selectedBatchIds.contains(batch.id);
                  print("isSelected == ${isSelected}");
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Slidable(
                      key: Key(batch.toString()),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(10)),
                            onPressed: (context) {
                              controller.updateBatchPin(
                                controller.data.value!.data!
                                    .pendingDetails![index].batchId
                                    .toString(),
                                controller
                                    .data.value!.data!.pendingDetails![index].id
                                    .toString(),
                                batch.pinnedAt == null ? 'pin' : 'unpin',
                              );
                            },
                            backgroundColor: AppColors.yellow,
                            foregroundColor: Colors.white,
                            icon: Icons.push_pin,
                            label: batch.pinnedAt == null ? 'Pin' : 'Unpin',
                          ),
                          SlidableAction(
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(10)),
                            onPressed: (context) {
                              controller.updateBatchPin(
                                controller.data.value!.data!
                                    .pendingDetails![index].batchId
                                    .toString(),
                                controller
                                    .data.value!.data!.pendingDetails![index].id
                                    .toString(),
                                'abort',
                              );
                            },
                            backgroundColor: AppColors.red,
                            foregroundColor: AppColors.colorWhite,
                            icon: Icons.cancel,
                            label: 'Abort',
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onLongPress: () {
                          controller.toggleBatchSelection(batch.id!);
                        },
                        onTap: () {
                          if (isSelected) {
                            showErrorSnackBar(
                                "Please proceed with the next button.");
                          } else {
                            Get.to(() => SurveyDetailsPage(
                                controller: controller,
                                index: index,
                                isEdit: false,
                                isBulkUpdate: false));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.yellow
                                : AppColors.scoreBgColor2,
                            border: Border.all(
                                width: 2, color: AppColors.boaderColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 50,
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      batch.id.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.scoreHeader,
                                      ),
                                    ),
                                    Text(
                                      batch.name.toString(),
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? AppColors.scoreBgColor2
                                            : AppColors.yellow,
                                      ),
                                    ),
                                    Text(
                                      batch.distance == ""
                                          ? "Distance : .."
                                          : "Distance : ${batch.distance.toStringAsFixed(2)} KM",
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.grey200),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      child: Text(
                                        maxLines: 3,
                                        batch.address!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  // Add a tick mark when selected
                                  isSelected
                                      ? const Icon(Icons.check_circle,
                                          size: 20,
                                          color: AppColors.primaryColor)
                                      : Container(),
                                  const SizedBox(width: 10),
                                  batch.pinnedAt == null
                                      ? Container()
                                      : const Icon(Icons.push_pin,
                                          size: 20, color: AppColors.yellow),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 16, color: AppColors.scoreHeader),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    });
  }
}
