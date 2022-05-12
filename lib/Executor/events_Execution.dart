import 'package:sshtm/Executor/object_Job.dart';

abstract class ExecutionEvent {
  final Job _job;
  int? _exitCode;

  Job get job => _job;

  ExecutionEvent(this._job, this._exitCode);
}

class JobReturned_ExecutionEvent extends ExecutionEvent{
  
  int get exitCode => _exitCode!;

  JobReturned_ExecutionEvent(Job job, int exitCode) : super(job, exitCode);
}

class JobEnqueued_ExecutionEvent extends ExecutionEvent{

  JobEnqueued_ExecutionEvent(Job job) : super(job, null);
}