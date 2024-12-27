import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/batches/presentation/controllers/bataches_file_list_Controller.dart';
import 'package:v_ranger/features/batches/presentation/views/abortList_view.dart';
import 'package:v_ranger/features/batches/presentation/views/completedList_view.dart';
import 'package:v_ranger/features/batches/presentation/views/pendingList_view.dart';

class BatchesTabsView extends StatefulWidget {
  final String? batchId;
  final bool? isCompleted;

  const BatchesTabsView({super.key, this.batchId, this.isCompleted});

  @override
  _BatchesTabsViewState createState() => _BatchesTabsViewState();
}

class _BatchesTabsViewState extends State<BatchesTabsView> {
  final BatachesFileListController controller =
      Get.put(BatachesFileListController());

  @override
  Widget build(BuildContext context) {
    controller.fetchBatchDetailsList(widget.batchId.toString(), '', '', '');

    int initialIndex = widget.isCompleted == true ? 1 : 0;
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
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
                    controller.setSearchText(
                      text,
                      widget.batchId.toString(),
                    );
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
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          initialIndex: initialIndex,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                padding: const EdgeInsets.all(5),
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.tabbarBg,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.colorWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pending',
                            style: PromptStyle.tabbarTitile,
                          ),
                          const SizedBox(width: 4),
                          Obx(() => CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.orange,
                                child: FittedBox(
                                  child: Text(
                                    '${controller.pendingCount}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 9),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Completed',
                            style: PromptStyle.tabbarTitile,
                          ),
                          const SizedBox(width: 4),
                          Obx(() => CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.green,
                                child: FittedBox(
                                  child: Text(
                                    '${controller.completedCount}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Abort',
                            style: PromptStyle.tabbarTitile,
                          ),
                          const SizedBox(width: 4),
                          Obx(() => CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: FittedBox(
                                  child: Text(
                                    '${controller.abortCount}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    PendingList(
                      controller: controller,
                      batchId: widget.batchId,
                    ),
                    CompletedList(controller: controller),
                    AbortList(controller: controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
