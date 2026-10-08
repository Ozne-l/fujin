// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'review_reason.dart';

class ReviewReasonMapper extends EnumMapper<ReviewReason> {
  ReviewReasonMapper._();

  static ReviewReasonMapper? _instance;
  static ReviewReasonMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReviewReasonMapper._());
    }
    return _instance!;
  }

  static ReviewReason fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ReviewReason decode(dynamic value) {
    switch (value) {
      case r'weightToConfirm':
        return ReviewReason.weightToConfirm;
      case r'newAssociation':
        return ReviewReason.newAssociation;
      case r'noCloseFood':
        return ReviewReason.noCloseFood;
      case r'skipped':
        return ReviewReason.skipped;
      case r'confirmed':
        return ReviewReason.confirmed;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ReviewReason self) {
    switch (self) {
      case ReviewReason.weightToConfirm:
        return r'weightToConfirm';
      case ReviewReason.newAssociation:
        return r'newAssociation';
      case ReviewReason.noCloseFood:
        return r'noCloseFood';
      case ReviewReason.skipped:
        return r'skipped';
      case ReviewReason.confirmed:
        return r'confirmed';
    }
  }
}

extension ReviewReasonMapperExtension on ReviewReason {
  String toValue() {
    ReviewReasonMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ReviewReason>(this) as String;
  }
}

