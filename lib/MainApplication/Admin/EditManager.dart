import 'package:flutter/material.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/SourceDesign/Admin.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/gen/assets.gen.dart';

class EditMyManager extends StatefulWidget {
  const EditMyManager({super.key, required this.admin});
  final Admin admin;

  @override
  State<EditMyManager> createState() => _EditMyManagerState();
}

class _EditMyManagerState extends State<EditMyManager> {
  final ScrollController _scrollController = ScrollController();
  List<ManagerRestaurant> _managers = [];
  List<TextEditingController> _managerControllers = [];
  List<TextEditingController> _restaurantControllers = [];
  bool _isLoading = false;
  int _pageNumber = 1;
  final int _pageSize = 10;
  String previousValue = '';
  String previousRestaurnatValue = '';
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  Future<void> _fetchCustomers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<ManagerRestaurant> managers = (await Admin.getManagerRestaurants(
          pageSize: _pageSize, pageNumber: _pageNumber))!;
      for (int i = 0; i < managers.length; i++) {
        _managerControllers
            .add(TextEditingController(text: managers[i].manager.username));
        _restaurantControllers
            .add(TextEditingController(text: managers[i].restaurant?.name));
      }
      setState(() {
        _managers.addAll(managers);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (!_isLoading) {
      _pageNumber++;
      await _fetchCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF201F22),
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: GlobalAppBarForAdmin(
            username: widget.admin.username,
            shouldPop: true,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: _managers.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _managers.length && _isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              ManagerRestaurant manager = _managers[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 320 / 412,
                  height: MediaQuery.of(context).size.height * 110 / 900,
                  decoration: BoxDecoration(
                    color: const Color(0xff484848),
                    borderRadius: BorderRadius.circular(4),
                    border:
                        Border.all(color: const Color(0xFFEDEDED), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 3, 0, 0),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: (manager.manager.image == null)
                                  ? const AssetImage(
                                      "assets/images/defaultProfile.png")
                                  : MemoryImage(manager.manager.image!)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    220 /
                                    412,
                                height: MediaQuery.of(context).size.height *
                                    20 /
                                    900,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.bottom,
                                  controller: _managerControllers[index],
                                  obscureText: false,
                                  readOnly: selectedIndex != index,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: "DanaFaNum",
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                  decoration: const InputDecoration(
                                    counter: null,
                                    border: InputBorder
                                        .none, // Removes the default underline
                                    focusedBorder: null,
                                    enabledBorder: null,
                                    disabledBorder: null,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    if (selectedIndex != index) {
                                      setState(() {
                                        if (selectedIndex != -1) {
                                          _managerControllers[selectedIndex]
                                              .text = previousValue;
                                          _restaurantControllers[selectedIndex]
                                              .text = previousRestaurnatValue;
                                        }
                                        previousValue =
                                            _managerControllers[index].text;
                                        previousRestaurnatValue =
                                            _restaurantControllers[index].text;
                                        selectedIndex = index;
                                      });
                                    } else {
                                      setState(() {
                                        _managerControllers[index].text =
                                            previousValue;
                                        _restaurantControllers[index].text =
                                            previousRestaurnatValue;
                                        selectedIndex = -1;
                                      });
                                    }
                                  },
                                  child: (selectedIndex != index
                                          ? Assets.images.edit
                                          : Assets.images.abort)
                                      .image(width: 30, height: 30)),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      220 /
                                      412, // Same as TextField width
                                  child: const Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    220 /
                                    412,
                                height: MediaQuery.of(context).size.height *
                                    25 /
                                    900,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  controller: _restaurantControllers[index],
                                  obscureText: false,
                                  readOnly: selectedIndex != index ||
                                      _restaurantControllers[index]
                                          .text
                                          .isEmpty,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: "DanaFaNum",
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFFEC37D)),
                                  decoration: const InputDecoration(
                                    counter: null,
                                    hintText: 'رستورانی یافت نشد',
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "DanaFaNum",
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFFEC37D)),
                                    border: InputBorder.none,
                                    focusedBorder: null,
                                    enabledBorder: null,
                                    disabledBorder: null,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (selectedIndex != index) {
                                    Admin.deleteManager(
                                        managerId:
                                            _managers[index].manager.managerid);
                                    setState(() {
                                      _managers.removeAt(index);
                                      _managerControllers.removeAt(index);
                                      _restaurantControllers.removeAt(index);
                                      selectedIndex = -1;
                                    });
                                  } else {
                                    if (_managerControllers[index]
                                            .text
                                            .isEmpty ||
                                    (_restaurantControllers[index]
                                            .text
                                            .isEmpty && previousRestaurnatValue.isNotEmpty)) {
                                      return;
                                    }
                                    setState(() {
                                      _managers[index].manager.username =
                                          _managerControllers[index].text;
                                      if (_managers[index].restaurant != null) {
                                        _managers[index].restaurant!.name =
                                            _restaurantControllers[index].text;
                                      }
                                      selectedIndex = -1;
                                    });

                                    Admin.updateManager(
                                        managerId:
                                            _managers[index].manager.managerid,
                                        restaurantName:
                                            _restaurantControllers[index].text,
                                        managerName:
                                            _managerControllers[index].text);
                                  }
                                },
                                child: (selectedIndex != index
                                        ? Assets.images.delete
                                        : Assets.images.submit)
                                    .image(width: 30, height: 30),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
