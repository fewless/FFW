float EM[] = new float[50];
int EnemyAT;
/*
float leftKnee, rightKnee, //各座標 
  leftFootX, rightFootX, 
  leftFootY, rightFootY, 
  hip;
  
int  tallE
int  yE
int  sitE
*/

void enemyMove() {

  strokeWeight(4); 
  line(EM[3], EM[5], EM[1], EM[5]-EM[8]/4 +EM[10]);//leftLeg
  line(EM[7], EM[9]-EM[8]/2 +EM[10]*2, EM[1], EM[5]-EM[8]/4 +EM[10]);
  line(EM[4], EM[6], EM[2], EM[6]-EM[8]/4 +EM[10]);//rightLeg
  line(EM[7], EM[9]-EM[8]/2 +EM[10]*2, EM[2], EM[6]-EM[8]/4 +EM[10]);

  line(EM[7], EM[9]-EM[8]/2 +EM[10]*2, EM[7]+5, EM[9]-EM[8] +EM[10]*4);
  fill(0);
  ellipse(EM[7]+5, EM[9]-EM[8] +EM[10]*3, 15, 15);
  
  
  float calcX = EM[9]-EM[8]*4/5 +EM[10]*3;//腕の座標補正値
  
  pushMatrix();
  translate(EM[7], calcX);  // 原点を主人公に
  rotate(EM[11]);          // マウスカーソルの方向へ回転
  if((-1.6 <= EM[11] )&&( EM[11] <= 1.6)){//左右の判定
    image(arm[ (int)EM[12] ],0,0);//右向いてる
  }else{
    scale(1,-1);
    image(arm[ (int)EM[12] ],0,0);//左向いてる
    scale(1,-1);
  }
  rotate(EM[11]);//元に戻す
  
  popMatrix();
  
  strokeWeight(3); 
  
  switch((int)EM[13]){
    case 1:
     line(EM[7],calcX,EM[14],EM[15]);
     break;
    case 2:
    for(int t=0 ; t<8 ; t++){
     line(EM[7],calcX,EM[14 + t*2],EM[15 + t*2]);
    }
     break;
     
  }
  /*
  line(leftFootXE, leftFootYE, leftKneeE, leftFootYE-tallE/4 +sitE);//leftLeg
  line(hipE, yE-tallE/2 +sitE*2, leftKneeE, leftFootYE-tallE/4 +sitE);
  line(rightFootXE, rightFootYE, rightKneeE, rightFootYE-tallE/4 +sitE);//rightLeg
  line(hipE, yE-tallE/2 +sitE*2, rightKneeE, rightFootYE-tallE/4 +sitE);

  line(hipE, yE-tallE/2 +sitE*2, hipE+5, yE-tallE +sitE*4);
  fill(0);
  ellipse(hipE+5, yE-tallE +sitE*3, 15, 15);
  */
}