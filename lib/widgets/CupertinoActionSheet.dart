import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCupertinoActionSheet{
  final BuildContext context;
  final List<String> sheets;
  final String? title;
  final String? message;
  final Function(String element) topCallback;
  CustomCupertinoActionSheet(this.context,this.sheets,this.topCallback, this.title, this.message);

   showActionSheet(){
     showDialog(context: context, builder: (ctx) =>
         _buildCupertinoActionSheet()
     );
   }

  Widget _buildCupertinoActionSheet(){
     return Container(
       alignment: Alignment.bottomCenter,
       child: CupertinoActionSheet(title: title ==null?null: Text(title!),
              message:message ==null?null: Text(message!),cancelButton: CupertinoActionSheetAction(onPressed: () => _pop(),
           child: Text('cancel'.tr),),actions: sheets.asMap().values.map((element){
             return CupertinoActionSheetAction(onPressed: (){
               topCallback(element);
               _pop();
             }, child: Text(element));
         }).toList(),),
     );
   }

   _pop(){
     Navigator.pop(context);
   }
}