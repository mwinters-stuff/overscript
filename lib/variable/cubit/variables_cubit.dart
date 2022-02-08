import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/repositories/data_store_repository.dart';
import 'package:overscript/variable/cubit/variable.dart';

part 'variables_state.dart';

class VariablesCubit extends Cubit<VariablesState> {
  VariablesCubit() : super(VariablesState());

  void add(Variable variable) {
    emit(state.changing());
    emit(state.add(variable));
  }

  void delete(Variable variable) {
    emit(state.changing());
    emit(state.delete(variable));
  }

  void load(DataStoreRepository dataStoreRepository) {
    emit(state.changing());
    emit(state.load(dataStoreRepository));
  }

  void save(DataStoreRepository dataStoreRepository) {
    emit(state.changing());
    emit(state.save(dataStoreRepository));
  }

  Variable? getVariable(String uuid) {
    return state.getVariable(uuid);
  }
}
