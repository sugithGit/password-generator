import 'dart:math';

num degToRad(num deg) => deg * (pi / 180.0);

num normalize(num value, num min, num max) => (value - min) / (max - min);
