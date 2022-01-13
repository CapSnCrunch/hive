class Bug {
  String team, name;
  
  Bug(String team, String name){
    this.team = team;
    this.name = name;
  }
  
  void display(PVector center, int q, int r, int scale, float angle){
    PVector Q = new PVector(1, 0).mult(scale);
    PVector R = new PVector(0.5, -sqrt(3)/2).mult(scale);
    PImage img = loadImage("bugs/"+team+"-"+name+".png");
    
    pushMatrix();
    translate(Q.x * q + R.x * r + center.x, Q.y * q + R.y * r + center.y);
    rotate(angle);
    translate(-(Q.x * q + R.x * r + center.x), -(Q.y * q + R.y * r + center.y));
    img.resize(0, scale);
    image(img, Q.x * q + R.x * r + center.x, Q.y * q + R.y * r + center.y);
    popMatrix();
  }
}
    
