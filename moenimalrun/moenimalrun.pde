/*Team Saleh :
Irvan Deriano Koswara
Sulthon Mutaqin Rahmatullah
Bahar Septian Noor
Muhammad Alfahri
Muhammad Dicky RNA
*/

import processing.sound.*;
SoundFile back,jump,lost,high,change,start,powerup,crunch;
PFont tulisan;
String highscore[], tampung[];
ArrayList<PVector> kotakRintang = new ArrayList<PVector>();
ArrayList<PVector> awanGerak = new ArrayList<PVector>();
ArrayList<PVector> itemBurger = new ArrayList<PVector>(); 

PImage[] gifBanteng = new PImage[5];
PImage[] gifGelembung = new PImage[4];
PImage[] kumpulanBg = new PImage[3];
PImage[] runner= new PImage[7];
PImage awan, logo, left, right, burgir, kebalBg;
Player b = new Player();
String chara="Ao", kiri="Cha", kanan="Momo";
String rintangBaru = "Banteng", kebal = "kebal", bg = "bg";
int jumpTime = 0,score ;
int diff=14;
int diff2=20;
int x1=0;
int w=600,h=400,frame=0,menu=1, frameBanteng=0, frameGelembung=0, frameBg = 0, powerTime = 0;
boolean lose = false, pause = false;
PShape bulan,matahari;
PImage bul,mat;
class Player{
    PVector pos; //posisi karakter
    PVector acc; //kecepatan karakter
    PVector vel; //gravitasi yang menarik karakter kebawah
  
    Player(){
        pos = new PVector(50,(h / 1.6));
        vel = new PVector(0,0);
        acc = new PVector(0,0.1);
    }

    void tampil(){
        image(runner[frame],pos.x,pos.y,55,55);
        if (frameCount%2==0){
            frame++;
        }
        if (frame>6){
            frame=0;
        }
        tint(255);
    }

    void kebal(){
        image(gifGelembung[frameGelembung],pos.x-5,pos.y-5,65,65);
        if(powerTime>=299){
         back.stop();
         powerup.loop();
          }
        if(powerTime==0){  
        powerup.stop();
        kotakRintang.clear();
        bulls.clear();
        back.loop(1,0,3);
        
        }
        if (frameCount%2==0){
            frameGelembung++;
        }
        if (frameGelembung>3){
            frameGelembung=0;
        }
        
    }
}

class Rintangan{
    PVector pos; //posisi karakter
    PVector acc; //kecepatan karakter
    PVector vel; //gravitasi yang menarik karakter kebawah
  
    Rintangan(){
        pos = new PVector(width, height / 1.6);
        acc = new PVector(0,1);
    }

    void tampil(){
        image(gifBanteng[frameBanteng],pos.x,pos.y,55,55);
        if (frameCount%2==0){
            frameBanteng++;
        }
        if (frameBanteng>4){
            frameBanteng=0;
        }
    }
}

ArrayList<Rintangan> bulls = new ArrayList<Rintangan>();


void setup(){
    hint(DISABLE_DEPTH_TEST);
    size(600,400,P3D);
    highscore = loadStrings("highscore.txt");
    back= new SoundFile(this,"background.mp3");
    jump= new SoundFile(this,"jump.wav");
    lost = new SoundFile(this,"lost.mp3");
    high = new SoundFile(this,"highscore.mp3");
    change = new SoundFile(this,"change.wav");
    start = new SoundFile(this,"start.wav");
    powerup = new SoundFile(this,"power.mp3");
    crunch = new SoundFile(this,"crunch.wav");
    awan=loadImage("cloud.png");
    burgir=loadImage("Burgir.png");
    kebalBg = loadImage("bgKebal.jpg");
    logo=loadImage("logo.png");
    left=loadImage(kiri+".gif");
    right=loadImage(kanan+".gif");
    tulisan = createFont("Pixeboy.ttf", 32);
    bul = loadImage("bulan.jpg");
    mat = loadImage("matahari.jpg");
    bulan= createShape(SPHERE,RADIUS);
    matahari= createShape(SPHERE,RADIUS);
    bulan.setTexture(bul);
    bulan.setStroke(false);
    matahari.setTexture(mat);
    matahari.setStroke(false);
    textFont(tulisan);  
    for (int i = 0; i < kumpulanBg.length; i++) {
        kumpulanBg[i] = loadImage(bg+(i+1)+".png"); 
    }

    for(int j = 0; j < runner.length; j++){
        runner [j]= loadImage(chara+(j+1)+".gif");
    } 

    for (int k = 0; k < gifBanteng.length; k++) {
        gifBanteng[k] = loadImage(rintangBaru+(k+1)+".gif"); 
    }

    for (int l = 0; l < gifGelembung.length; l++) {
        gifGelembung[l] = loadImage(kebal+(l+1)+".png"); 
    }
    frameRate(60);
    rectMode(CENTER);
    textAlign(CENTER);
    back.loop(1,0.3);
}

void draw(){
    //bagian main menu
    if (menu==1){
        mainMenu();
    }
    //bagian game
    else if (menu == 2){
        gamePlay();
    }
    
}

void drawBackgroundGrid() {
    noStroke();
    strokeWeight(0.5);
    fill(127,173,113);

    if (powerTime > 0) {
        fill(#e14b30);
    }

    if (x1 <= -width) {
        x1 = 0;
    } else { 
        x1 -= diff;
    }
    //membuat platform dibawah kaki player
     rect(w/2,350,w,125);
}


/* event */
void keyPressed() {
    //jika posisi karakter masih dibawah dia akan melompat
    if (keyCode==' ' &&b.pos.y >= h / 1.6 &&menu==2) {
        jump();
    }
    if(keyCode==' ' && menu==1){
        start.play();
        b.pos.y = h/ 1.6;
        menu=2; 
        frameCount=0;
    }
    if(keyCode==LEFT &&menu==1){
    if (chara=="Ao"){
    chara="Cha";
    kanan="Ao";
    kiri="Momo";
    changeChara();
    }
    else if (chara=="Cha"){
    chara="Momo";
    kanan="Cha";
    kiri="Ao";
    changeChara();
    }
    else if (chara=="Momo"){
    chara="Ao";
    kanan="Momo";
    kiri="Cha";
    changeChara();
    }
    }
    else if(keyCode==RIGHT &&menu==1){
    if (chara=="Ao"){
    chara="Momo";
    kanan="Cha";
    kiri="Ao";
    changeChara();
    }
    else if (chara=="Momo"){
    chara="Cha";
    kanan="Ao";
    kiri="Momo";
    changeChara();
    }
    else if (chara=="Cha"){
    chara="Ao";
    kanan="Momo";
    kiri="Cha";
    changeChara();
    }
    }
}

void mousePressed() {
    //tekan mouse digunakan untuk pause restart atau kembali ke menu.
    if (mouseButton==LEFT && lose == true &&menu==2) {
        resetGame();
    } 
    else if(mouseButton==RIGHT && lose==true && menu==2){
      backToMenu();
    }
    else if (pause == false &&menu==2) {
        back.stop();
        fill(0);
        text("PAUSED", w / 2, h / 2);
        pause = true;
        noLoop();
    }
    else if(menu==1){}
    else{
        back.loop(1,0.3);
        pause = false;
        loop();
    }
}

void jump() {
    //posisi y player akan berkurang 50, alias keatas
    jump.play();
    b.pos.y -= 60;
    jumpTime = frameCount;
}

void land() {
       b.pos.y = h/1.6;
}

void lost() {
    //freeze game saat terkena rintangan.
    
    back.stop();
    if ( int(highscore[0]) < score ) {
        highscore[0]=str(score);
        saveStrings("data/highscore.txt",highscore);
        high.play(0.8,0.3);
        textSize(40);
        fill(255,255,0);
        text("NEW HIGHSCORE!", w / 2, h / 1.7);
    } else{
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
    textSize(20);
    fill(0);
    text("LEFT CLICK TO RESTART GAME   |   RIGHT CLICK TO MAIN MENU", w / 2, h / 2);
}

//reset game jika kalah.
void resetGame() {
    diff=14;
    diff2=20;
    menu = 2;
    back.loop(1,0.5);
    tint(255);
    kotakRintang.clear();
    bulls.clear();
    itemBurger.clear();
    lose = false;
    b.pos.y = h/ 1.6;
    b.vel.y = 20;
    frameBg = 0;
    loop();
}

//kembali ke main menu
void backToMenu(){
    diff=14;
    diff2=20;
    menu = 1;
    back.loop(1,0.5);
    tint(255);
    kotakRintang.clear();
    bulls.clear();
    lose = false;
    loop();
}

void changeChara(){
    tint(128);
    left=loadImage(kiri+".gif");
    right=loadImage(kanan+".gif");
    change.play();
    tint(255);
    for(int i=0;i<runner.length;i++){
        runner [i]= loadImage(chara+(i+1)+".gif");
    }
}

void mainMenu() {
    imageMode(CORNER);
    background(0);
    image(kumpulanBg[0], 0, 0, width,305);   
    drawBackgroundGrid();

    if (random(1) <= 0.05) {
        //membuat objek baru dari awan
        PVector cloud = new PVector(width, random(100));
        //memasukkan objek tadi ke arraylist kumpulan rintangan
        awanGerak.add(cloud);
    }
    if (awanGerak.size() != 0) {
        for (int i = 0; i < awanGerak.size(); i++) {
            PVector cloud = awanGerak.get(i);
            //awan bergerak kearah player
            cloud.x-=diff;
            image(awan,cloud.x,cloud.y,100,75);
            //menghapus awan yang sudah keluar kanvas sehingga tidak memenuhi arraylist
            if (cloud.x < -50) {
                awanGerak.remove(i);
            }
        }
    }

    imageMode(CENTER);

    tint(128);
    image( left, width/2-100, height/2+50, 50, 50);
    image(right, width/2+100, height/2+50, 50, 50);

    tint(255);
    image(runner[frame], width/2, height/2+50, 100, 100);

    if (frameCount%2==0) {
        frame++;
    }

    if (frame>6) {
        frame=0;
    }
    


    fill(0);
    textSize(40);
    text("YOUR HIGHSCORE :" + int(highscore[0]), w/2, 40);
    text("<- CHANGE CHARACTER ->", w/2, 160);
    if (chara=="Momo") {
        textSize(20);
        text("MOMO" , w/2, 190);
    } else if (chara=="Ao") {
        textSize(20);
        text("AO", w/2, 190);
    } else if (chara=="Cha") {
        textSize(20);
        text("CHA", w/2, 190);
    }

    textSize(15);
    text("PRESS SPACE TO START",width/2,height/2+200,200,200);
    image(logo,width/2+10,height/2-120,424.51,111.992);
    textSize(15);
    text("Team 2 Graphic Computer ",width/2,height-15,100,100);
}

void gamePlay() {
    imageMode(CORNER);
    background(0);
    if (powerTime <= 0) {
        image(kumpulanBg[frameBg], 0, 0, width, 305);
        if (frameCount%300==0){
            frameBg++;
        }
        if (frameBg>2){
            frameBg=0;
        }
        
        
   
    } else {
        image(kebalBg, 0, 0, width, 305);
    }
    drawBackgroundGrid();
    if (frameBg==0 && powerTime <=0){
        stroke(255,0,0,128);
        strokeWeight(20);
        strokeCap(SQUARE);
        noFill();
        bezier(w/2-100,215,w/2-100,100,w/2+100,100,w/2+100,215);
        stroke(255,255,0,128);
        bezier(w/2-100,215,w/2-100,120,w/2+100,120,w/2+100,215);
        stroke(0,255,0,128);
        bezier(w/2-100,215,w/2-100,140,w/2+100,140,w/2+100,215);
      }
      
      if (frameBg==1 && powerTime <=0){
        pointLight(255, 129, 0,w/2,h/2,100);
         shape(matahari,w/2,100,50,50);
        
      }
      
      if (frameBg==2 && powerTime <=0){
        pointLight(255,255,255,w/2,100,100);
        shape(bulan,w/2,100,50,50);
      }
        
    fill(255);
    textSize(20);
    noStroke();
    score=int(frameCount / 10);
    text("SCORE : " + score, w/2, 20);
    text("HIGHSCORE :" + int(highscore[0]), w/2, 40);
    text("SHIELD" ,30, 20);
    text("SPACE=JUMP", w - 70, 20);
    text("CLICK=PAUSE", w - 70, 40);
    rectMode(CORNER);
    fill(255,0,0);
    rect(10,30,powerTime/2,10);
    rectMode(CENTER);
    fill(255);



    if (b.pos.y == h/1.6) {
        fill(0, 50);
        ellipse(70, h/1.3, 50, 20);
    } else {
        pushMatrix();
        scale(0.5);
        translate(100, 300);
        fill(0, 50);
        ellipse(70, h/1.3, 50, 20);
        popMatrix();
    }

    if (random(1) <= 0.05 && powerTime <= 0) {
        //membuat objek baru dari awan
        PVector cloud = new PVector(width, random(100));
        //memasukkan objek tadi ke arraylist kumpulan rintangan
        awanGerak.add(cloud);
    }  
    
    if (awanGerak.size() != 0) {
        for (int i = 0; i < awanGerak.size(); i++) {
            PVector cloud = awanGerak.get(i);
            //awan bergerak kearah player
            cloud.x-=diff;
            switch (frameBg) {
                case 0 :
                    tint(255);
                    break;	
                case 1 :
                    tint(255, 129, 0);
                    break;
                case 2 :
                    tint(#003366);
            }
            image(awan,cloud.x,cloud.y,100,75);
            tint(255);
            //menghapus awan yang sudah keluar kanvas sehingga tidak memenuhi arraylist
            if (cloud.x < -50) {
                awanGerak.remove(i);
            }
            
        }
    }
    

    if (frameCount % 750 == 0 ) {
        //membuat objek baru dari awan
        PVector burger = new PVector(width, 20+height/1.6);
        //memasukkan objek tadi ke arraylist kumpulan rintangan
        itemBurger.add(burger);
    }  
    
    if (itemBurger.size() != 0) {
        for (int i = 0; i < itemBurger.size(); i++) {
            PVector burger = itemBurger.get(i);
            //awan bergerak kearah player
            burger.x-=diff;
            image(burgir, burger.x, burger.y, 25, 25);   

            if (burger.x - 50 <= 50 && b.pos.y == h/1.6 ) {
                crunch.play();
                powerTime = 60*5;
                itemBurger.remove(i);
            }

            if (burger.x < -50) {
                itemBurger.remove(i);
            }
            
        }
    }
    

    if (random(1) <= 0.01) {
        //membuat objek baru dari rintangan
        PVector box = new PVector( width, 80 + height / 2);
        //memasukkan objek tadi ke arraylist kumpulan rintangan
        kotakRintang.add(box);
    }

    if (kotakRintang.size() != 0) {        
        for (int i = 0; i < kotakRintang.size(); i++) {
            PVector box = kotakRintang.get(i);
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
            strokeWeight(0);
            // mengecek jika pemain menabrak rintangan
            if (box.x - 50 <= 50 && b.pos.y == h/1.6 && powerTime <= 0) {
                lost();
            }
            // menghapus rintangan yang sudah keluar kanvas sehingga tidak memenuhi arraylist
            if (box.x < 0) {
                kotakRintang.remove(i);
            }            
        }
    }
    if (score > 50 && kotakRintang.size() == 0 && random(1) <= 0.01) {
        //membuat objek baru dari rintangan
        Rintangan bantengGalak = new Rintangan();
        //memasukkan objek tadi ke arraylist kumpulan rintangan
        bulls.add(bantengGalak);
    }

    if (bulls.size() != 0) {        
        for (int i = 0; i < bulls.size(); i++) {
            Rintangan bull = bulls.get(i);
            //rintangan bergerak kearah player
            bull.pos.x -=diff2;
            bull.tampil();
            
            // mengecek jika pemain menabrak rintangan
            if (bull.pos.x - 50 <= 50 && b.pos.y == h/1.6 && powerTime <= 0) {
                lost();
            }
            // menghapus rintangan yang sudah keluar kanvas sehingga tidak memenuhi arraylist
            if (bull.pos.x < 0) {
                bulls.remove(i);
            }            
        }
    }

    //turun setelah lompat
    if (frameCount - jumpTime == 20) {
         land();
    }

    b.tampil();
   
   if(frameCount%1000==0){
   diff+=1;
   diff2+=1;
   }

    if (powerTime > 0) {
        powerTime--;
        b.kebal();
    }

}
