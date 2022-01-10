class Game {
  int size = 10;
  int scale = 75;
  Bug[][] grid = new Bug[this.size][this.size];
  Bug[] whiteBugs = new Bug[0];
  Bug[] blackBugs = new Bug[0];
  PVector highlightPosition = new PVector(width/2, height/2);
  Game(){
  }
  
  void display(){
    // Display highlight ring
    PImage ring = loadImage("bugs/ring.png");
    ring.resize(0, int(this.scale*1.22));
    image(ring, highlightPosition.x, highlightPosition.y);
    
    // Display bugs
    for(int i = 0; i < this.size; i++){
      for(int j = 0; j < this.size; j++){
        if(this.grid[i][j] != null){
          this.grid[i][j].display();
        } else {
          if (i-1 >= 0 && j-1 >= 0 && i+1 < this.size && j+1 < this.size){
            if(this.grid[i-1][j] != null || this.grid[i+1][j] != null || this.grid[i][j-1] != null || this.grid[i][j+1] != null || this.grid[i+1][j-1] != null || this.grid[i-1][j+1] != null){
              PImage emptyTile = loadImage("bugs/empty.png");
              emptyTile.resize(0, int(this.scale));
              PVector pos = new PVector(width/2, height/2);
              PVector Q = new PVector(1, 0).mult(scale);
              PVector R = new PVector(0.5, -sqrt(3)/2).mult(scale);
              pos = pos.add(Q.mult(i-4));
              pos = pos.add(R.mult(j-4));
              image(emptyTile, pos.x, pos.y);
            }
          }
        }
      }
    }
  }
  
  void setScale(int scale){
    this.scale = scale;
    for(int i = 0; i < whiteBugs.length; i++){
      Bug bug = whiteBugs[i];
      bug.setScale(scale);
      bug.setPosition(bug.q, bug.r, bug.s);
    }
    for(int i = 0; i < blackBugs.length; i++){
      Bug bug = blackBugs[i];
      bug.setScale(scale);
      bug.setPosition(bug.q, bug.r, bug.s);
    }
  }
  
  void getCurrentHoverPosition(){
    PVector cursor = new PVector(mouseX - width / 2, mouseY - height / 2);
    PVector Q = new PVector(1, 0).mult(scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(scale);
    
    float i = cursor.dot(Q)/(scale*scale);
    float j = cursor.dot(R)/(scale*scale);
    
    PVector pointer = new PVector(width/2, height/2);
    pointer = pointer.add(Q.mult(i));
    pointer = pointer.add(R.mult(j));
    
    ellipse(pointer.x, pointer.y, 5, 5);
    
    println(i, j);
    println(round(i), round(j));
  }
  
  void highlight(){
    boolean currentlyHighlighting = false;
    for(int i = 0; i < this.size; i++){
      for(int j = 0; j < this.size; j++){
        if (this.grid[i][j] != null){
          Bug bug = this.grid[i][j];
          if (dist(mouseX, mouseY, bug.pos.x, bug.pos.y) < this.scale/2){
            currentlyHighlighting = true;
            PVector Q = new PVector(1, 0).mult(scale);
            PVector R = new PVector(0.5, -sqrt(3)/2).mult(scale);
            PVector S = new PVector(-0.5, -sqrt(3)/2).mult(scale);
            
            this.highlightPosition = new PVector(width/2, height/2);
            this.highlightPosition = this.highlightPosition.add(Q.mult(bug.q));
            this.highlightPosition = this.highlightPosition.add(R.mult(bug.r));
            this.highlightPosition = this.highlightPosition.add(S.mult(bug.s));
          }
        }
      }
    }
    if (currentlyHighlighting == false){
      this.highlightPosition = new PVector(2*width, 2*height);
    }
  }
  
  void addBug(Bug bug){
    println("adding", bug.team, bug.type);
    int q = bug.q + bug.s + 4;
    int r = bug.r - bug.s + 4;
    this.grid[q][r] = bug;
    if(bug.team == "w"){
      whiteBugs = (Bug[]) append(whiteBugs, bug);
    } else {
      blackBugs = (Bug[]) append(blackBugs, bug);
    }
  }
  
}
