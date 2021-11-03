/*Team Saleh :
Irvan Deriano Koswara
Sulthon Mutaqin Rahmatullah
Bahar Septian Noor
Muhammad Alfahri
Muhammad Dicky RNA
*/
boolean lose = false;
boolean pause = false;
int jumpTime = 0;
int diff=14;
int x1=0;
ArrayList<PVector> boxes = new ArrayList<PVector>();
PImage runner;
int w=600,h=400,posisi=w/2;

Player b = new Player();
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
    image(runner,pos.x,pos.y,50,50);
  }
}

void setup(){
  
    size(600,400);
    background(0);
    frameRate(60);
    rectMode(CENTER);
    textAlign(CENTER);
    runner = loadImage("Trex.png");
  
}

void draw(){
    background(0);
    fill(255);
    textSize(10);
    text("KEY PRESS=JUMP", w - 70, 20);
    text("CLICK=PAUSE", w - 70, 40);
    text("SCORE: " + int(frameCount / 10), 40, 20);
    drawBackgroundGrid();
    
    if (random(1) <= 0.01) {
        //membuat objek baru dari rintangan
        PVector box = new PVector( width, 80 + height / 2);
        fill(255);
        //memasukkan objek tadi ke arraylist kumpulan rintangan
        boxes.add(box);
    }
    
    if (boxes.size() != 0) {
        
        for (int i = 0; i < boxes.size(); i++) {
            PVector box = boxes.get(i);
            //rintangan bergerak kearah player
            box.x-=diff;
            fill(255);
            rect(box.x,box.y,50,50);
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
    stroke(255);
    strokeWeight(0.5);
    noFill();
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
    lose = true;
    frameCount = 0; //reset score
    noLoop(); //freeze game
    tint(255, 0, 0);
    //display text;
    textSize(80);
    fill(255, 0, 0);
    noStroke();
    text("YOU LOSE", w / 2, h / 2 - 50);
    textSize(20);
    fill(255);
    text("CLICK TO RESTART GAME", w / 2, h / 2);
}

//mouse pressed is used to pause and to restart the game.
void mousePressed() {
    if (lose == true) {
        resetGame();
    } else if (pause == false) {
        fill(255);
        text("PAUSED", w / 2, h / 2);
        pause = true;
        noLoop();
    } else {
        pause = false;
        loop();
    }
}

//reset game jika kalah.
void resetGame() {
    tint(255);
    boxes.clear();
    lose = false;
    b.pos.y = h/ 1.6;
    b.vel.y=20;
    loop();
}
