import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Executor/events_Execution.dart';
import 'package:sshtm/Executor/object_Job.dart';
import 'package:sshtm/Executor/state_Execution.dart';

class bloc_Execution extends Bloc<ExecutionEvent, ExecutionState> {
  
  factory bloc_Execution() => bloc_Execution._( <Job> [] );//, StreamController<ExecutionEvent>.broadcast() );
  /*bloc_Execution._(this._joblist, this._streamController) :
      eventStream = _streamController.stream,  super (EmptyQueueExecutionState([])) {
        on<ExecutionEvent>((event, yield) {
          _eventHandler(event, yield);
        });
      }
  */

  final _eventController = StreamController<ExecutionEvent>.broadcast();
  Stream<ExecutionEvent> get eventStream => _eventController.stream;

  bloc_Execution._(this._joblist) : super (EmptyQueueExecutionState([])) {
    on<ExecutionEvent> ((event, emit){
      _eventHandler(event, emit);
    });
  }

  final List<Job> _joblist;
  //final StreamController<ExecutionEvent> _streamController;
  
  //final Stream<ExecutionEvent> eventStream;
  //StreamSink<ExecutionEvent> get eventStreamSink => _streamController.sink;

  void _eventHandler (ExecutionEvent event, Emitter<ExecutionState> emit) {
    _eventController.sink.add(event);
    if (event is JobEnqueued_ExecutionEvent){
      
      print ("A job started");
      _joblist.add(event.job);
      emit(RunningExecutionState(_joblist));
    }
    if (event is JobReturned_ExecutionEvent) {
      

      _joblist.remove(event.job);
      int c=event.exitCode;
      print("A code exited with code $c");
      if(_joblist.isEmpty) {
        emit (EmptyQueueExecutionState(_joblist));
      }else{
        emit (RunningExecutionState(_joblist));
      }
    }
  }
  
  @override
  Future<void> close() async {
    await _eventController.close();
    super.close();
  }

}