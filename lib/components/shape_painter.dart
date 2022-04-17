import 'package:flutter/material.dart';
class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var path = new Path();
    path.lineTo(0, size.height / 6);

    var firstControlPoint = new Offset(size.width / 2, size.height / 3);
    var firstEndPoint = new Offset(size.width, size.height / 6);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
    path.close();

    path = new Path();
    path.moveTo(0, size.height * .75);
    firstControlPoint = new Offset(size.width * 0.3, size.height * .85);
    firstEndPoint = new Offset(size.width * 0.3, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width * .3, size.height * 85);
    canvas.drawPath(path, paint);
    path.close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
