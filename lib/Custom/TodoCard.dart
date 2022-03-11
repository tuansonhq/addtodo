import 'package:flutter/material.dart';

class ToDoCard extends StatelessWidget {
  const ToDoCard({
    Key? key,
    required this.title,
    required this.iconData,
    required this.color,
    required this.time,
    required this.check,
    required this.iconBigColor,
    required this.onChange,
    required this.index}) : super(key: key);

  final String title;
  final IconData iconData;
  final Color color;
  final String time;
  final bool check;
  final Color iconBigColor;
  final Function onChange;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    activeColor: Color(0xff6cf8a9),
                    checkColor: Color(0xff0e3e26),
                    value: check,
                    onChanged: (bool? value){
                      onChange(index);
                    }
                )
            ),
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Color(0xff5e616a),
            ),
          ),
          Expanded(
            child: Container(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                color: Color(0xff2a2e3d),
                child: Row(
                  children: [
                    SizedBox(width: 15,),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color: iconBigColor,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Icon(
                        iconData,
                        color: color,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: Colors.white
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                          color: Colors.white
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
