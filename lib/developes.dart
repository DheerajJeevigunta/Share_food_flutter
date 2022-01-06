// import 'package:flutter/material.dart';
// import 'package:share_food/constants.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:share_food/data.dart';
// class Developers extends StatefulWidget {
//   const Developers({ Key? key }) : super(key: key);

//   @override
//   _DevelopersState createState() => _DevelopersState();
// }

// class _DevelopersState extends State<Developers> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: gradientEndColor,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [gradientStartColor,gradientEndColor],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter
//           )
//         ),
//         child:SafeArea(
//           child: Column(
//             crossAxisAlignment:CrossAxisAlignment.start ,
//             children:<Widget> [
//               Padding(
//                 padding: const EdgeInsets.all(32.0),
//                 child: Column(
//                   children: <Widget>[
//                       Text("Developers",
//                       style: TextStyle(fontFamily: 'Avenir',
//                       fontSize: 44,
//                       color: const Color(0xffffffff),
//                       fontWeight: FontWeight.w900
//                       ),
//                       textAlign:TextAlign.left),
//                   ],
//                 ),
//               ),
//             Container(
//                height:500,
//                padding:const EdgeInsets.only(left: 32),
//                child: Swiper(
//                  itemCount: developers.length,
//                  itemWidth: MediaQuery.of(context).size.width-2 * 64,
//                  layout: SwiperLayout.STACK,
//                  pagination:SwiperPagination(
//                    builder: DotSwiperPaginationBuilder(
//                      activeSize: 20,
//                      space: 8

//                    ),
//                  ),
//                  itemBuilder: (context,index){
//                    return Padding(
//                      padding: const EdgeInsets.only(top:61.0),
//                      child: Stack(
//                        children: <Widget>[
//                          Column(
//                            children: <Widget>[
//                              SizedBox(height: 100,),
//                              Card(
//                                elevation: 8,
//                                shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(32)
//                                ),
//                                color: Colors.white,
//                                child: Padding(
//                                  padding: const EdgeInsets.all(32.0),
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: <Widget>[
//                                      SizedBox(height: 100,),
//                                      Padding(
//                                        padding: const EdgeInsets.only(left:10.0,right: 10.0),
//                                        child: Text(
//                                          developers[index].name,
//                                          style: TextStyle( 
//                                             fontFamily: 'Avenir',
//                           fontSize: 34,
//                           color: primaryTextColor,
//                           fontWeight: FontWeight.w700,
//                                          ),
//                                          textAlign: TextAlign.center,
//                                        ),
//                                      ),
//                                        Text(
                                            
//                                             developers[index].regNo,
//                                             style: TextStyle(
//                                               fontFamily: 'Avenir',
//                                               fontSize: 23,
//                                               color: secondaryTextColor,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                           SizedBox(height: 32),
//                                           Row(
//                                             children: <Widget>[
//                                               Text(
//                                                 developers[index].Class,
//                                                 style: TextStyle(
//                                                   fontFamily: 'Avenir',
//                                                   fontSize: 18,
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                                 textAlign: TextAlign.left,
//                                               ),
//                                             ]
//                                           )
//                                    ],
//                                  ),
//                                ),
//                              )
//                            ],
//                          ),
                       
//                        Padding(
                         
//                          padding: const EdgeInsets.only(left:24.8),
//                          child: Material(
//                            elevation: 17,
//                            shadowColor: gradientStartColor,
//                            shape: CircleBorder(),
//                            child: Image.asset(developers[index].Iconimage,height: 214,width: 214,
                           
//                            ),
//                          ),
                         
//                        )
                       
//                        ],
//                      ),
//                    );
//                  },
//                ),
//             ),
           
            
//             ],
//           ),
//         ),
//       ),
      
//     );
//   }
// }