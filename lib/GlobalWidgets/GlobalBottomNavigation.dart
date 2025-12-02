import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/MainApplication/Customer/Dashboard/Dashboard.dart';
import 'package:data_base_project/MainApplication/Customer/Orders/historyUser.dart';
import 'package:data_base_project/MainApplication/Customer/Orders/shoppingCard.dart';
import 'package:data_base_project/MainApplication/Customer/Profile/Profile.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class GlobalBottomNavigator extends StatelessWidget {
  const GlobalBottomNavigator({
    super.key,
    required this.customer,
    required this.isInHistory,
    required this.isInHome,
    required this.isInProfile,
    required this.isInShoppinCart,
  });

  final bool isInHome;
  final bool isInShoppinCart;
  final bool isInHistory;
  final bool isInProfile;

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.05,
      right: MediaQuery.of(context).size.width * 0.1,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: const BoxDecoration(
          color: Color(0xcc3a3a3a),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            final bools = [isInHome, isInShoppinCart, isInHistory, isInProfile];
            final icons = [
              'assets/icon/HomeIcon.svg',
              'assets/icon/ShoppingCartIcon.svg',
              'assets/icon/HistoryIcon.svg',
              'assets/icon/ProfileIcon.svg'
            ];
            final iconsRed = [
              'assets/icon/HomeIconRed.svg',
              'assets/icon/ShoppingCartIconRed.svg',
              'assets/icon/HistoryIconRed.svg',
              'assets/icon/ProfileIconRed.svg'
            ];
            final functions = [
              () => AnimationNavigation.navigatePopAllReplace(
                  Dashboard(customer: customer), context),
              () => AnimationNavigation.navigatePush(
                  OrderSummaryPage(customer: customer), context),
              () => AnimationNavigation.navigatePush(
                  OrderHistoryPage(customer: customer), context),
              () => AnimationNavigation.navigatePush(
                  Profile(customer: customer), context),
            ];
            return GestureDetector(
              onTap: bools[index] ?() {} :functions[index] ,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                decoration: const BoxDecoration(
                  color: Color(0xff1D1A19),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: MediaQuery.of(context).size.width * 0.08,
                    child: SvgPicture.asset(
                      bools[index] ? iconsRed[index] : icons[index],
                      width: 12,
                      height: 12,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
