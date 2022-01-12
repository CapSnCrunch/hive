Game game = new Game();
PVector initialPress = new PVector(width/2, height/2);

void setup(){
  size(550, 600);
  imageMode(CENTER);
  noStroke();
  
  game.center = new PVector(width/2, (height+100)/2);
}

void draw(){
  background(150, 140, 130);
  game.display();
  game.checkForActions();
}

void mousePressed(){
  if (game.totalTurns > 0 && mouseY > 120){
    initialPress = new PVector(mouseX, mouseY);
  }
}

void mouseDragged(){
  if (game.totalTurns > 0 && mouseY > 120){
    game.center = new PVector(game.center.x + mouseX - initialPress.x, game.center.y + mouseY - initialPress.y);
    initialPress = new PVector(mouseX, mouseY);
  }
}
