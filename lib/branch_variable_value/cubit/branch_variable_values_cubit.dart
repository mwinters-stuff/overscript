import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/branch_variable_value/branch_variable_value.dart';
import 'package:overscript/repositories/data_store_repository.dart';

part 'branch_variable_values_state.dart';

class BranchVariableValuesCubit extends Cubit<BranchVariableValuesState> {
  BranchVariableValuesCubit({required DataStoreRepository dataStoreRepository})
      : super(BranchVariableValuesState(
          dataStoreRepository: dataStoreRepository,
        ));

  void add(BranchVariableValue branchVariableValue) {
    emit(state.changing());
    emit(state.add(branchVariableValue));
  }

  void delete(BranchVariableValue branchVariableValue) {
    emit(state.changing());
    emit(state.delete(branchVariableValue));
  }

  void load(DataStoreRepository dataStoreRepository) {
    emit(state.changing());
    emit(state.load(dataStoreRepository));
  }

  BranchVariableValue? getBranchVariableValue(String uuid) {
    return state.getBranchVariableValue(uuid);
  }

  void updateValue(BranchVariableValue currentValue) {
    emit(state.changing());
    emit(state.update(currentValue));
  }

  List<BranchVariableValueListItem> getVariableListItems(String variableUuid) {
    final result = <BranchVariableValueListItem>[];
    final variableValues = state.getVariableValues(variableUuid);
    for (final variableValue in variableValues) {
      result.add(BranchVariableValueListItem(branchVariableValue: variableValue));
    }
    return result;
  }

  List<VariableBranchValueListItem> getBranchListItems(String branchUuid) {
    final result = <VariableBranchValueListItem>[];
    final variableValues = state.getBranchValues(branchUuid);
    for (final variableValue in variableValues) {
      result.add(VariableBranchValueListItem(branchVariableValue: variableValue));
    }
    return result;
  }
}
