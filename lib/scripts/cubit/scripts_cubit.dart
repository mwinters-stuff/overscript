import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/repositories/data_store_repository.dart';
import 'package:overscript/scripts/cubit/script.dart';

part 'scripts_state.dart';

class ScriptsCubit extends Cubit<ScriptsState> {
  ScriptsCubit({required DataStoreRepository dataStoreRepository})
      : super(
          ScriptsState(
            dataStoreRepository: dataStoreRepository,
          ),
        );

  void add(Script variable) {
    emit(state.changing());
    emit(state.add(variable));
  }

  void delete(Script variable) {
    emit(state.changing());
    emit(state.delete(variable));
  }

  void load() {
    emit(state.changing());
    emit(state.load());
  }

  Script? get(String uuid) {
    return state.get(uuid);
  }

  void update(Script currentValue) {
    emit(state.changing());
    emit(state.update(currentValue));
  }
}
