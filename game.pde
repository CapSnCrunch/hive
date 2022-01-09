class Game {
  int scale = 100;
  Bug[][] grid = new Bug[10][10];
  Bug[] whiteBugs = new Bug[0];
  Bug[] blackBugs = new Bug[0];
  PVector highlightPosition = new PVector(width/2, height/2);
  Game(){
  }
  
  void display(){
    PImage ring = loadImage("bugs/ring.png");
    ring.resize(0, int(this.scale*1.22));
    image(ring, highlightPosition.x, highlightPosition.y);
    
    for(int i = 0; i < whiteBugs.length; i++){
      whiteBugs[i].display();
    }
    for(int i = 0; i < blackBugs.length; i++){
      blackBugs[i].display();
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
  
  void highlight(String team){
    if(team == "w"){
      for(int i = 0; i < whiteBugs.length; i++){
        Bug bug = whiteBugs[i];
        if (dist(mouseX, mouseY, bug.pos.x, bug.pos.y) < this.scale/2){
          PVector Q = new PVector(1, 0).mult(scale);
          PVector R = new PVector(0.5, -sqrt(3)/2).mult(scale);
          PVector S = new PVector(-0.5, -sqrt(3)/2).mult(scale);
          
          this.highlightPosition = new PVector(width/2, height/2);
          this.highlightPosition = this.highlightPosition.add(Q.mult(bug.q));
          this.highlightPosition = this.highlightPosition.add(R.mult(bug.r));
          this.highlightPosition = this.highlightPosition.add(S.mult(bug.s));
        }
      }
    } else {
      for(int i = 0; i < blackBugs.length; i++){
        Bug bug = blackBugs[i];
        if (dist(mouseX, mouseY, bug.pos.x, bug.pos.y) < this.scale/2){
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
  
  void addBug(Bug bug){
    println("adding", bug.team, bug.type);
    if(bug.team == "w"){
      whiteBugs = (Bug[]) append(whiteBugs, bug);
    } else {
      blackBugs = (Bug[]) append(blackBugs, bug);
    }
  }
}
