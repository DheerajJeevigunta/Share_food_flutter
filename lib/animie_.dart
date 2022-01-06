
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:share_food/user_ch.dart';

// class Anmie extends StatefulWidget{
//   const Anmie({Key? key}) : super(key: key);
//   @override
//   _AnmieState createState()=>_AnmieState();
// }
// class _AnmieState extends State<Anmie> with TickerProviderStateMixin {
//   late AnimationController animationController;
//   late Animation startAnimation;
//   late Animation endAnimation;
//   late Animation horizantalAnimation;
//   late PageController pageController;
//  @override
//   void initState() {
//     super.initState();
//     pageController = PageController();
//     animationController =
//         AnimationController(duration: Duration(milliseconds: 750), vsync: this);

//     startAnimation = CurvedAnimation(
//       parent: animationController,
//       curve: Interval(0.000, 0.500, curve: Curves.easeInExpo),
//     );

//     endAnimation = CurvedAnimation(
//       parent: animationController,
//       curve: Interval(0.500, 1.000, curve: Curves.easeInExpo),
//     );

//     horizantalAnimation = CurvedAnimation(
//       parent: animationController,
//       curve: Interval(0.750, 1.000, curve: Curves.easeInExpo),
//     );

//     // ignore: avoid_single_cascade_in_expression_statements
//     animationController
//       ..addStatusListener((status) {
//         final model = Provider.of<UserCh>(context);
//         if (status == AnimationStatus.completed) {
//           model.swapColors();
//           animationController.reset();
//         }
//       })
//       ..addListener(() {
//         final model = Provider.of<UserCh>(context);
//         if (animationController ,value >0.5){
//           model.isHalfWay =true;  

//         }else{
//           model.isHalfWay = false;
//         }
//       });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
