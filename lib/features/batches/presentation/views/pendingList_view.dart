import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/features/Survey/presentation/views/survey_details_view.dart';

class PendingList extends StatelessWidget {
  PendingList({super.key});
  final List<Map<String, String>> data = [
    {
      "id": "5",
      "name": "YEO HAN",
      "address":
          "88866033: Jalan Bintang,Off jalan bukit Bintang Central kuala lumpur"
    },
    {
      "id": "7",
      "name": "ALIF",
      "address":
          "88866033: Jalan Bintang,Off jalan bukit Bintang  Central kuala lumpur jalan sultan"
    },
    {
      "id": "8",
      "name": "RAVI",
      "address": "88866033: Jalan Bintang,Off jalan bukit Bintang Central.."
    },
    {
      "id": "9",
      "name": "FIRDAUS",
      "address": "88866033: Jalan Bintang,Off jalan bukit Bintang Central.."
    },
    {
      "id": "10",
      "name": "IZZAT",
      "address": "88866033: Jalan Bintang,Off jalan bukit Bintang Central.."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Slidable(
          key: Key(data[index]['id']!),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: SlidableAction(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(10)),
                    onPressed: (context) {
                      // Delete action
                      // Handle delete logic here
                      // For example, remove the item from the list
                    },
                    backgroundColor: AppColors.yellow,
                    foregroundColor: Colors.white,
                    icon: Icons.push_pin,
                    label: 'Pin',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                  child: SlidableAction(
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(10)),
                    onPressed: (context) {
                      // Delete action
                      // Handle delete logic here
                      // For example, remove the item from the list
                    },
                    foregroundColor: Colors.white,
                    icon: Icons.cancel,
                    label: 'Abort',
                  ),
                ),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              print("object");
              Get.to(() => SurveyPage());
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              // height: 58,
              decoration: BoxDecoration(
                color: AppColors.scoreBgColor2,
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
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index]['id']!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.scoreHeader,
                          ),
                        ),
                        Text(
                          data[index]['name']!,
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
                            data[index]['address']!,
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
}
