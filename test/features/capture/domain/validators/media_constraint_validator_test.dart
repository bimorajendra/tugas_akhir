import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/capture/domain/validators/media_constraint_validator.dart';

void main() {
  test('valid media formats and limits', () {
    expect(
      MediaConstraintValidator.validate(
        fileName: 'lunch_ompreng.jpg',
        fileSizeBytes: 4 * 1024 * 1024,
        isVideo: false,
      ).isValid,
      isTrue,
    );
    expect(
      MediaConstraintValidator.validate(
        fileName: 'plate_lunch.PNG',
        fileSizeBytes: 8 * 1024 * 1024,
        isVideo: false,
      ).isValid,
      isTrue,
    );
    expect(
      MediaConstraintValidator.validate(
        fileName: 'ompreng_pan.mp4',
        fileSizeBytes: 24 * 1024 * 1024,
        isVideo: true,
      ).isValid,
      isTrue,
    );
    expect(
      MediaConstraintValidator.validate(
        fileName: 'food.gif',
        fileSizeBytes: 2,
        isVideo: false,
      ).error,
      MediaValidationError.unsupportedFormat,
    );
    expect(
      MediaConstraintValidator.validate(
        fileName: 'large.jpg',
        fileSizeBytes: 12 * 1024 * 1024,
        isVideo: false,
      ).error,
      MediaValidationError.fileTooLarge,
    );
    expect(
      MediaConstraintValidator.validate(
        fileName: 'empty.jpg',
        fileSizeBytes: 0,
        isVideo: false,
      ).error,
      MediaValidationError.fileNotFoundOrEmpty,
    );
  });
}
