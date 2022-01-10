Game game = new Game();

void setup(){
  size(500, 500);
  imageMode(CENTER);
  //ellipseMode(CENTER);
  
  Bug q = new Bug(0, 0, "w", "queen");
  Bug q2 = new Bug(0, 1, "b", "queen");
  Bug b1 = new Bug(1, 0, "w", "hopper");
  Bug b2 = new Bug(2, 0, "w", "spider");
  Bug b3 = new Bug(0, -1, "w", "ladybug");
  Bug b4 = new Bug(-1, 0, "b", "beetle");
  Bug b5 = new Bug(-1, 1, "b", "mosquito");
  
  game.addBug(q);
  game.addBug(q2);
  game.addBug(b1);
  game.addBug(b2);
  game.addBug(b3);
  game.addBug(b4);
  game.addBug(b5);
  game.setScale(60);
  
}

void draw(){
  background(150, 140, 130);
  game.display();
  game.setScale(60);
}

void mousePressed(){
  int[] currentHoverPosition = game.getCurrentHoverPosition();
  int i = currentHoverPosition[0];
  int j = currentHoverPosition[1];
  if (game.grid[i][j] == null){
    Bug b = new Bug(i-3, j-3, "w", "ant");
    game.addBug(b);
  }
}
