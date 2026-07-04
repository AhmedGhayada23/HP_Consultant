class DropdownState {
  final bool isOpened;
  final String selectedValue;

  DropdownState({this.isOpened = false, this.selectedValue = ''});

  DropdownState copyWith({bool? isOpened, String? selectedValue}) {
    return DropdownState(
      isOpened: isOpened ?? this.isOpened,
      selectedValue: selectedValue ?? this.selectedValue,
    );
  }
}
