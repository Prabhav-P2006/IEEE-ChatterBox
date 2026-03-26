abstract class Failure {
  final String message;
  const Failure(this.message);
}

class MeshFailure extends Failure {
  const MeshFailure(String message) : super(message);
}
