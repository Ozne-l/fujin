enum CropHandle {
  topLeft(horizontal: -1, vertical: -1),
  top(horizontal: 0, vertical: -1),
  topRight(horizontal: 1, vertical: -1),
  right(horizontal: 1, vertical: 0),
  bottomRight(horizontal: 1, vertical: 1),
  bottom(horizontal: 0, vertical: 1),
  bottomLeft(horizontal: -1, vertical: 1),
  left(horizontal: -1, vertical: 0),
  inside(horizontal: 0, vertical: 0);

  const CropHandle({required this.horizontal, required this.vertical});

  final int horizontal;
  final int vertical;

  bool get isCorner => horizontal != 0 && vertical != 0;
}
