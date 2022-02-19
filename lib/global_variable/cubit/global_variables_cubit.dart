import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/global_variable/cubit/global_variable.dart';
import 'package:overscript/repositories/data_store_repository.dart';

part 'global_variables_state.dart';

class GlobalVariablesCubit extends Cubit<GlobalVariablesState> {
  GlobalVariablesCubit({required DataStoreRepository dataStoreRepository})
      : super(
          GlobalVariablesState(
            dataStoreRepository: dataStoreRepository,
          ),
        );

  void add(GlobalVariable variable) {
    emit(state.changing());
    emit(state.add(variable));
  }

  void delete(GlobalVariable variable) {
    emit(state.changing());
    emit(state.delete(variable));
  }

  void load() {
    emit(state.changing());
    emit(state.load());
  }

  GlobalVariable? getVariable(String uuid) {
    return state.getVariable(uuid);
  }

  void updateValue(GlobalVariable currentValue) {
    emit(state.changing());
    emit(state.update(currentValue));
  }
}
