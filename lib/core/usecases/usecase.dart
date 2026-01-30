import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

abstract class UseCase<TypeR, Params> {
  Future<Either<Failure, TypeR>> call(Params params);
}

class NoParams {}
