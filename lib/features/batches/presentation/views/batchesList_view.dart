import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/batches/presentation/controllers/batchesList_controller.dart';
import 'package:v_ranger/features/batches/presentation/views/batches_tabs_view.dart';

class BatchesListView extends StatelessWidget {
  final BatchesListController controller = Get.put(BatchesListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change your color here
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Obx(() {
          return controller.isSearching.value
              ? TextField(
                  autocorrect: false,
                  cursorColor: AppColors.colorWhite,
                  controller: TextEditingController()
                    ..text = controller.searchText.value
                    ..selection = TextSelection.collapsed(
                        offset: controller.searchText.value.length),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (text) {
                    controller.setSearchText(text);
                  },
                )
              : Text(
                  "Batches",
                  style: PromptStyle.appBarTitleStyle,
                );
        }),
        actions: <Widget>[
          Obx(() {
            return controller.isSearching.value
                ? IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.stopSearch();
                    },
                  )
                : IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      controller.startSearch();
                    },
                  );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.data.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filteredData.isEmpty) {
          return Center(child: Text("No batches found"));
        }

        return ListView.builder(
          itemCount: controller.filteredData.length,
          itemBuilder: (context, index) {
            var batch = controller.filteredData[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => BatchesTabsView(batchId: batch.batchId));
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  border: Border.all(width: 2, color: AppColors.boaderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 30,
                      margin: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Batch ID: ${batch.batchId}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.scoreHeader,
                            ),
                          ),
                          Text(
                            "Batch No: ${batch.batchNo}",
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
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
            );
          },
        );
      }),
    );
  }
}
