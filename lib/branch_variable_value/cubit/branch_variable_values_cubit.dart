import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/branch_variable_value/cubit/branch_variable_value.dart';
import 'package:overscript/branch_variable_value/views/branch_variable_value_list_item.dart';
import 'package:overscript/repositories/data_store_repository.dart';

part 'branch_variable_values_state.dart';

class BranchVariableValuesCubit extends Cubit<BranchVariableValuesState> {
  BranchVariableValuesCubit() : super(BranchVariableValuesState());

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

  void save(DataStoreRepository dataStoreRepository) {
    emit(state.save(dataStoreRepository));
  }

  BranchVariableValue? getBranchVariableValue(String uuid) {
    return state.getBranchVariableValue(uuid);
  }

  void updateValue(BranchVariableValue currentValue) {
    emit(state.changing());
    emit(state.update(currentValue));
  }

  List<Widget> getVariableListItems(String variableUuid) {
    final result = <Widget>[];
    final variableValues = state.getVariableValues(variableUuid);
    for (final variableValue in variableValues) {
      result.add(BranchVariableValueListItem(branchVariableValue: variableValue));
    }
    return result;
  }

  List<Widget> getBranchListItems(String branchUuid) {
    final result = <Widget>[];
    final variableValues = state.getBranchValues(branchUuid);
    for (final variableValue in variableValues) {
      result.add(BranchVariableValueListItem(branchVariableValue: variableValue));
    }
    return result;
  }
}
