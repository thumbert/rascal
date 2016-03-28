library collection.tree;

/// I never find a tree structure useful!


/// A Tree data structure implemented in Dart

class Node<T> {
  T data;
  Node<T> parent;
  List<Node<T>> children;

  Node(this.data, this.parent, this.children);

  bool isLeaf() => children.isEmpty;
  bool isRoot() => parent == null;
}



