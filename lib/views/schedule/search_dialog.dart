// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:ootm_app/data/ootm_icon_pack.dart';
// import 'package:ootm_app/data/performance.dart';
// import 'package:ootm_app/widgets/box_decoration.dart';

// class SearchDialog extends StatefulWidget {
//   final GlobalKey parentKey;
//   final Box box;
//   SearchDialog({Key key, this.parentKey, this.box}) : super(key: key);

//   @override
//   _SearchDialogState createState() => _SearchDialogState();
// }

// class _SearchDialogState extends State<SearchDialog> {
//   TextEditingController controller = new TextEditingController();
//   String searchQuery;
  
  
//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(() {
//       setState(() {
//         searchQuery = controller.text.toLowerCase();
//       });
//     });
//   }
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   int itemCounter(int _count) {
//     if (_count < 5)
//     return _count;
//     else 
//     return 5;
//   } 

//   @override
//   Widget build(BuildContext context) {
//     final RenderBox renderBoxRed = this.widget.parentKey.currentContext.findRenderObject();
//     Offset position;
//     if (kIsWeb)
//       position = renderBoxRed.localToGlobal(Offset(-16.0, 0.0));
//     else 
//       position = renderBoxRed.localToGlobal(Offset(-16.0, -21.0));

//     final List<String> boxKeys = this.widget.box.get("performances");
//     final List<Performance> pfList = [for(String k in boxKeys) this.widget.box.get(k)];
//     List<Performance> searchResult = [];
//     if (searchQuery != "" && searchQuery != null)
//       searchResult = pfList.where((pf) => pf.team.toLowerCase().contains(searchQuery)).toList();
//     return GestureDetector(
//       onTap: () => Navigator.of(context).maybePop(),
//       child: Material(
//         type: MaterialType.button,
//         color: Colors.transparent,
//         child: Transform.translate(
//           offset: position,
//           // offset: Offset(0, 0),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Stack(
//                 children: <Widget>[
//                   Positioned(
//                     top: 0.0,
//                     bottom: 0.0,
//                     left: 0.0,
//                     right: 0.0,
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
//                           decoration: whiteBoxDecoration(),
//                             child: ListView.separated(
//                               separatorBuilder: (context, index) => Divider(),
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             primary: false,
//                             itemCount: itemCounter(searchResult.length),
//                             itemBuilder: (context, idx) {
//                               if (searchResult.isNotEmpty) {
//                                 final List<TextSpan> children = []; 
//                                 String team = searchResult[idx].team;
//                                 String teamLowerCase = team.toLowerCase();
//                                 int index = 0;
//                                 int matchLen = searchQuery.length;
//                                 int oldIndex;
//                                 String preMatch;
//                                 String match;
//                                 while (index != -1) {
//                                   oldIndex = index;
//                                   index = teamLowerCase.indexOf(searchQuery, oldIndex);
//                                   if (index >= 0) {
//                                     preMatch = team.substring(oldIndex, index);
//                                     // print(preMatch);
//                                     match = team.substring(index, index + matchLen);
//                                     // print(match);
//                                     if (preMatch.isNotEmpty)
//                                       children.add(TextSpan(text: preMatch));
//                                     children.add(
//                                       TextSpan(
//                                         text: match,
//                                         style: TextStyle(fontWeight: FontWeight.bold)
//                                       )
//                                     );
//                                     index += matchLen;
//                                   } else {
//                                     // print("koniec");
//                                     children.add(TextSpan(text: team.substring(oldIndex)));
//                                   }
//                                 }
//                                 // print();
//                                 return GestureDetector(
//                                   onTap: ()=> print([searchResult[idx].team, searchResult[idx].id]),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     child: RichText(
//                                       text: TextSpan(
//                                         style: DefaultTextStyle.of(context).style,
//                                         children: [...children]
//                                       ),
//                                     ),
//                                   ),
//                                 );

//                               }
//                               else
//                                 return SizedBox();
//                             }
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: whiteBoxDecoration(),
//                     height: 40.0,
//                     child: TextField(
//                     controller: controller,
//                     textAlign: TextAlign.start,
//                       textAlignVertical: TextAlignVertical.center,
//                     decoration: InputDecoration(
//                       // icon: Icon(OotmIconPack.info),
//                       border: InputBorder.none,
//                       isDense: true,
//                       contentPadding: EdgeInsets.only(left: 16.0),
//                       suffixText: null,
//                       suffixIcon: Transform.translate(
//                         offset: Offset(24.0, 0.0),
//                         child: RawMaterialButton(
//                           child: Container(
//                             height: 40.0,
//                             width: 40.0,
//                             decoration: orangeBoxDecoration(),
//                             child: Icon(OotmIconPack.search, color: Colors.white, size: 24.0,),
//                           ),
//                           onPressed: null
//                         ),
//                       ),
//                     ),
//                     autofocus: true,
                    
//                     style: TextStyle(
//                       fontSize: 15.0,
//                     ),
//                     ),
//                   ),
//                 ],
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
// }