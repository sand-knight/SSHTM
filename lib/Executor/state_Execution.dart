import 'package:sshtm/Executor/object_Job.dart';

abstract class ExecutionState {
  final List<Job> _queue;

  List<Job> get list => _queue;
  int get size => _queue.length;

  const ExecutionState(this._queue);
}

class RunningExecutionState extends ExecutionState {
  RunningExecutionState (List<Job> list) : super(list);
  
}

class EptyQueueExecutionState extends ExecutionState{
  EptyQueueExecutionState (List<Job> list) : super(list);
}