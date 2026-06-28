import '../failure.dart';

class DuplicateFoodFailure extends Failure {
  DuplicateFoodFailure({
    super.msg =
        "A food item with this exact name and brand already exists. Please update the name or brand details.",
  });
}
