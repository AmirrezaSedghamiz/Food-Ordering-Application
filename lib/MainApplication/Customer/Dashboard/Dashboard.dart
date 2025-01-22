import 'dart:io';

import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/GlobalBottomNavigation.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.customer});
  Customer customer;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();

  List<Restaurant> nearRestaurants = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
        future: uint8ListToFile(widget.customer.image),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final imageFile = snapshot.data;

          return Scaffold(
            backgroundColor: const Color(0xFF201F22),
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(75),
              child: Center(
                child: GlobalAppBar(
                  image: imageFile,
                  username: widget.customer.username,
                  shouldPop: false,
                ),
              ),
            ),
            body: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.05,
                            MediaQuery.of(context).size.height * 0.03,
                            MediaQuery.of(context).size.width * 0.05,
                            MediaQuery.of(context).size.height * 0.18),
                        child: Column(children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 50 / 900,
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {},
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: "DanaFaNum",
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xff484848),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'دنبال چی میگردی؟',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey),
                                ),
                                counter: null,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFEDEDED), width: 1)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFEDEDED), width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFEDEDED), width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFEDEDED), width: 1)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'رستوران های نزدیکت',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: const Color(0xFFFEC37D),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    CupertinoIcons.backward,
                                    color: Color(0xFFFEC37D),
                                    size: 20,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height:
                                MediaQuery.of(context).size.height * 173 / 917,
                            child: ListView.builder(
                              itemCount: nearRestaurants.length,
                              itemBuilder: (context, index) {},
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                  const GlobalBottomNavigator(),
                ],
              ),
            ),
          );
        });
  }
}
