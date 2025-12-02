import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/SourceDesign/Admin.dart';

class EditCustomer extends StatefulWidget {
  const EditCustomer({super.key, required this.admin});
  final Admin admin;

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final ScrollController _scrollController = ScrollController();
  List<Customer> _customers = [];
  List<TextEditingController> _controllers = [];
  bool _isLoading = false;
  int _pageNumber = 1;
  final int _pageSize = 10;
  String previousValue = '';
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
      List<Customer> customers = (await Admin.getAllCustomer(
          pageSize: _pageSize, pageNumber: _pageNumber))!;
      for (int i = 0; i < customers.length; i++) {
        _controllers.add(TextEditingController(text: customers[i].username));
      }
      setState(() {
        _customers.addAll(customers);
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
            itemCount: _customers.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _customers.length && _isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              Customer customer = _customers[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 320 / 412,
                  height: MediaQuery.of(context).size.height * 65 / 900,
                  decoration: BoxDecoration(
                    color: const Color(0xff484848),
                    borderRadius: BorderRadius.circular(4),
                    border:
                        Border.all(color: const Color(0xFFEDEDED), width: 1),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 3, 14, 0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: (customer.image == null)
                                  ? const AssetImage(
                                      "assets/images/defaultProfile.png")
                                  : MemoryImage(customer.image!)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 220 / 412,
                        height: MediaQuery.of(context).size.height * 55 / 900,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.top,
                          controller: _controllers[index],
                          obscureText: false,
                          readOnly: selectedIndex != index,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 13,
                              fontFamily: "DanaFaNum",
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                          decoration: const InputDecoration(
                            counter: null,
                            border: null, 
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
                                  _controllers[selectedIndex].text =
                                      previousValue;
                                }
                                previousValue = _controllers[index].text;
                                selectedIndex = index;
                              });
                            } else {
                              setState(() {
                                _controllers[index].text = previousValue;
                                selectedIndex = -1;
                              });
                            }
                          },
                          child: (selectedIndex != index
                                  ? Assets.images.edit
                                  : Assets.images.abort)
                              .image(width: 30, height: 30)),
                      const SizedBox(
                        width: 6,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (selectedIndex != index) {
                            Admin.deleteCustomer(
                                customerId: _customers[index].customerId);
                            setState(() {
                              _customers.removeAt(index);
                              _controllers.removeAt(index);
                              selectedIndex = -1;
                            });
                          } else {
                            setState(() {
                              _customers[index].username =
                                  _controllers[index].text;
                              selectedIndex = -1;
                            });
                            Customer.updateCustomer(
                                username: _customers[index].username,
                                customerId: _customers[index].customerId,
                                phoneNumber: _customers[index].phoneNumber,
                                image: await uint8ListToFile(
                                    _customers[index].image));
                          }
                        },
                        child: (selectedIndex != index
                                ? Assets.images.delete
                                : Assets.images.submit)
                            .image(width: 30, height: 30),
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
