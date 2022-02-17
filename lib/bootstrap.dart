// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file/local.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:overscript/branch_variable/branch_variable.dart';
import 'package:overscript/branch_variable_value/cubit/branch_variable_values_cubit.dart';
import 'package:overscript/gitbranch/gitbranch.dart';
import 'package:overscript/repositories/repositories.dart';
import 'package:overscript/theme/theme.dart';
import 'package:process/process.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final storage = await HydratedStorage.build(
    storageDirectory: Directory.systemTemp,
  );

  await runZonedGuarded(
    () async {
      await HydratedBlocOverrides.runZoned(
        () async => runApp(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<DataStoreRepository>(
                create: (context) => DataStoreRepository(const LocalFileSystem()),
              ),
              RepositoryProvider<GitCalls>(create: (context) => GitCalls(const LocalProcessManager())),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider<GitBranchesCubit>(
                  create: (context) => GitBranchesCubit(dataStoreRepository: context.read<DataStoreRepository>()),
                ),
                BlocProvider<BranchVariablesCubit>(
                  create: (context) => BranchVariablesCubit(dataStoreRepository: context.read<DataStoreRepository>()),
                ),
                BlocProvider<BranchVariableValuesCubit>(
                  create: (context) => BranchVariableValuesCubit(dataStoreRepository: context.read<DataStoreRepository>()),
                ),
                BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
              ],
              child: await builder(),
            ),
          ),
        ),
        storage: storage,
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
