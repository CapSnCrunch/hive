class Player {
  String team;
  
  String[] bugs = new String[]{"queen", "ant", "spider", "beetle", "hopper", "ladybug", "pillbug", "mosquito"};
  int[] counts = new int[]{1, 3, 3, 2, 2, 1, 1, 1};
  IntDict bugCounts = new IntDict(bugs, counts);
  
  Player(String team){
    this.team = team;
  }
}
