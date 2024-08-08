import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/features/Survey/presentation/views/survey_details_view.dart';
import 'package:v_ranger/features/batches/presentation/controllers/bataches_file_list_Controller.dart';

class PendingList extends StatelessWidget {
  final BatachesFileListController controller;

  const PendingList({Key? key, required this.controller}) : super(key: key);

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

        return ListView.builder(
          shrinkWrap: false,
          itemCount: pendingList!.length,
          itemBuilder: (context, index) {
            final batch = pendingList[index];
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
                          controller
                              .data.value!.data!.pendingDetails![index].batchId
                              .toString(),
                          controller.data.value!.data!.pendingDetails![index].id
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
                          controller
                              .data.value!.data!.pendingDetails![index].batchId
                              .toString(),
                          controller.data.value!.data!.pendingDetails![index].id
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
                  onTap: () {
                    Get.to(() => SurveyDetailsPage(
                          controller: controller,
                          index: index,
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.scoreBgColor2,
                      border:
                          Border.all(width: 2, color: AppColors.boaderColor),
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
                                batch.assignedto.toString(),
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.yellow,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.3,
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
                            batch.pinnedAt == null
                                ? Container()
                                : Icon(Icons.push_pin,
                                    size: 20, color: AppColors.yellow),
                            SizedBox(
                                width:
                                    10), // Adjust spacing between icons if needed
                            Icon(Icons.arrow_forward_ios,
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
        );
      }
    });
  }
}
