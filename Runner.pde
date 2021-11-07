/*Team Saleh :
Irvan Deriano Koswara
Sulthon Mutaqin Rahmatullah
Bahar Septian Noor
Muhammad Alfahri
Muhammad Dicky RNA
*/
import processing.sound.*;
SoundFile back,jump,lost,high;
PFont tulisan;
boolean lose = false,pause = false;
String highscore[],tampung[];
int jumpTime = 0,score ;
int diff=14;
int x1=0;
ArrayList<PVector> boxes = new ArrayList<PVector>();
ArrayList<PVector> clouds = new ArrayList<PVector>();
PImage[] runner= new PImage[7];
PImage bg,awan;
int w=600,h=400,frame=0;
Player b = new Player();
PFont font;


class Player{
  PVector pos; //posisi karakter
  PVector acc; //kecepatan karakter
  PVector vel;  //gravitasi yang menarik karakter kebawah
  
  Player(){
  pos = new PVector(50,(h / 1.6));
  vel = new PVector(0,0);
  acc = new PVector(0,1);
  }
  void tampil(){
    image(runner[frame],pos.x,pos.y,55,55);
    if(frameCount%2==0){frame++;}
    if (frame>6){
    frame=0;
    }
  }
}

void setup(){
    size(600,400);
    frameRate(60);
    rectMode(CENTER);
    textAlign(CENTER);
    for(int i=0;i<runner.length;i++){
      runner [i]= loadImage("Trex"+(i+1)+".gif");
    }
    bg=loadImage("bg.png");
    awan=loadImage("cloud.png");
    tulisan = createFont("Pixeboy.ttf", 32);
    highscore = loadStrings("highscore.txt");
    back= new SoundFile(this,"background.mp3");
    jump= new SoundFile(this,"jump.wav");
    lost = new SoundFile(this,"lost.mp3");
    high = new SoundFile(this,"highscore.mp3");
    back.loop(1,0.3);
    
}

void draw(){
    background(0);
    image(bg,0,0,width,305);
    fill(255);
    textFont(tulisan);
    textSize(20);
    text("KEY PRESS=JUMP", w - 70, 20);
    text("CLICK=PAUSE", w - 70, 40);
    score=int(frameCount / 10);
    text("SCORE : " + score, 40, 20);
    text("HIGHSCORE :" + int(highscore[0]), 60, 40);
    drawBackgroundGrid();
    if(b.pos.y==h/1.6){
      fill(128);
    ellipse(70,h/1.3,50,20);
  }
  else{
    pushMatrix();
    scale(0.5);
    translate(100,300);
    fill(128);
    ellipse(70,h/1.3,50,20);
    popMatrix();
  }
    
    if (random(1) <= 0.05) {
        //membuat objek baru dari awan
        PVector cloud = new PVector(width, random(100));
        //memasukkan objek tadi ke arraylist kumpulan rintangan
        clouds.add(cloud);
    }
    if (random(1) <= 0.01) {
        //membuat objek baru dari rintangan
        PVector box = new PVector( width, 80 + height / 2);
        //memasukkan objek tadi ke arraylist kumpulan rintangan
        boxes.add(box);
    }
    
    if (clouds.size() != 0) {
        
        for (int i = 0; i < clouds.size(); i++) {
            PVector cloud = clouds.get(i);
            //awan bergerak kearah player
            cloud.x-=diff;
            image(awan,cloud.x,cloud.y,100,75);
            //menghapus awan yang sudah keluar kanvas sehingga tidak memenuhi arraylist
            if (cloud.x < -5) {
                clouds.remove(i);
            }
            
        }
    }
    
    if (boxes.size() != 0) {
        
        for (int i = 0; i < boxes.size(); i++) {
            PVector box = boxes.get(i);
            //rintangan bergerak kearah player
            box.x-=diff;
            stroke(0);
            strokeWeight(2);
            fill(211,172,128);
            rect(box.x,box.y,50,50);
            fill(163,111,63);
            rect(box.x,box.y,35,35);
            line(box.x+10,box.y-17,box.x+10,box.y+17);
            line(box.x+5,box.y-17,box.x+5,box.y+17);
            line(box.x,box.y-17,box.x,box.y+17);
            line(box.x-5,box.y-17,box.x-5,box.y+17);
            line(box.x-10,box.y-17,box.x-10,box.y+17);
            //menghapus rintangan yang sudah keluar kanvas sehingga tidak memenuhi arraylist
            if (box.x - 50 <= 50 && b.pos.y == h/1.6 ) {
                lost();
            }
            if (box.x < 0) {
                boxes.remove(i);
            }
            
        }
    }
    
    

    

    //turun setelah lompat
    if (frameCount - jumpTime == 20) {
        b.pos.y = h/1.6;
    }


    b.tampil();
    land();
}



void drawBackgroundGrid() {
    noStroke();
    strokeWeight(0.5);
    fill(127,173,113);
    if (x1 <= -width) {
        x1 = 0;
    } else { x1 -= diff; }
    //membuat grid dibawah kaki player
    for (int i = x1; i <= 2 * w; i += 40) {
        for (int j = (125 + h / 2); j <= h; j += 40) {
            rect(i, j, 40, 40); 
            
        }
    }
}

void keyPressed() {
    //jika posisi karakter masih dibawah dia akan melompat
    if (b.pos.y >= h / 1.6) {
        jump();
    }
}

//posisi y player akan berkurang 50, alias keatas
void jump() {
    jump.play();
    b.pos.y -= 50;
    jumpTime = frameCount;
}

void land() {
    if (b.pos.y <= h / 2) {
        b.vel.y += b.acc.y; //menarik player kebawah tanah
    } else {
        b.vel.y = 0;
        
    }
}

//freeze game saat terkena rintangan.
void lost() {
    back.stop();
    if (int(highscore[0])<score){
    highscore[0]=str(score);
    saveStrings("data/highscore.txt",highscore);
    high.play(1,0.3);
    textSize(40);
    fill(255,255,0);
    text("NEW HIGHSCORE!", w / 2, h / 1.7);
    }
    else{
    lost.play(1,0.3);
    }
    lose = true;
    frameCount = 0; //reset score
    noLoop(); //freeze game
    tint(255, 0, 0);
    //display text;
    textSize(80);
    fill(255, 0, 0);
    noStroke();
    text("YOU LOSE", w / 2, h / 2 - 50);
    textSize(40);
    fill(0);
    text("CLICK TO RESTART GAME", w / 2, h / 2);
}

//mouse pressed is used to pause and to restart the game.
void mousePressed() {
    if (lose == true) {
        resetGame();
    } else if (pause == false) {
        back.stop();
        fill(0);
        text("PAUSED", w / 2, h / 2);
        pause = true;
        noLoop();
    } else {
        back.loop(1,0.3);
        pause = false;
        loop();
    }
}

//reset game jika kalah.
void resetGame() {
    back.loop(1,0.5);
    tint(255);
    boxes.clear();
    lose = false;
    b.pos.y = h/ 1.6;
    b.vel.y=20;
    loop();
}
