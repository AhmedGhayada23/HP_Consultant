import 'package:flutter_bloc/flutter_bloc.dart';

class BoxCubit extends Cubit<bool> {
  BoxCubit() : super(false); // false = مغلق في البداية

  void toggle() => emit(!state); // يقلب الحالة
}
