import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

class TricyclePainter extends CustomPainter {
  final Color color;

  TricyclePainter({this.color = AppColors.primaryNavy});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // We design the tricycle based on a reference grid of 200 x 140
    final double scaleX = size.width / 200;
    final double scaleY = size.height / 140;

    // Draw the sidecar body (left cabin)
    final Path sidecarBody = Path()
      ..moveTo(25 * scaleX, 55 * scaleY)
      ..lineTo(110 * scaleX, 55 * scaleY)
      ..lineTo(110 * scaleX, 105 * scaleY)
      ..lineTo(25 * scaleX, 105 * scaleY)
      ..close();
    canvas.drawPath(sidecarBody, paint);

    // Draw the window (cutout color, we can draw it in white or transparent if we draw a background,
    // but drawing it with a lighter background color or white makes it look like a window)
    final Paint windowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final RRect window = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        35 * scaleX,
        63 * scaleY,
        85 * scaleX,
        88 * scaleY,
      ),
      Radius.circular(4 * scaleX),
    );
    canvas.drawRRect(window, windowPaint);

    // Draw the sidecar roof (visor)
    final Path sidecarRoof = Path()
      ..moveTo(20 * scaleX, 55 * scaleY)
      ..lineTo(150 * scaleX, 55 * scaleY)
      ..lineTo(150 * scaleX, 47 * scaleY)
      ..quadraticBezierTo(140 * scaleX, 45 * scaleY, 130 * scaleX, 45 * scaleY)
      ..lineTo(25 * scaleX, 45 * scaleY)
      ..quadraticBezierTo(20 * scaleX, 45 * scaleY, 20 * scaleX, 55 * scaleY)
      ..close();
    canvas.drawPath(sidecarRoof, paint);

    // Draw motorcycle frame/front shield (right)
    final Path motorcycleShield = Path()
      ..moveTo(125 * scaleX, 60 * scaleY)
      ..lineTo(145 * scaleX, 60 * scaleY)
      ..lineTo(145 * scaleX, 90 * scaleY)
      ..lineTo(130 * scaleX, 110 * scaleY)
      ..lineTo(125 * scaleX, 100 * scaleY)
      ..close();
    canvas.drawPath(motorcycleShield, paint);

    // Draw connection bars between motorcycle and sidecar
    canvas.drawLine(
      Offset(110 * scaleX, 70 * scaleY),
      Offset(130 * scaleX, 70 * scaleY),
      strokePaint,
    );
    canvas.drawLine(
      Offset(110 * scaleX, 95 * scaleY),
      Offset(130 * scaleX, 95 * scaleY),
      strokePaint,
    );

    // Motorcycle Handlebars & headlight area
    final Path handlebars = Path()
      ..moveTo(125 * scaleX, 60 * scaleY)
      ..quadraticBezierTo(137 * scaleX, 55 * scaleY, 137 * scaleX, 48 * scaleY)
      // Left handlebar
      ..moveTo(137 * scaleX, 48 * scaleY)
      ..lineTo(122 * scaleX, 48 * scaleY)
      // Right handlebar
      ..moveTo(137 * scaleX, 48 * scaleY)
      ..lineTo(152 * scaleX, 48 * scaleY);
    canvas.drawPath(handlebars, strokePaint);

    // Headlight
    canvas.drawCircle(Offset(137 * scaleX, 56 * scaleY), 5 * scaleX, paint);

    // Sidecar wheel (bottom left)
    final double sidecarWheelX = 50 * scaleX;
    final double sidecarWheelY = 112 * scaleY;
    final double wheelRadius = 16 * scaleX;

    // Mudguard for sidecar wheel
    final Rect mudguardRect = Rect.fromCircle(
      center: Offset(sidecarWheelX, sidecarWheelY),
      radius: wheelRadius + 4 * scaleX,
    );
    canvas.drawArc(
      mudguardRect,
      3.14, // start from PI (left side)
      3.14, // sweep PI (top arc)
      false,
      strokePaint,
    );

    // Draw wheels
    canvas.drawCircle(
      Offset(sidecarWheelX, sidecarWheelY),
      wheelRadius,
      paint,
    );
    canvas.drawCircle(
      Offset(sidecarWheelX, sidecarWheelY),
      wheelRadius * 0.4,
      windowPaint,
    );

    // Motorcycle wheel (bottom right)
    final double motoWheelX = 137 * scaleX;
    final double motoWheelY = 112 * scaleY;

    // Mudguard for motorcycle wheel
    final Rect motoMudguardRect = Rect.fromCircle(
      center: Offset(motoWheelX, motoWheelY),
      radius: wheelRadius + 4 * scaleX,
    );
    canvas.drawArc(
      motoMudguardRect,
      3.14,
      3.14,
      false,
      strokePaint,
    );

    canvas.drawCircle(
      Offset(motoWheelX, motoWheelY),
      wheelRadius,
      paint,
    );
    canvas.drawCircle(
      Offset(motoWheelX, motoWheelY),
      wheelRadius * 0.4,
      windowPaint,
    );

    // Bumper / tail guard details
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(15 * scaleX, 90 * scaleY, 25 * scaleX, 95 * scaleY),
        Radius.circular(2 * scaleX),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TricycleLogo extends StatelessWidget {
  final double size;
  final Color color;

  const TricycleLogo({
    super.key,
    this.size = 120.0,
    this.color = AppColors.primaryNavy,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.4,
      height: size,
      child: CustomPaint(
        painter: TricyclePainter(color: color),
      ),
    );
  }
}
