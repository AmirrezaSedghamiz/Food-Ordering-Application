import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class GlobalBottomNavigator extends StatelessWidget {
  const GlobalBottomNavigator({
    super.key,
  });

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
            final icons = [
              'assets/icon/HomeIcon.svg',
              'assets/icon/ShoppingCartIcon.svg',
              'assets/icon/MapPinIcon.svg',
              'assets/icon/ProfileIcon.svg'
            ];
            return Container(
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
                    icons[index],
                    width: 12,
                    height: 12,
                    fit: BoxFit.cover,
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
