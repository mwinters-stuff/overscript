import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/repositories/data_store_repository.dart';
import 'package:overscript/branch_variable/cubit/branch_variable.dart';

part 'branch_variables_state.dart';

class BranchVariablesCubit extends Cubit<BranchVariablesState> {
  BranchVariablesCubit({required DataStoreRepository dataStoreRepository})
      : super(
          BranchVariablesState(
            dataStoreRepository: dataStoreRepository,
          ),
        );

  void add(BranchVariable variable) {
    emit(state.changing());
    emit(state.add(variable));
  }

  void delete(BranchVariable variable) {
    emit(state.changing());
    emit(state.delete(variable));
  }

  void load() {
    emit(state.changing());
    emit(state.load());
  }

  BranchVariable? getVariable(String uuid) {
    return state.getVariable(uuid);
  }
}
