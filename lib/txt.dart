import 'package:flutter/material.dart';

class txt extends StatelessWidget {
  const txt(this.text,this.color,this.size,{super.key});

  final String text;
  final Color color;
  final double size;

  @override
  Widget build(context){
    return Text(
      text,
      style:TextStyle(
        color:color,
        fontSize: size,
      ),
    );
  }
}