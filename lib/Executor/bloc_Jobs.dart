import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Executor/events_Execution.dart';
import 'package:sshtm/Executor/object_Job.dart';
import 'package:sshtm/Executor/state_Execution.dart';

class bloc_Execution extends Bloc<ExecutionEvent, ExecutionState> {
  
  factory bloc_Execution() => bloc_Execution._( <Job> [] , StreamController<ExecutionEvent>.broadcast() );
  bloc_Execution._(this._joblist, this._streamController) :
      eventStream = _streamController.stream,  super (EptyQueueExecutionState([])) {
        on<ExecutionEvent>((event, yield) {
          _eventHandler(event, yield);
        });
      }

  final List<Job> _joblist;
  final StreamController<ExecutionEvent> _streamController;
  
  final Stream<ExecutionEvent> eventStream;
  StreamSink<ExecutionEvent> get eventStreamSink => _streamController.sink;

  Stream<ExecutionState> _eventHandler (ExecutionEvent event, Emitter<ExecutionState> yield) async* {
    if (event is JobEnqueued_ExecutionEvent){
      
      _joblist.add(event.job);
      yield RunningExecutionState(_joblist);
    }
    if (event is JobReturned_ExecutionEvent) {
      

      _joblist.remove(event.job);

      if(_joblist.isEmpty) {
        yield (EptyQueueExecutionState(_joblist));
      }else{
        yield (RunningExecutionState(_joblist));
      }
    }
  }
  


}