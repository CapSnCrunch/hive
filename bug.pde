class Bug {
  String team, name;
  PImage img;
  
  Bug(String team, String name){
    this.team = team;
    this.name = name;
    this.img = loadImage("bugs/"+team+"-"+name+".png");
  }
  
  void display(int q, int r, int scale){
    PVector Q = new PVector(1, 0).mult(scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(scale);
    this.img.resize(0, scale);
    image(img, Q.x * q + R.x * r + width/2, Q.y * q + R.y * r + height/2);
  }
}
