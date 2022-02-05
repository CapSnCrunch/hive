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

int mod(int a, int b){
  return (a%b + b) % b;
}

boolean xor(boolean a, boolean b){
  return ((a && !b) || (!a && b));
}

boolean indeciesInArray(int[] indecies, int[][] array){
  for (int i = 0; i < array.length; i++){
    if (indecies[0] == array[i][0] && indecies[1] == array[i][1]){
      return true;
    }
  }
  return false;
}

float easeFunction(float x, float a, float b, float c, float d){
  return d / (1 + exp(-c*(x-a))) + d / (1 + exp(-c*(x-b)));
};

void mouseWheel(MouseEvent event){
  
  // Positive when scrolling up, negative when scrolling down
  float e = event.getCount();
  println(e, game.scale);
  if (e > 0 && game.scale > 30){
    game.scale -= easeFunction(game.scale, 30, 100, 0.2, 2);
  }
  if (e < 0 && game.scale < 100){
    game.scale += easeFunction(game.scale, 30, 100, 0.2, 2);
  }
}
