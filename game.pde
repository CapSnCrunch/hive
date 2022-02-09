class Game {
  int scale = 60;
  float angle = 0;
  
  int size = 3;
  int offset = 1;
  PVector center = new PVector(width/2, height/2);
  Bug[][] grid = new Bug[this.size][this.size];
  
  int totalTurns = 0;
  int playerTurn = 0;
  Player[] players = {new Player("w"), new Player("b")};
  
  PVector menuHighlightPosition = new PVector(-50, -50);
  String menuHighlightBug = "queen";
  
  int[] currentBug = null;
  int[][] currentBugValidMoves = null;
  
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
    if (this.currentBug == null){
      highlightHoveredTile();
    } else {
      highlightSelectedTile();
    }
    
    // Show bug tiles and empty tiles
    for(int i = 0; i < this.size; i++){
      for(int j = 0; j < this.size; j++){
        if(this.grid[i][j] != null){
          this.grid[i][j].display(this.center, i - this.offset, j - this.offset, this.scale, this.angle);
        } else if (this.hasNeighbor(i, j)){
          PVector Q = new PVector(1, 0).mult(this.scale);
          PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
          PImage emptyTile = loadImage("bugs/empty.png");
          emptyTile.resize(0, int(this.scale));
          image(emptyTile, Q.x * (i-this.offset) + R.x * (j-this.offset) + this.center.x, Q.y * (i-this.offset) + R.y * (j-this.offset) + this.center.y);
        }
      }
    }
    
    // Show move tiles
    if (currentBugValidMoves != null){
      tint(250, 200, 50);
      for (int m = 0; m < currentBugValidMoves.length; m++){
        PVector Q = new PVector(1, 0).mult(this.scale);
        PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
        PImage emptyTile = loadImage("bugs/empty.png");
        emptyTile.resize(0, int(this.scale));
        int i = currentBugValidMoves[m][0];
        int j = currentBugValidMoves[m][1];
        image(emptyTile, Q.x * (i-this.offset) + R.x * (j-this.offset) + this.center.x, Q.y * (i-this.offset) + R.y * (j-this.offset) + this.center.y);
      }
      noTint();
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
    
    // DEBUG TOOL
    int[] currentHoverPosition = game.getCurrentHoverPosition();
    int i = currentHoverPosition[0];
    int j = currentHoverPosition[1];
    text(str(i) + " " + str(j), 50, 200);
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
      pushMatrix();
      translate(highlightPosition.x, highlightPosition.y);
      rotate(this.angle);
      translate(-highlightPosition.x, -highlightPosition.y);
      ring.resize(0, int(this.scale*1.22));
      image(ring, highlightPosition.x, highlightPosition.y);
      popMatrix();
    } else if (hasNeighbor(i, j)){
      // Display highlighted empty tile
      PImage emptyTile = loadImage("bugs/empty.png");
      pushMatrix();
      translate(highlightPosition.x, highlightPosition.y);
      rotate(this.angle);
      translate(-highlightPosition.x, -highlightPosition.y);
      emptyTile.resize(0, int(this.scale));
      image(emptyTile, highlightPosition.x, highlightPosition.y);
      popMatrix();
    }
  }
  
  void highlightSelectedTile(){
    PVector Q = new PVector(1, 0).mult(this.scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
    
    PVector highlightPosition = this.center.copy();
    highlightPosition = highlightPosition.add(Q.mult(this.currentBug[0] - this.offset));
    highlightPosition = highlightPosition.add(R.mult(this.currentBug[1] - this.offset));
    
    // Display highlight ring around selected bug
    PImage ring = loadImage("bugs/ring.png");
    pushMatrix();
    translate(highlightPosition.x, highlightPosition.y);
    rotate(this.angle);
    translate(-highlightPosition.x, -highlightPosition.y);
    ring.resize(0, int(this.scale*1.22));
    image(ring, highlightPosition.x, highlightPosition.y);
    popMatrix();
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
    boolean hasTeamNeighbor = false;
    for (int k = 0; k < 6; k++){
      if (neighbors[k] != null){
        if (team == "any"){
          return true;
        } else if (neighbors[k].team != team){
          return false;
        } else {
          hasTeamNeighbor = true;
        }
      }
    }
    return hasTeamNeighbor;
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
        this.currentBug = null;
        this.currentBugValidMoves = null;
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
        // Clicking somewhere other than the menu
      } else {
        // Check if empty tile is selected
        if (this.grid[i][j] == null){
          // Check if we need to place a new bug or move a selected bug
          if (currentBug == null){
            // Check if bug is being placed in an empty tile with valid neighbors (or if first bug is being placed for a player)
            if (this.hasValidNeighbor(i, j, this.players[this.playerTurn].team) || this.totalTurns == 0 || (this.totalTurns == 1 && this.hasNeighbor(i,j))){
              if (dist(mouseX, mouseY, this.center.x, this.center.y) < this.scale/2 || this.totalTurns > 0){
                if (game.players[game.playerTurn].bugCounts.get(this.menuHighlightBug) > 0){
                  Bug b = new Bug(game.players[game.playerTurn].team, this.menuHighlightBug);
                  game.players[game.playerTurn].bugCounts.sub(this.menuHighlightBug, 1);
                  game.addBug(b, i-game.offset, j-game.offset);
                  
                  this.turnCleanup();
                }
              }
            }
            // Check if selected bug is being moved
          } else if (this.currentBug != null && (this.hasValidNeighbor(i, j, "any"))){
            this.grid[i][j] = this.grid[this.currentBug[0]][this.currentBug[1]];
            this.grid[this.currentBug[0]][this.currentBug[1]] = null;
              
            this.turnCleanup();
          }
          // Deselect current bug if clicking elsewhere
        } else if (this.grid[i][j] != null){
          //Check if a bug owned by the current player is being selected
          if (this.grid[i][j].team == this.players[this.playerTurn].team){
            this.currentBug = new int[] {i, j};
            this.currentBugValidMoves = null;
            this.menuHighlightPosition = new PVector(-50, -50);
            
            println(grid[i][j].name);
            
            if (grid[i][j].name == "ant"){
              this.currentBugValidMoves = getAntMoves(i, j);
              println("VALID MOVES");
              for(int p = 0; p < this.currentBugValidMoves.length; p++){
                println(this.currentBugValidMoves[p][0], this.currentBugValidMoves[p][1]);
              }
            }
          }
        } 
      }
    }
  }
  
  
    
    
  boolean gridIsConnected(Bug[][] grid){
    // check if every bug has a neighbor (doesn't work since their could be multiple in the disconnected set)
    // Breadth First Search
    //  Start at any bug and add position to a queue
    //  While i < queue.length;
    //   Get neigbors of queue[i]
    //   If !indeciesInArray(index, queue) add their positions to the queue
    //   i += 1
    
    
    return true;
  }
  
  boolean bugIsBlocked(int i, int j){
    // Pseudocode:
    //   Make temp grid without bug at i, j
    //   Check if temp grid is connected
    return true;
  }
  
  int[][] getAntMoves(int i, int j){
    int[][] moves = new int[0][0];
    int[] currentPosition = {i, j};
    int[][] neighborRelativeIndecies = {{0, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, 0}, {-1, 1}};
    
    println("CURRENT POSITION", currentPosition[0], currentPosition[1]);
    
    // Temporarily remove selected bug
    Bug bugHolder = this.grid[i][j];
    this.grid[i][j] = null;
    
    while (true) {
      // Check if any neighbors are valid
      int[] validMove = null;
      for (int n = 0; n < 6; n++){
        
        int di = neighborRelativeIndecies[mod(n-1,6)][0];
        int dj = neighborRelativeIndecies[mod(n-1,6)][1];
        Bug neighborsRightNeighbor = null;
        if (currentPosition[0]+di >= 0 && currentPosition[0]+di < grid.length && currentPosition[1]+dj >= 0 && currentPosition[1]+dj < grid.length){
          neighborsRightNeighbor = grid[currentPosition[0]+di][currentPosition[1]+dj];
        }
        
        int di2 = neighborRelativeIndecies[n][0];
        int dj2 = neighborRelativeIndecies[n][1];
        Bug neighbor = null;
        if (currentPosition[0]+di2 >= 0 && currentPosition[0]+di2 < grid.length && currentPosition[1]+dj2 >= 0 && currentPosition[1]+dj2 < grid.length){
          neighbor = grid[currentPosition[0]+di2][currentPosition[1]+dj2];
        }
        
        int di3 = neighborRelativeIndecies[mod(n+1,6)][0];
        int dj3 = neighborRelativeIndecies[mod(n+1,6)][1];
        Bug neighborsLeftNeighbor = null;
        if (currentPosition[0]+di3 >= 0 && currentPosition[0]+di3 < grid.length && currentPosition[1]+dj3 >= 0 && currentPosition[1]+dj3 < grid.length){
          neighborsLeftNeighbor = grid[currentPosition[0]+di3][currentPosition[1]+dj3];
        }
        
        // DEBUG TOOL
        println(" checking n =", n);
        if (neighborsRightNeighbor != null){
          println("    right  ", currentPosition[0]+di, currentPosition[1]+dj, neighborsRightNeighbor.name);
        } else {
          println("    right  ", currentPosition[0]+di, currentPosition[1]+dj, "null");
        }
        
        if (neighbor != null){
          println("    middle ", currentPosition[0]+di2, currentPosition[1]+dj2, neighbor.name);
        } else {
          println("    middle ", currentPosition[0]+di2, currentPosition[1]+dj2, "null");
        }
        
        if (neighborsLeftNeighbor != null){
          println("    left   ", currentPosition[0]+di3, currentPosition[1]+dj3, neighborsLeftNeighbor.name);
        } else {
          println("    left   ", currentPosition[0]+di3, currentPosition[1]+dj3, "null");
        }
        
        // Check if neighbor is valid (empty, corresponding sides have exactly one neighbor, and not already in moves)
        if (neighbor == null && xor(neighborsLeftNeighbor == null, neighborsRightNeighbor == null)){
          int[] potentialMove = {currentPosition[0]+di2, currentPosition[1]+dj2};
          println("POTENTIAL MOVE FOUND", potentialMove[0], potentialMove[1]);
          if (!indeciesInArray(potentialMove, moves) && !(potentialMove[0] == i && potentialMove[1] == j)){
            println("VALID MOVE FOUND", potentialMove[0], potentialMove[1]);
            validMove = potentialMove;
          }
        }
      }
      
      if (validMove != null){
        println("VALID MOVE TO ADD", validMove[0], validMove[1]);
        
        // Add valid move to the list of moves
        int[][] tempMoves = new int[moves.length+1][2];
        for (int m = 0; m < moves.length; m++){
          tempMoves[m] = moves[m];
        }
        tempMoves[moves.length] = validMove;
        moves = tempMoves;
        
        //println("NEW MOVE LIST");
        //for(int m = 0; m < tempMoves.length; m++){
        //  print("  ", tempMoves[m][0], tempMoves[m][1], " : ");
        //}
        //println();
        
        // Update current position to the newly added move
        currentPosition = validMove;
      } else {
        this.grid[i][j] = bugHolder;
        return moves;
      }
    }
  }
  
  int[][] getQueenMoves(int i, int j){
    return null;
  }
  
  int[][] getSpiderMoves(int i, int j){
    return null;
  }
  
  int[][] getBeetleMoves(int i, int j){
    return null;
  }
  
  int[][] getHopperMoves(int i, int j){
    return null;
  }
  
  int[][] getLadybugMoves(int i, int j){
    return null;
  }
  
  int[][] getPillbugMoves(int i, int j){
    return null;
  }
  
  int[][] getMosquitoMoves(int i, int j){
    return null;
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
  
  void turnCleanup(){
    this.totalTurns += 1;
    this.playerTurn = (this.playerTurn + 1) % this.players.length;
    this.currentBug = null;
    this.currentBugValidMoves = null;
  }
}
