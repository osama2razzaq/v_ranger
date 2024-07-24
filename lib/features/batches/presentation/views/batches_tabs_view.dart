import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/batches/presentation/views/abortList_view.dart';
import 'package:v_ranger/features/batches/presentation/views/completedList_view.dart';
import 'package:v_ranger/features/batches/presentation/views/pendingList_view.dart';

class BatchesView extends StatefulWidget {
  const BatchesView({super.key});

  @override
  _BatchesViewState createState() => _BatchesViewState();
}

class _BatchesViewState extends State<BatchesView> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  setState(() {
                    _searchText = text;
                  });
                },
              )
            : Text(
                "Batches",
                style: PromptStyle.appBarTitleStyle,
              ),
        actions: <Widget>[
          _isSearching
              ? IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _searchText = "";
                    });
                  },
                )
              : IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
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
                          const CircleAvatar(
                            radius: 9,
                            backgroundColor: Colors.orange,
                            child: Text(
                              '4',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Completed',
                            style: PromptStyle.tabbarTitile,
                          ),
                          const SizedBox(width: 4),
                          const CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.green,
                            child: Text(
                              '5',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
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
                          const CircleAvatar(
                            radius: 9,
                            backgroundColor: Colors.red,
                            child: Text(
                              '1',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    PendingList(),
                    CompletedList(),
                    AbortList(),
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
