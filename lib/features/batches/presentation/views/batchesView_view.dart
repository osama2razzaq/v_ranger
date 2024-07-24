import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';

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
                    //  icon: Icons.delete,
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
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                    //  icon: Icons.delete,
                    label: 'Abort',
                  ),
                ),
              ),
            ],
          ),
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
        );
      },
    );
  }
}

class CompletedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Completed List'),
    );
  }
}

class AbortList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Abort List'),
    );
  }
}
