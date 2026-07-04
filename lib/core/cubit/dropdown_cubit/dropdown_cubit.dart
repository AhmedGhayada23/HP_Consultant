import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/dropdown_cubit/dropdown_state.dart';


class DropdownCubit extends Cubit<DropdownState> {
  DropdownCubit() : super(DropdownState());

  void toggleDropdown() => emit(state.copyWith(isOpened: !state.isOpened));

  void selectValue(String value) => emit(state.copyWith(selectedValue: value, isOpened: false));
}
