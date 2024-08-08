import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/features/batches/presentation/controllers/bataches_file_list_Controller.dart';

class AbortList extends StatelessWidget {
  final BatachesFileListController controller;

  const AbortList({Key? key, required this.controller}) : super(key: key);

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
        var abortList = controller.data.value!.data!.abortedDetails;

        return ListView.builder(
          itemCount: abortList!.length,
          itemBuilder: (context, index) {
            final batch = abortList[index];
            return Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: AppColors.scoreBgColor3,
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
                      color: AppColors.red,
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
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.red,
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
                  // const Icon(Icons.arrow_forward_ios,
                  //     size: 16, color: AppColors.scoreHeader),
                ],
              ),
            );
          },
        );
      }
    });
  }
}
