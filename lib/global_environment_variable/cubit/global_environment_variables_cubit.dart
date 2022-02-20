import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overscript/global_environment_variable/cubit/global_environment_variable.dart';
import 'package:overscript/repositories/data_store_repository.dart';

part 'global_environment_variables_state.dart';

class GlobalEnvironmentVariablesCubit extends Cubit<GlobalEnvironmentVariablesState> {
  GlobalEnvironmentVariablesCubit({required DataStoreRepository dataStoreRepository})
      : super(
          GlobalEnvironmentVariablesState(
            dataStoreRepository: dataStoreRepository,
          ),
        );

  void add(GlobalEnvironmentVariable variable) {
    emit(state.changing());
    emit(state.add(variable));
  }

  void delete(GlobalEnvironmentVariable variable) {
    emit(state.changing());
    emit(state.delete(variable));
  }

  void load() {
    emit(state.changing());
    emit(state.load());
  }

  GlobalEnvironmentVariable? getVariable(String uuid) {
    return state.getVariable(uuid);
  }

  void updateValue(GlobalEnvironmentVariable currentValue) {
    emit(state.changing());
    emit(state.update(currentValue));
  }
}
