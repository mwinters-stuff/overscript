import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/repositories/data_store_repository.dart';
import 'package:overscript/shells/cubit/shell.dart';

part 'shells_state.dart';

class ShellsCubit extends Cubit<ShellsState> {
  ShellsCubit({required DataStoreRepository dataStoreRepository})
      : super(
          ShellsState(
            dataStoreRepository: dataStoreRepository,
          ),
        );

  void add(Shell variable) {
    emit(state.changing());
    emit(state.add(variable));
  }

  void delete(Shell variable) {
    emit(state.changing());
    emit(state.delete(variable));
  }

  void load() {
    emit(state.changing());
    emit(state.load());
  }

  Shell? get(String uuid) {
    return state.get(uuid);
  }

  void updateArgs(Shell currentValue) {
    emit(state.changing());
    emit(state.update(currentValue));
  }
}
