Game game = new Game();
PVector initialPress = new PVector(width/2, height/2);

void setup(){
  size(500, 500);
  imageMode(CENTER);
  
  game.center = new PVector(width/2, height/2);
  
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
  initialPress = new PVector(mouseX, mouseY);
  
  int[] currentHoverPosition = game.getCurrentHoverPosition();
  int i = currentHoverPosition[0];
  int j = currentHoverPosition[1];
  if (game.grid[i][j] == null && game.hasNeighbor(i, j)){
    Bug b = new Bug(game.players[game.turn].team, "ant");
    game.turn = (game.turn + 1) % 2;
    game.addBug(b, i-game.offset, j-game.offset);
  }
}

void mouseDragged(){
  game.center = new PVector(game.center.x + mouseX - initialPress.x, game.center.y + mouseY - initialPress.y);
  initialPress = new PVector(mouseX, mouseY);
}
