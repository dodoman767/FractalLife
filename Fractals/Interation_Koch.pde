class Piece {

  PVector vecA;
  PVector vecB;
  int currentAge;

  Piece(PVector vec1, PVector vec2, int age) {
    vecA =  vec1.copy();
    vecB =  vec2.copy();
    currentAge = age;
  }

  void show() {
    stroke(250);
    line(vecA.x, vecA.y, vecB.x, vecB.y);
  }

  Piece[] iterate() {

    Piece[] children = new Piece[4];

    PVector vecO = PVector.sub(vecB, vecA);
    vecO.div(3);
    PVector vecB_, vecA_;

      vecB_ = PVector.add(vecA, vecO);
      vecA_ = PVector.sub(vecB, vecO);
      
    children[0] = new Piece(vecA, vecB_, currentAge + 1);
    children[3] = new Piece(vecA_, vecB, currentAge + 1);
    vecO.rotate(angle);
    PVector vecC = PVector.add(vecB_, vecO);

    children[1] = new Piece(vecB_, vecC, currentAge + 1);
    children[2] = new Piece(vecC, vecA_, currentAge + 1);
    return children;
  }
}
