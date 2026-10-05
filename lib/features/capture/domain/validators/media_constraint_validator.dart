enum MediaValidationError {
  none,
  unsupportedFormat,
  fileTooLarge,
  fileNotFoundOrEmpty,
}

class MediaValidationResult {
  final bool isValid;
  final MediaValidationError error;
  final String? message;

  const MediaValidationResult({
    required this.isValid,
    required this.error,
    this.message,
  });
  const MediaValidationResult.success()
    : this(isValid: true, error: MediaValidationError.none);
  const MediaValidationResult.failure({
    required MediaValidationError error,
    required String message,
  }) : this(isValid: false, error: error, message: message);
}

class MediaConstraintValidator {
  static const maxPhotoSizeBytes = 10 * 1024 * 1024;
  static const maxVideoSizeBytes = 50 * 1024 * 1024;
  static const supportedPhotoExtensions = {'jpg', 'jpeg', 'png'};
  static const supportedVideoExtensions = {'mp4'};

  static MediaValidationResult validate({
    required String fileName,
    required int fileSizeBytes,
    required bool isVideo,
  }) {
    if (fileSizeBytes <= 0) {
      return const MediaValidationResult.failure(
        error: MediaValidationError.fileNotFoundOrEmpty,
        message: 'File media kosong atau tidak ditemukan.',
      );
    }
    final dot = fileName.lastIndexOf('.');
    if (dot < 0 || dot == fileName.length - 1) {
      return MediaValidationResult.failure(
        error: MediaValidationError.unsupportedFormat,
        message: 'Format media tidak didukung.',
      );
    }
    final extension = fileName.substring(dot + 1).toLowerCase();
    final supported = isVideo
        ? supportedVideoExtensions
        : supportedPhotoExtensions;
    if (!supported.contains(extension)) {
      return MediaValidationResult.failure(
        error: MediaValidationError.unsupportedFormat,
        message:
            'Format ${isVideo ? 'video' : 'foto'} .$extension tidak didukung. Gunakan ${isVideo ? 'MP4' : 'JPG atau PNG'}.',
      );
    }
    final max = isVideo ? maxVideoSizeBytes : maxPhotoSizeBytes;
    if (fileSizeBytes > max) {
      return MediaValidationResult.failure(
        error: MediaValidationError.fileTooLarge,
        message: 'Ukuran file melebihi ${isVideo ? 50 : 10} MB.',
      );
    }
    return const MediaValidationResult.success();
  }
}
