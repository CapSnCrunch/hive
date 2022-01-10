class Bug {
  PVector pos;
  int q, r;
  String team, type;
  
  int scale = 75;
  PImage img;
  
  Bug (int q, int r, String team, String type){
    this.q = q;
    this.r = r;
    this.team = team;
    this.type = type;
    this.img = loadImage("bugs/"+team+"-"+type+".png");
    
    setPosition(q, r);
  }
  
  void display(){
    img.resize(0, this.scale);
    image(img, this.pos.x, this.pos.y);
  }
  
  void setScale(int scale){
    this.scale = scale;
  }
  
  void setPosition(int q, int r){
    this.q = q;
    this.r = r;

    PVector Q = new PVector(1, 0).mult(scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(scale);
    
    this.pos = new PVector(width/2, height/2);
    this.pos = this.pos.add(Q.mult(q));
    this.pos = this.pos.add(R.mult(r));
  }

}
