import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/gitbranch/cubit/gitbranch.dart';
import 'package:overscript/repositories/data_store_repository.dart';

part 'gitbranches_state.dart';

class GitBranchesCubit extends Cubit<GitBranchesState> {
  GitBranchesCubit() : super(GitBranchesState());

  void add(GitBranch branch) {
    emit(state.add(branch));
  }

  void delete(GitBranch branch) {
    emit(state.delete(branch));
  }

  void load(DataStoreRepository dataStoreRepository) {
    emit(state.load(dataStoreRepository));
  }

  void save(DataStoreRepository dataStoreRepository) {
    emit(state.save(dataStoreRepository));
  }

  GitBranch? getBranch(String uuid) {
    return state.getBranch(uuid);
  }
}
