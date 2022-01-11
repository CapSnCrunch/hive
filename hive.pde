Game game = new Game();

void setup(){
  size(500, 500);
  imageMode(CENTER);
  
  Bug b = new Bug("w", "queen");
  
  game.addBug(b, 0, 0);
}

void draw(){
  background(150, 140, 130);
  game.display();
  int[] currentHoverPosition = game.getCurrentHoverPosition();
  int i = currentHoverPosition[0];
  int j = currentHoverPosition[1];
}

void mousePressed(){
  int[] currentHoverPosition = game.getCurrentHoverPosition();
  int i = currentHoverPosition[0];
  int j = currentHoverPosition[1];
  if (game.grid[i][j] == null){
    Bug b = new Bug("w", "ant");
    game.addBug(b, i-game.offset, j-game.offset);
  }
}
