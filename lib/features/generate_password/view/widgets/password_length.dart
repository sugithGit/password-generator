import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/util/utils.dart';
import '../../bloc/password_generate_bloc.dart';

class PasswordLength extends StatelessWidget {
  const PasswordLength({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordGenratorBloc, PasswordGenratorState>(
      builder: (BuildContext context, PasswordGenratorState state) {
        return const _SliderWidget();
      },
    );
  }
}

class _SliderWidget extends StatefulWidget {
  const _SliderWidget();

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<_SliderWidget> {
  double progressVal = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kDiameter,
      height: kDiameter,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform.scale(
            scale: 1,
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return SweepGradient(
                  startAngle: degToRad(180).toDouble(),
                  endAngle: degToRad(360).toDouble(),
                  colors: <Color>[
                    primaryColor,
                    Colors.grey.withAlpha(50),
                  ],
                  stops: <double>[progressVal, progressVal],
                ).createShader(rect);
              },
              child: const _CustomArc(),
            ),
          ),
          Container(
            width: kDiameter - 40,
            height: kDiameter - 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: trackBg,
                width: 20,
              ),
            ),
            child: SleekCircularSlider(
              min: kMinDegree,
              max: kMaxDegree,
              initialValue: kMinDegree,
              appearance: CircularSliderAppearance(
                startAngle: 180,
                angleRange: 180,
                size: kDiameter - 30,
                customWidths: CustomSliderWidths(
                  trackWidth: 15,
                  shadowWidth: 0,
                  progressBarWidth: 01,
                  handlerSize: 15,
                ),
                customColors: CustomSliderColors(
                  hideShadow: true,
                  progressBarColor: Colors.transparent,
                  trackColor: const Color(0xFF20201e),
                  dotColor: thumb,
                ),
              ),
              onChange: (double value) {
                setState(() {
                  progressVal =
                      normalize(value, kMinDegree, kMaxDegree).toDouble();
                });
                context.read<PasswordGenratorBloc>().add(
                      ChangePasswordLengthEvent(
                        passwordLength: value.toInt(),
                      ),
                    );
              },
              innerWidget: (double value) {
                return Center(
                  child: Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      fontSize: 50,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomArc extends StatelessWidget {
  const _CustomArc();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomArcPainter(),
      size: const Size(kDiameter, kDiameter),
    );
  }
}

class CustomArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    // Calculate the exact center and radius
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - paint.strokeWidth) / 2;

    final Path path = Path()
      // Start slightly inside the edge to prevent leaking
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi + 0.02, // Add small offset to prevent edge leaking
        math.pi - 0.04, // Subtract offset from both ends
      );

    final Path dashPath = Path();
    const double dashWidth = 10;
    const double dashSpace = 10;
    double distance = 3;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
