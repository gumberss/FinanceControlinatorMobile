extension ImmutableExtensions<E> on List<E> {
  List<E> sortedBy(Comparable Function(E e) key) =>
      toList()..sort((a, b) => key(a).compareTo(key(b)));
}
