class Game {
  int size = 10;
  int scale = 60;
  Bug[][] grid = new Bug[this.size][this.size];
  Bug[] whiteBugs = new Bug[0];
  Bug[] blackBugs = new Bug[0];
  PVector highlightPosition = new PVector(width/2, height/2);
  Game(){
  }
  
  void display(){
    
    this.highlight();
    // Display bugs and empty tiles
    for(int i = 0; i < this.size; i++){
      for(int j = 0; j < this.size; j++){
        if(this.grid[i][j] != null){
          this.grid[i][j].display();
        } else if (i-1 >= 0 && j-1 >= 0 && i+1 < this.size && j+1 < this.size){
          if(this.grid[i-1][j] != null || this.grid[i+1][j] != null || this.grid[i][j-1] != null || this.grid[i][j+1] != null || this.grid[i+1][j-1] != null || this.grid[i-1][j+1] != null){
            PVector Q = new PVector(1, 0).mult(this.scale);
            PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
            PVector pos = new PVector(width/2, height/2);
            pos = pos.add(Q.mult(i-3));
            pos = pos.add(R.mult(j-3));
            
            PImage emptyTile = loadImage("bugs/empty.png");
            emptyTile.resize(0, int(this.scale));
            image(emptyTile, pos.x, pos.y);
          }
        }
      }
    }
  }
  
  int[] getCurrentHoverPosition(){
    PVector Q = new PVector(1, 0).mult(this.scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
    for(int i = 0; i < this.size; i++){
      for(int j = 0; j < this.size; j++){
        PVector cellPosition = new PVector(width/2, height/2);
        if(dist(mouseX, mouseY, cellPosition.x + Q.x*(i-3) + R.x*(j-3), cellPosition.y + Q.y*(i-3) + R.y*(j-3)) < this.scale/2){
          int[] hoverPosition = {i, j};
          return hoverPosition;
        }
      }
    }
    int[] hoverPosition = {0, 0};
    return hoverPosition;
  }
  
  void highlight(){
    int[] currentHoverPosition = this.getCurrentHoverPosition();
    int i = currentHoverPosition[0];
    int j = currentHoverPosition[1];
    
    PVector Q = new PVector(1, 0).mult(this.scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(this.scale);
  
    PVector highlightPosition = new PVector(width/2, height/2);
    highlightPosition = highlightPosition.add(Q.mult(i - 3));
    highlightPosition = highlightPosition.add(R.mult(j - 3));
    
    // Display highlight ring
    if(this.grid[i][j] != null){
      PImage ring = loadImage("bugs/ring.png");
      ring.resize(0, int(this.scale*1.22));
      image(ring, highlightPosition.x, highlightPosition.y);
    } else if (i-1 >= 0 && j-1 >= 0 && i+1 < this.size && j+1 < this.size){
      if (this.grid[i-1][j] != null || this.grid[i+1][j] != null || this.grid[i][j-1] != null || this.grid[i][j+1] != null || this.grid[i+1][j-1] != null || this.grid[i-1][j+1] != null){
        PImage emptyTile = loadImage("bugs/empty.png");
        emptyTile.resize(0, int(this.scale));
        image(emptyTile, highlightPosition.x, highlightPosition.y);
      }
    }
    
  }
  
  void addBug(Bug bug){
    println("adding", bug.team, bug.type);
    this.grid[bug.q + 3][bug.r + 3] = bug;
    if(bug.team == "w"){
      whiteBugs = (Bug[]) append(whiteBugs, bug);
    } else {
      blackBugs = (Bug[]) append(blackBugs, bug);
    }
  }
  
  void setScale(int scale){
    this.scale = scale;
    for(int i = 0; i < whiteBugs.length; i++){
      Bug bug = whiteBugs[i];
      bug.setScale(scale);
      bug.setPosition(bug.q, bug.r);
    }
    for(int i = 0; i < blackBugs.length; i++){
      Bug bug = blackBugs[i];
      bug.setScale(scale);
      bug.setPosition(bug.q, bug.r);
    }
  }
  
}
