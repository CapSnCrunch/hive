class Game {
  int size = 3;
  int scale = 60;
  int offset = 1;
  PVector center = new PVector(width/2, height/2);
  Bug[][] grid = new Bug[this.size][this.size];
  
  int totalTurns = 0;
  int playerTurn = 0;
  Player[] players = {new Player("w"), new Player("b")};
  
  PVector menuHighlightPosition = new PVector(-50, -50);
  String menuHighlightBug = "queen";
  
  Game(){
  }
  
  void display(){
    // Show starter text
    if (this.totalTurns < 1){
      fill(30);
      PFont font = createFont("Bell MT Bold", 20);
      textFont(font);
      text("Place a bug here to start the game", 130, 300);
      
      PImage emptyTile = loadImage("bugs/empty.png");
      emptyTile.resize(0, int(this.scale));
      image(emptyTile, this.center.x, this.center.y);
      if (dist(mouseX, mouseY, this.center.x, this.center.y) < this.scale/2){
        image(emptyTile, this.center.x, this.center.y);
      }
    }
    
    // Show currently highlighted tile
    highlightHoveredTile();
    
    // Show bug tiles and empty tiles
    for(int i = 0; i < this.size; i++){
      for(int j = 0; j < this.size; j++){
        if(this.grid[i][j] != null){
          this.grid[i][j].display(this.center, i - this.offset, j - this.offset, this.scale);
        } else if (this.hasNeighbor(i, j)){
          PVector Q = new PVector(1, 0).mult(this.scale);
          PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
          PImage emptyTile = loadImage("bugs/empty.png");
          emptyTile.resize(0, int(this.scale));
          image(emptyTile, Q.x * (i-this.offset) + R.x * (j-this.offset) + this.center.x, Q.y * (i-this.offset) + R.y * (j-this.offset) + this.center.y);
        }
      }
    }
    
    // Show player menu
    fill(120, 110, 100);
    rect(0, 0, width, 130);
    
    PImage menuHighlight = loadImage("bugs/empty.png");
    menuHighlight.resize(0, 80);
    image(menuHighlight, this.menuHighlightPosition.x, this.menuHighlightPosition.y);
    
    PImage queen = loadImage("bugs/"+this.players[this.playerTurn].team+"-queen.png");
    PImage ant = loadImage("bugs/"+this.players[this.playerTurn].team+"-ant.png");
    PImage spider = loadImage("bugs/"+this.players[this.playerTurn].team+"-spider.png");
    PImage beetle = loadImage("bugs/"+this.players[this.playerTurn].team+"-beetle.png");
    PImage hopper = loadImage("bugs/"+this.players[this.playerTurn].team+"-hopper.png");
    PImage ladybug = loadImage("bugs/"+this.players[this.playerTurn].team+"-ladybug.png");
    PImage pillbug = loadImage("bugs/"+this.players[this.playerTurn].team+"-pillbug.png");
    PImage mosquito = loadImage("bugs/"+this.players[this.playerTurn].team+"-mosquito.png");
    
    queen.resize(0, 50);
    ant.resize(0, 50);
    spider.resize(0, 50);
    beetle.resize(0, 50);
    hopper.resize(0, 50);
    ladybug.resize(0, 50);
    pillbug.resize(0, 50);
    mosquito.resize(0, 50);
    
    fill(30);
    PFont font = createFont("Bell MT Bold", 30);
    textFont(font);
    
    image(queen, 40, 90);
    image(ant, 70, 40);
    text("x " + str(this.players[this.playerTurn].bugCounts.get("queen")), 85, 95);
    text("x " + str(this.players[this.playerTurn].bugCounts.get("ant")), 115, 45);
    
    image(spider, 170, 90);
    image(beetle, 200, 40);
    text("x " + str(this.players[this.playerTurn].bugCounts.get("spider")), 215, 95);
    text("x " + str(this.players[this.playerTurn].bugCounts.get("beetle")), 245, 45);
    
    image(hopper, 300, 90);
    image(ladybug, 330, 40);
    text("x " + str(this.players[this.playerTurn].bugCounts.get("hopper")), 345, 95);
    text("x " + str(this.players[this.playerTurn].bugCounts.get("ladybug")), 375, 45);
    
    image(pillbug, 440, 90);
    image(mosquito, 470, 40);
    text("x " + str(this.players[this.playerTurn].bugCounts.get("pillbug")), 475, 95);
    text("x " + str(this.players[this.playerTurn].bugCounts.get("mosquito")), 505, 45);
  }
  
  int[] getCurrentHoverPosition(){
    PVector Q = new PVector(1, 0).mult(this.scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
    for(int i = 0; i < this.size; i++){
      for(int j = 0; j < this.size; j++){
        PVector cellPosition = this.center.copy();
        if(dist(mouseX, mouseY, cellPosition.x + Q.x*(i-this.offset) + R.x*(j-this.offset), cellPosition.y + Q.y*(i-this.offset) + R.y*(j-this.offset)) < this.scale/2){
          int[] hoverPosition = {i, j};
          return hoverPosition;
        }
      }
    }
    int[] hoverPosition = {0, 0};
    return hoverPosition;
  }
  
  void highlightHoveredTile(){
    int[] currentHoverPosition = this.getCurrentHoverPosition();
    int i = currentHoverPosition[0];
    int j = currentHoverPosition[1];
    
    PVector Q = new PVector(1, 0).mult(this.scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
  
    PVector highlightPosition = this.center.copy();
    highlightPosition = highlightPosition.add(Q.mult(i - this.offset));
    highlightPosition = highlightPosition.add(R.mult(j - this.offset));
    
    if(this.grid[i][j] != null){
      // Display highlight ring around bug
      PImage ring = loadImage("bugs/ring.png");
      ring.resize(0, int(this.scale*1.22));
      image(ring, highlightPosition.x, highlightPosition.y);
    } else if (hasNeighbor(i, j)){
      // Display highlighted empty tile
      PImage emptyTile = loadImage("bugs/empty.png");
      emptyTile.resize(0, int(this.scale));
      image(emptyTile, highlightPosition.x, highlightPosition.y);
    }
  }
  
  Bug[] getNeighbors(int i, int j){
    Bug[] neighbors = new Bug[6];
    
    if (j+1 < this.size){ neighbors[0] = this.grid[i][j+1]; }
    if (i+1 < this.size){ neighbors[1] = this.grid[i+1][j]; }
    if (i+1 < this.size && j-1 > 0){ neighbors[2] = this.grid[i+1][j-1]; }
    if (j-1 > 0){ neighbors[3] = this.grid[i][j-1]; }
    if (i-1 > 0){ neighbors[4] = this.grid[i-1][j]; }
    if (i-1 > 0 && j+1 < this.size){ neighbors[5] = this.grid[i-1][j+1]; }
    
    return neighbors;
  }
  
  boolean hasNeighbor(int i, int j){
    Bug[] neighbors = this.getNeighbors(i, j);
    for (int k = 0; k < 6; k++){
      if (neighbors[k] != null){
        return true;
      }
    }
    return false;
  }
  
  boolean hasValidNeighbor(int i, int j, String team){
    Bug[] neighbors = this.getNeighbors(i, j);
    for (int k = 0; k < 6; k++){
      if (neighbors[k] != null){
        if (neighbors[k].team == team){
          return true;
        }
      }
    }
    return false;
  }
  
  void checkForActions(){
    // Check if current bug highlight has no remaining bugs
    if (game.players[game.playerTurn].bugCounts.get(this.menuHighlightBug) == 0){
      menuHighlightPosition = new PVector(-50, -50);
    }
    
    // Check for menu highlight change, bug placement, etc.
    if (mousePressed == true){
      int[] currentHoverPosition = game.getCurrentHoverPosition();
      int i = currentHoverPosition[0];
      int j = currentHoverPosition[1];
      
      // Check for menu highlight change
      if (mouseY < 120){
        if (dist(mouseX, mouseY, 40, 90) < 30){
          this.menuHighlightPosition = new PVector(40, 90);
          this.menuHighlightBug = "queen";
        }
        if (dist(mouseX, mouseY, 70, 40) < 30){
          this.menuHighlightPosition = new PVector(70, 40);
          this.menuHighlightBug = "ant";
        }
        if (dist(mouseX, mouseY, 170, 90) < 30){
          this.menuHighlightPosition = new PVector(170, 90);
          this.menuHighlightBug = "spider";
        }
        if (dist(mouseX, mouseY, 200, 40) < 30){
          this.menuHighlightPosition = new PVector(200, 40);
          this.menuHighlightBug = "beetle";
        }
        if (dist(mouseX, mouseY, 300, 90) < 30){
          this.menuHighlightPosition = new PVector(300, 90);
          this.menuHighlightBug = "hopper";
        }
        if (dist(mouseX, mouseY, 330, 40) < 30){
          this.menuHighlightPosition = new PVector(330, 40);
          this.menuHighlightBug = "ladybug";
        }
        if (dist(mouseX, mouseY, 440, 90) < 30){
          this.menuHighlightPosition = new PVector(440, 90);
          this.menuHighlightBug = "pillbug";
        }
        if (dist(mouseX, mouseY, 470, 40) < 30){
          this.menuHighlightPosition = new PVector(470, 40);
          this.menuHighlightBug = "mosquito";
        }
      } else {
        // Check if bug is being placed in an empty tile with valid neighbors (or if first bug is being placed for a player)
        if (this.grid[i][j] == null && (this.hasValidNeighbor(i, j, this.players[this.playerTurn].team) || this.totalTurns < 2)){
          if (this.totalTurns > 0 || dist(mouseX, mouseY, this.center.x, this.center.y) < this.scale/2){
            if (game.players[game.playerTurn].bugCounts.get(this.menuHighlightBug) > 0){
              Bug b = new Bug(game.players[game.playerTurn].team, this.menuHighlightBug);
              game.players[game.playerTurn].bugCounts.sub(this.menuHighlightBug, 1);
              game.playerTurn = (game.playerTurn + 1) % game.players.length;
              game.addBug(b, i-game.offset, j-game.offset);
              this.totalTurns += 1;
            }
          }
        }
      }
    }
  }
  
  void addBug(Bug bug, int q, int r){
    //println("adding bug at", q+this.offset, r+this.offset);
    this.grid[q + this.offset][r + this.offset] = bug;
    if (q + this.offset == 0 || r + this.offset == 0 || q + this.offset + 1 == this.size || r + this.offset + 1 == this.size){
      Bug[][] tempGrid = new Bug[this.size + 2][this.size + 2];
      for (int i = 0; i < this.size; i++){
        for (int j = 0; j < this.size; j++){
          tempGrid[i+1][j+1] = this.grid[i][j];
        }
      }
      this.grid = tempGrid;
      this.size = this.size + 2;
      this.offset += 1;
    }
  }
}
