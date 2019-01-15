
import controlP5.*;

//////////////////////////////////////////
//
// Space to next iteration backspace reset
//
// Tim Cao's Fractal Game of Life
//
//////////////////////////////////////////

ArrayList<Piece> Pieces;
ControlP5 cp5;
ControlP5 cp1;
int ANGLE = 500;
int babySize = 500;
Button reset_button;
Button next_button;
float angle = PI/3;
int[] populations = new int[100];

void setup() {
  size(970, 720);

  for (int i = 0; i<100; i++)
  {
    populations[i] = 2;
  }
  //Sliders
  cp5 = new ControlP5(this);
  cp5.addSlider("ANGLE").setPosition(800, 600).setRange(0, 4*PI);
  cp1 = new ControlP5(this);
  cp1.addSlider("BabySize").setPosition(800, 650).setRange(0, 100);

 //Beginning Vectors
  PVector a = new PVector(random(80, 860), random(50, 500));
  PVector b = new PVector(random(80, 860), random(50, 500));
  PVector c = new PVector(random(80, 860), random(50, 500));
  PVector d = new PVector(random(80, 860), random(50, 500));
  PVector e = new PVector(random(80, 860), random(50, 500));
  PVector f = new PVector(random(80, 860), random(50, 500));
  Pieces = new ArrayList<Piece>();

  // Form irregular Hexagon
  Piece side_1 = new Piece(a, b, 0);
  Piece side_2 = new Piece(b, c, 0);
  Piece side_3 = new Piece(c, d, 0);
  Piece side_4 = new Piece(d, e, 0);
  Piece side_5 = new Piece(e, f, 0);
  Piece side_6 = new Piece(f, a, 0);
  Pieces.add(side_1);
  Pieces.add(side_2);
  Pieces.add(side_3);
  Pieces.add(side_4);
  Pieces.add(side_5);
  Pieces.add(side_6);
  
  reset_button = new Button("RESET", 50, 580, 100, 100);
}

boolean ready = false;
float temp_x = 0;
float temp_y = 0;
int counter = 0;

void join (Piece[] arr, ArrayList<Piece> list) {
  for (Piece side : arr) {
    counter++;
    //Natural selection: Sizes must be > 2, and must not exit deticated area
    if (dist(side.vecA.x, side.vecA.y, side.vecB.x, side.vecB.y) > 2 &&
      side.vecA.x > 40 && side.vecA.y > 10 && side.vecB.x > 40 && side.vecB.y > 10 &&
      side.vecA.x < 920 && side.vecA.y < 540 && side.vecB.x <920 && side.vecB.y < 540
      && side.vecA.x*side.vecA.y < 160000)
    {
      //Population overgrowth: dramatically reduces population if pop size is > 10000
      if (Pieces.size() < 20000 || sqrt(Pieces.size()) > random(0, Pieces.size()/2)) {
        list.add(side);
        if (counter % 5 == 0)
        {
          if (!ready)
          {
            ready = true ;
            temp_x = side.vecA.x;
            temp_y = side.vecA.y;
          } else
            ready = false;
          if (dist (temp_x, temp_y, side.vecA.x, side.vecA.y) < 150 ||
            dist (temp_x, temp_y, side.vecA.x, side.vecA.y) > 300) 
          {
            if (true)
            {
              list.add(new Piece ((new PVector(temp_x, temp_y)), 
                (new PVector(side.vecA.x, side.vecA.y)), 
                0));
            }
          }
        }
      }
    } else
    {
      side = null;
    }
  }
}

void keyPressed() 
{
  if (keyCode == ' ')
  {
    ArrayList<Piece> nextGeneration = new ArrayList<Piece>();
    updateGraph();
    for (Piece side : Pieces) {
      Piece[] children = side.iterate();
      join(children, nextGeneration);
    }
    Pieces = nextGeneration;
  }
  if (keyCode == BACKSPACE)
  {
    setup();
  }
}

void mouseReleased() {
  if (reset_button.MouseIsOver()) 
  {
    setup();
  }
}

void draw() {
  fill(22, 14, 89);
  background(15, 15, 15);
  rect(40, 10, 880, 540);
  reset_button.Draw();
  fill(22, 140, 89);
  text("Population: " + Pieces.size(), 840, 700);
  text("FPS: " + round(frameRate), 840, 680);
  for (Piece side : Pieces) 
  {
    side.show();
  }
  fill(22, 14, 89);
  float w = (float) width/populations.length/2;
  for (int i=0; i<populations.length; i++) {
    float h = populations[i]/40; 
    fill(150 - h/4, h/2, 125 + h);
    rect(i*w+width/4, height-h, w, h);
  }
}

void updateGraph()
{
  for (int i = 99; i > 0; i--)
  {
    populations[i] = populations[i-1] ;
  }
  populations[0] = Pieces.size();
}
