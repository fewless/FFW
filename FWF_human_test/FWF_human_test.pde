import processing.net.*;
Server server;
boolean start=false;

PImage arm[] = new PImage[4];//銃の画像配列
PImage ammo[] = new PImage[2];//弾丸表示
int locateY=500;
int moveSpeed=2;//敏捷性
int stage = 2;//現在の処理場面

int reload[] = new int[4];//リロード時間

int HowManyBlocks = 101;
int[][] block = new int[HowManyBlocks][6];//X座標、Y座標、幅、高さ、時間、落下完了///障害物ブロック

void setup() {
  size(960, 540);
  frameRate(60);
 imageMode(CENTER);
 rectMode(CENTER);
  for (int k=0; k < arm.length; k++) {//銃画像読み込み
    arm[k] = loadImage("arm"+ k +".png");
  }
  for (int k=0; k < ammo.length; k++) {//弾丸画像読み込み
    ammo[k] = loadImage("ammo"+ k +".png");
  }

server = new Server(this, 5555);

}


int tall=60;//キャラの身長
int armTalls;


void draw() {
  background(255);

 
  
  if(start == true)stageDraw();//ステージ描写

  stageDraw();
  target();//射撃管制
  serverWorking();
  enemyMove();
  shot();
  serverWorking();
  enemyMove();
  move();//移動管制
  //serverWorking();
 // enemyMove();
}

void keyPressed() {
  if (key == 'd') right = true;
  if (key == 'a')  left = true;
  if (key == 's')  down = true;
  if (key == 'w')    up = true;
  if (key == ' ') space = true;
  if (key == 'b') start = true;
}

void keyReleased()
{
  if (key == 'd') right = false;
  if (key == 'a') left  = false;
  if (key == 'w') up    = false;
  if (key == 's') down  = false;
  if (key == ' ') space = false;
}

void mouseWheel(MouseEvent e){//Weapon Test
  if ( e.getAmount() < 0 ) {
    weapon += 1;
    if (weapon > arm.length-1) {
      weapon = 0;
    }
  } else {
    weapon -= 1;
    if (weapon < 0) {
      weapon = arm.length-1;
    }
  }
  
}