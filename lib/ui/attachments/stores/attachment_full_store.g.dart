// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_full_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AttachmentFullStore on _AttachmentFullStore, Store {
  late final _$itemAtom = Atom(
    name: '_AttachmentFullStore.item',
    context: context,
  );

  @override
  AttachmentWithMeta? get item {
    _$itemAtom.reportRead();
    return super.item;
  }

  @override
  set item(AttachmentWithMeta? value) {
    _$itemAtom.reportWrite(value, super.item, () {
      super.item = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_AttachmentFullStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AttachmentFullStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    '_AttachmentFullStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
item: ${item},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
