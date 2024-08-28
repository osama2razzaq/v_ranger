import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/features/Survey/presentation/views/survey_details_view.dart';
import 'package:v_ranger/features/batches/presentation/controllers/bataches_file_list_Controller.dart';

class CompletedList extends StatelessWidget {
  final BatachesFileListController controller;

  const CompletedList({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.data.value == null) {
        return const Center(
            child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ));
      } else if (controller.data.value!.data!.completedDetails!.isEmpty) {
        return const Center(child: Text('No completed batches'));
      } else {
        var completedList = controller.data.value!.data!.completedDetails;
        if (completedList!.isEmpty) {
          return const Center(child: Text('No completed batches'));
        }

        return ListView.builder(
          itemCount: completedList.length,
          itemBuilder: (context, index) {
            final batch = completedList[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Slidable(
                key: Key(batch.id.toString()),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10)),
                      onPressed: (context) {
                        Get.to(() => SurveyDetailsPage(
                              controller: controller,
                              index: index,
                              isBulkUpdate: false,
                              isEdit: true,
                            ));
                      },
                      backgroundColor: const Color.fromRGBO(47, 124, 55, 1),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.scoreBgColor1,
                    border: Border.all(width: 2, color: AppColors.boaderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              batch.fileid.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.scoreHeader,
                              ),
                            ),
                            Text(
                              batch.name.toString(),
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.green,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Text(
                                maxLines: 3,
                                batch.address.toString(),
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
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: AppColors.scoreHeader),
                    ],
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
