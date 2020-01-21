import fisica.*;

FWorld world;
FBox leftWall, rightWall, leftGround, rightGround, net;
FCircle leftPlayer, rightPlayer;
FCircle ball;
boolean wKey, aKey, sKey, dKey, upKey, downKey,leftKey,rightKey, lCanJump,rCanJump, pause;
ArrayList<FContact> lContact;
ArrayList<FContact> rContact;
ArrayList<FContact> lGroundContact;
ArrayList<FContact> rGroundContact;
PImage background;
int leftScore, rightScore;
void setup(){
  background = loadImage("lordbyng.jpg");
  background.resize(width,height);
  size(800,600);
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0,900);
  leftWall = new FBox(50,height*2);
  leftWall.setStatic(true);
  leftWall.setNoStroke();
  leftWall.setPosition(-25,height/2);
  world.add(leftWall);
  //============================================================================================
  rightWall = new FBox(50,height*2);
  rightWall.setStatic(true);
  rightWall.setNoStroke();
  rightWall.setPosition(width+25,400);
  world.add(rightWall);
  //============================================================================================
  leftGround = new FBox(width/2, height/6);
  leftGround.setStatic(true);
  leftGround.setNoStroke();
  leftGround.setFriction(0);
  leftGround.setFillColor(#C16F02);
  leftGround.setPosition(width/4,height*11/12);
  world.add(leftGround);
  //============================================================================================
  rightGround = new FBox(width/2, height/6);
  rightGround.setStatic(true);
  rightGround.setNoStroke();
  rightGround.setFriction(0);
  rightGround.setFillColor(#C16F02);
  rightGround.setPosition(width*3/4,height*11/12);
  world.add(rightGround);
  //============================================================================================
  net = new FBox(10,50);
  net.setStatic(true);
  net.setNoStroke();
  net.setPosition(width/2,height*5/6 - 25);
  world.add(net);
  //============================================================================================
  ball = new FCircle(30);
  ball.setPosition(400,0);
  ball.setNoStroke();
  ball.setRestitution(1);
  world.add(ball);
  //============================================================================================
  leftPlayer = new FCircle(60);
  leftPlayer.setPosition(width/4,height*4/6);
  leftPlayer.setFillColor(#00FF12);
  world.add(leftPlayer);
  //============================================================================================
  rightPlayer = new FCircle(60);
  rightPlayer.setPosition(width*3/4,height*4/6);
  rightPlayer.setFillColor(#0092FF);
  world.add(rightPlayer);
  leftScore = 0;
  rightScore = 0;
  pause=false;
}
void draw(){
  if(!pause){
  lCanJump = false;
  rCanJump = false;
  image(background,0,-100);
  lContact = leftPlayer.getContacts();
  rContact = rightPlayer.getContacts();
  rGroundContact = rightGround.getContacts();
  lGroundContact = leftGround.getContacts();
  for(FContact a:lContact){
    if(a.contains(leftGround)){
      lCanJump = true;
    }
  }
  for(FContact a:rContact){
    if(a.contains(rightGround)){
      rCanJump = true;
    }
  }
  for(FContact a:rGroundContact){
    if(a.contains(ball)){
      leftScore++;
      world.remove(ball);
      world.remove(leftPlayer);
      leftPlayer.setPosition(width/4,height*9/12);
      leftPlayer.setForce(0,0);
      leftPlayer.setVelocity(0,0);
      world.add(leftPlayer);
      world.remove(rightPlayer);
      rightPlayer.setPosition(width*3/4,height*9/12);
      rightPlayer.setForce(0,0);
      rightPlayer.setVelocity(0,0);
      world.add(rightPlayer);
      ball.setPosition(leftPlayer.getX(),leftPlayer.getY() - leftPlayer.getSize()/2);
      world.add(ball);
      pause = true;
    }
  }
  for(FContact a:lGroundContact){
    if(a.contains(ball)){
      rightScore++;
      world.remove(ball);
      world.remove(leftPlayer);
      leftPlayer.setPosition(width/4,height*9/12);
      leftPlayer.setForce(0,0);
      leftPlayer.setVelocity(0,0);
      world.add(leftPlayer);
      world.remove(rightPlayer);
      rightPlayer.setPosition(width*3/4,height*9/12);
      rightPlayer.setForce(0,0);
      rightPlayer.setVelocity(0,0);
      world.add(rightPlayer);
      ball.setPosition(rightPlayer.getX(),rightPlayer.getY() - rightPlayer.getSize()/2);
      world.add(ball);
      pause = true;
    }
  }
 
    for(int i = 0;i<7;i++){
    noFill();
    strokeWeight(2);
    ellipse(15 + 50*i,100,20,20);
    if(i<leftScore){
      fill(#FCAA03);
      
      ellipse(15 + 50*i,100,20,20);
    }
  }
  for(int i = 0;i<7;i++){
    noFill();
    strokeWeight(2);
    ellipse(width - 15 - 50*i,100,20,20);
    if(i<rightScore){
      fill(#FCAA03);
      
      ellipse(width -15 - 50*i,100,20,20);
    }
  }
  if(wKey && lCanJump){
  leftPlayer.setVelocity(0,-500);
  }
  if(aKey){leftPlayer.addImpulse(-50,0);}
  if(dKey){
    leftPlayer.addImpulse(50,0);
  }
  if(upKey && rCanJump){
    rightPlayer.setVelocity(0,-500);
  }
  if(leftKey){
    rightPlayer.addImpulse(-50,0);}
  if(rightKey){
    rightPlayer.addImpulse(50,0);
  }
  if(leftPlayer.getX() > width/2-leftPlayer.getSize()/2){
    leftPlayer.setPosition(width/2-leftPlayer.getSize()/2,leftPlayer.getY());  
  }
  if(rightPlayer.getX() < width/2+rightPlayer.getSize()/2){
    rightPlayer.setPosition(width/2+rightPlayer.getSize()/2,rightPlayer.getY());  
  }
  world.step();
  world.draw();
  }else if(pause && (rightScore == 7 || leftScore == 7)){
    int time = 0;
    if(time<120){
      if(rightScore == 7){
        textAlign(CENTER);
        textSize(60);
        fill(0);
        text("Right Player Wins!",400,300);
      }else{
        textAlign(CENTER);
        textSize(60);
        text("Left Player Wins!",400,300);
      }
      time++;
    }else{
      time = 0;
      pause = false;
      reset();
    }
  }else{
    pause = false;
  }
}
void reset(){
  leftWall = new FBox(50,height*2);
  leftWall.setStatic(true);
  leftWall.setNoStroke();
  leftWall.setPosition(-25,height/2);
  world.add(leftWall);
  //============================================================================================
  rightWall = new FBox(50,height*2);
  rightWall.setStatic(true);
  rightWall.setNoStroke();
  rightWall.setPosition(width+25,400);
  world.add(rightWall);
  //============================================================================================
  leftGround = new FBox(width/2, height/6);
  leftGround.setStatic(true);
  leftGround.setNoStroke();
  leftGround.setFriction(0);
  leftGround.setFillColor(#C16F02);
  leftGround.setPosition(width/4,height*11/12);
  world.add(leftGround);
  //============================================================================================
  rightGround = new FBox(width/2, height/6);
  rightGround.setStatic(true);
  rightGround.setNoStroke();
  rightGround.setFriction(0);
  rightGround.setFillColor(#C16F02);
  rightGround.setPosition(width*3/4,height*11/12);
  world.add(rightGround);
  //============================================================================================
  net = new FBox(10,50);
  net.setStatic(true);
  net.setNoStroke();
  net.setPosition(width/2,height*5/6 - 25);
  world.add(net);
  //============================================================================================
  ball = new FCircle(30);
  ball.setPosition(400,0);
  ball.setNoStroke();
  ball.setRestitution(1);
  world.add(ball);
  //============================================================================================
  leftPlayer = new FCircle(60);
  leftPlayer.setPosition(width/4,height*4/6);
  leftPlayer.setFillColor(#00FF12);
  world.add(leftPlayer);
  //============================================================================================
  rightPlayer = new FCircle(60);
  rightPlayer.setPosition(width*3/4,height*4/6);
  rightPlayer.setFillColor(#0092FF);
  world.add(rightPlayer);
  leftScore = 0;
  rightScore = 0;
  pause=false;
}
void keyPressed(){
  if(key=='w')wKey=true;
  if(key=='a')aKey=true;
  if(key=='s')sKey=true;
  if(key=='d')dKey=true;
  if(keyCode==UP)upKey=true;
  if(keyCode==LEFT)leftKey=true;
  if(keyCode==DOWN)downKey=true;
  if(keyCode==RIGHT)rightKey=true;
}
void keyReleased(){
  if(key=='w')wKey = false;
  if(key=='a')aKey = false;
  if(key=='s')sKey = false;
  if(key=='d')dKey = false;
  if(keyCode==UP)upKey=false;
  if(keyCode==LEFT)leftKey=false;
  if(keyCode==DOWN)downKey=false;
  if(keyCode==RIGHT)rightKey=false;
}
