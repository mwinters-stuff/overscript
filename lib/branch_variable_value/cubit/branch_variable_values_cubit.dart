import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/branch_variable_value/cubit/branch_variable_value.dart';
import 'package:overscript/repositories/data_store_repository.dart';

part 'branch_variable_values_state.dart';

class BranchVariableValuesCubit extends Cubit<BranchVariableValuesState> {
  BranchVariableValuesCubit() : super(BranchVariableValuesState());

  void add(BranchVariableValue branchVariableValue) {
    emit(state.add(branchVariableValue));
  }

  void delete(BranchVariableValue branchVariableValue) {
    emit(state.delete(branchVariableValue));
  }

  void load(DataStoreRepository dataStoreRepository) {
    emit(state.load(dataStoreRepository));
  }

  void save(DataStoreRepository dataStoreRepository) {
    emit(state.save(dataStoreRepository));
  }

  BranchVariableValue? getBranchVariableValue(String uuid) {
    return state.getBranchVariableValue(uuid);
  }
}
