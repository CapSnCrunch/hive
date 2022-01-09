class Bug {
  PVector pos;
  int q, r, s;
  String team, type;
  
  int scale = 100;
  PImage img;
  
  Bug (int q, int r, int s, String team, String type){
    this.q = q;
    this.r = r;
    this.s = s;
    this.team = team;
    this.type = type;
    this.img = loadImage("bugs/"+team+"-"+type+".png");
    
    setPosition(q, r, s);
  }
  
  void display(){
    img.resize(0, this.scale);
    image(img, this.pos.x, this.pos.y);
  }
  
  void setScale(int scale){
    this.scale = scale;
  }
  
  void setPosition(int q, int r, int s){
    this.q = q;
    this.r = r;
    this.s = s;
    
    println(this.scale);

    PVector Q = new PVector(1, 0).mult(scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(scale);
    PVector S = new PVector(-0.5, -sqrt(3)/2).mult(scale);
    
    this.pos = new PVector(width/2, height/2);
    this.pos = this.pos.add(Q.mult(q));
    this.pos = this.pos.add(R.mult(r));
    this.pos = this.pos.add(S.mult(s));
  }

}
