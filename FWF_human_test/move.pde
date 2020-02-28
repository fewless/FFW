boolean right, left, down, up, space;

int R=2;//半径
int y;//座標
int C, D=5;
float E, F;
float leftKnee, rightKnee, //各座標 
  leftFootX, rightFootX, 
  leftFootY, rightFootY, 
  hip, neck;
int count;//方向キーのカウント


boolean ride = false;//ブロックに乗っている
int rideObj;

boolean jumping=false;
int Jtime = 0;
int jumpY = 0;
int sit   = 0;//しゃがみ
int sitSpeed;//移動速度保存
boolean sitting = false;//しゃがみ中

CharaHair first = new CharaHair(hip-5, y-tall +sit*3 - 7.0 , 20, 2, 10);//髪のクラス生成　ｘ、ｙ、長さ、単位長さ、ボリューム (ボリューム要修正：横幅を頭幅にそろえる)
CharaCloth firstCloth = new CharaCloth(hip, y-tall/2 +sit*2 ,7, 5, 0,0);//腰ｘ、ｙ、長さ、基準、左足、右足

float gravity=1;//重力の強さ　髪と移動速度に関係する予定

void move() {


  if (right == true)count +=1;
  if (left == true)count -=1;

  if (keyPressed==true) {
    if (abs(count%(60/moveSpeed)) < 30/moveSpeed) {
      if (right==true && C-D <=15-moveSpeed) C += moveSpeed;
      if (left ==true && D-C<=15-moveSpeed) C -= moveSpeed;
    } 
    if (abs(count%(60/moveSpeed)) >= 30/moveSpeed) {
      if (right==true && D-C <=15-moveSpeed)D += moveSpeed;
      if (left ==true && C-D <=15-moveSpeed)D -= moveSpeed;
    }
    E = C;
    F = D+10;

    if (up ==true  && jumping == false) {//ジャンプ認識
      jumping = true;
      Jtime = 0;
    }
  }
  if (down == true && sitting == false) {//しゃがみ
    sitting = true;
    sit = tall/10;
    sitSpeed = moveSpeed;
    if (moveSpeed != 1)moveSpeed = moveSpeed/2; //しゃがみ中は移動速度半減
  } else if (down == false && sitting == true) {
    sitting = false;
    sit = 0;
    moveSpeed = sitSpeed;
  }


  if (ride == true && jumping == false) {//ブロックからの落下

    if (abs(block[rideObj][0] -hip) >= block[rideObj][2]/2 // X座標が重なってない
      && abs((block[rideObj][1] - block[rideObj][3]/2) -y) <15 ) { // Y座標が接近していない
      ride = false;
      jumping = true;
      Jtime = 4 * int(sqrt(10 * sqrt(moveSpeed)));
    }
  }

  if (jumping == true) {//ジャンプ
    Jtime += 1;
    jumpY += -10*sqrt(moveSpeed) + Jtime*Jtime/16;

    if (-10*sqrt(moveSpeed) + Jtime*Jtime/16 > 0) {//落下中
      for (int m=blockCount-1; m>-1; m--) {//上からチェック
      //println((block[m][1] - block[m][3]/2) -y  +" "+jumpY);
        if (abs(block[m][0] -hip) < block[m][2]/2 //X座標が重なってるか
          && abs((block[m][1] - block[m][3]/2) -y ) <15 //Y座標が接近しているか
          && y>0 ) {//上空限界に達してないか
          rideObj = m;
          locateY = block[m][1] - block[m][3]/2;
          ride = true;
          jumpY = 0;
          jumping = false;
          //println((block[m][1] - block[m][3]/2));
          //println(y);
          break;
        }
      }
    }

    if (y + jumpY >500) {//何かしらに乗ってる
      jumpY = 0;
      locateY = 500;
      jumping = false;
    }
  }

  if (space == true) {//アクションキー
    if (down == true && ride == true) {//すりぬけ
      locateY += 25;
      ride = false;
      jumping = true;
      Jtime = 4 * int(sqrt(10 * sqrt(moveSpeed)));
      space = false;
    }
  }

  rightKnee = R* (F - sin(radians(F* 360/60/moveSpeed))) ;//-tall/2;
  leftKnee  = R* (E - sin(radians(E* 360/60/moveSpeed)))+10 ;//-tall/8;

  leftFootX =R* (C - sin(radians(C* 360/60/moveSpeed))) ;
  leftFootY =y+ R*(cos(radians(C* 360/60/moveSpeed))-1);

  rightFootX=R* (D - sin(radians(D* 360/60/moveSpeed)))+15;
  rightFootY=y+ R*(cos(radians(D* 360/60/moveSpeed))-1);

  hip = (rightFootX+leftFootX)/2-tall/8;
  y  = locateY + jumpY; //y座標


  strokeWeight(4); 
  line(leftFootX, leftFootY, leftKnee, leftFootY-tall/4 +sit);//leftLeg
  line(hip, y-tall/2 +sit*2, leftKnee, leftFootY-tall/4 +sit);
  line(rightFootX, rightFootY, rightKnee, rightFootY-tall/4 +sit);//rightLeg
  line(hip, y-tall/2 +sit*2, rightKnee, rightFootY-tall/4 +sit);
    
  
  
  strokeWeight(6);
  line(hip, y-tall/2 +sit*2, hip+5, y-tall +sit*4);
  fill(0);
  ellipse(hip+5, y-tall +sit*3, 13, 13);
  //ellipse(hip,y-tall +sit*3 - 7.0,5,5);
  
  first.updateHair(hip+4,y-tall +sit*3 - 7.0);
  
  PVector LLeg=new PVector(leftKnee-hip,(leftFootY-tall/4 +sit) -(y-tall/2 +sit*2));
  PVector RLeg=new PVector(rightKnee-hip,(rightFootY-tall/4 +sit) -(y-tall/2 +sit*2));
  firstCloth.updateCloth(hip, y-tall/2 +sit*2, LLeg, RLeg);
  
  /*
  PVector testVec = new PVector(mouseX-width/2, mouseY -height/2);//ベクトル計算
  PVector testVec2 = new PVector(0,10);
  PVector calcVec = testVec.cross(testVec2);
  println(calcVec.z);
  */
}


class CharaHair{
  ArrayList<Float> hairP;//hairPosition
  int hairLength;//髪の長さ
  int hairNL;//hairNormalizeLength 髪の単位長さ
  int volume;//髪の量
  float hairDensity = 0.8;//髪の密度
  float addX = 2;
  float addY = addX*2;
  
  
  public CharaHair(float xHead,float yHead,int hairLength,int hairNL,int volume){//キャラクターの構造データの取得
    this.hairLength = hairLength;
    this.hairNL = hairNL;
    this.volume = volume;
    
    this.hairP = new ArrayList<Float>();
    this.hairP.add( xHead);//x座標　頭
    this.hairP.add( yHead);//y座標　頭
    
    for(int i=1;i<this.hairLength;i++){//髪の長さ＝hairLength*2
      this.hairP.add(xHead);//x座標　初期位置は変わらないので xHead
      this.hairP.add(this.hairP.get(i*2-1) + this.hairNL);//y座標　徐々に下につけてく
    }
  }
  
  public void updateHair(float xHead,float yHead){//座標更新
    this.hairP.set(0,xHead);
    this.hairP.set(1,yHead);
    
    for(int i=1;i<this.hairLength;i++){//髪の長さ分だけ追従していく
      PVector hairXY = new PVector(this.hairP.get(i*2)-this.hairP.get((i-1)*2),this.hairP.get(i*2+1) - this.hairP.get((i-1)*2+1));//一つ前の髪支点座標とのベクトル
      hairXY.normalize();
      if(hairXY.x != 0) hairXY.x  *= 7/(10*gravity);//ｘを０に近づける(重力)  9/10が定数
      if(hairXY.y <= 0 && hairXY.x==0 )hairXY.y  =0.1;//髪が上向いてるときは特例で下げる
      else if(hairXY.y < 1) hairXY.y  = ((hairXY.y-1) * 7)/(10*gravity) +1;//yを０に近づける(重力) 
      
      hairXY.mult(hairNL);
      
      this.hairP.set(i*2,this.hairP.get((i-1)*2) + hairXY.x);//一つ前にベクトル加算
      this.hairP.set(i*2+1,this.hairP.get((i-1)*2+1) + hairXY.y);
    }
    
    for(int i=0;i<this.hairLength-2;i++){//髪の長さ分
      for(int k = 0; k < volume*(((this.hairLength-2.0)-i/2.0)/(this.hairLength-2));k++){//髪のボリューム　端に行くにつれて短くする i/2=>端では中央の半分
      
      strokeWeight(0.7  * (((this.volume*2)-k)/this.volume*2));//端に行くにつれて髪を薄くする 先頭の数字はマジックナンバー
      line(this.hairP.get(i*2)+(hairDensity*k),this.hairP.get(i*2+1),this.hairP.get(i*2+2)+(hairDensity*k),this.hairP.get(i*2+3));//ボリューム分ずらす
      line(this.hairP.get(i*2)-(hairDensity*k + (i-1)*k*0.1),this.hairP.get(i*2+1),this.hairP.get(i*2+2)-(hairDensity*k + i*k*0.1),this.hairP.get(i*2+3));//ボリューム分ずらす
      if(i < (this.hairLength-2)/ (3/2.0)){
        line(addX + this.hairP.get(i*2)+(hairDensity*k),addY + this.hairP.get(i*2+1),addX + this.hairP.get(i*2+2)+(hairDensity*k),addY + this.hairP.get(i*2+3));//ボリューム分ずらす
        line(addX + this.hairP.get(i*2)-(hairDensity*k + (i-1)*k*0.1),addY + this.hairP.get(i*2+1),addX + this.hairP.get(i*2+2)-(hairDensity*k + i*k*0.1),addY + this.hairP.get(i*2+3));//ボリューム分ずらす
        }
      }
    }
  }
 
}

class CharaCloth{
  ArrayList<Float> clothPL;//clothPosition左
  ArrayList<Float> clothPR;//clothPosition右
  int clothLength;//服の長さ
  int clothNL;//clothNormalizeLength 服の単位長さ
  float LVector;
  float RVector;//limit vector 服の動き制限のため、足のベクトル取得
  
  public CharaCloth(float xHip,float yHip,int clothLength,int clothNL, float LVector, float RVector){//キャラクターの構造データの取得
    this.clothLength = clothLength;
    this.clothNL = clothNL;
    this.LVector = LVector;
    this.RVector = RVector;
    
    this.clothPL = new ArrayList<Float>();
    this.clothPL.add( xHip);//x座標　腰
    this.clothPL.add( yHip);//y座標　腰
    for(int i=1;i<this.clothLength;i++){//服の長さ＝clothLength*2
      this.clothPL.add(xHip);//x座標　初期位置は変わらないので xHead
      this.clothPL.add(this.clothPL.get(i*2-1) + this.clothNL);//y座標　徐々に下につけてく
    }
    
    this.clothPR = new ArrayList<Float>();
    this.clothPR.add( xHip);//x座標　腰
    this.clothPR.add( yHip);//y座標　腰
    for(int i=1;i<this.clothLength-2;i++){//服の長さ＝clothLength*2
      this.clothPR.add(xHip);//x座標　初期位置は変わらないので xHead
      this.clothPR.add(this.clothPR.get(i*2-1) + this.clothNL);//y座標　徐々に下につけてく
    }
    
  }
  
  public void updateCloth(float xHip,float yHip,PVector LLeg,PVector RLeg){//座標更新
    PVector flontL = new PVector();
    PVector backL = new PVector();
    PVector base = new PVector(0,height);//重力方向の基準ベクトル
    if(degrees(PVector.angleBetween(base,LLeg)) > degrees(PVector.angleBetween(base,RLeg))){//どちらの足が前に来ているか判断 起点は重力方向
      flontL= LLeg;
      backL= RLeg;
    }else{
      flontL=RLeg;
      backL=LLeg;
    }
    this.clothPL.set(0,xHip);
    this.clothPL.set(1,yHip);
    for(int i=1;i<this.clothLength;i++){//服の長さ分だけ追従していく
      PVector clothXY = new PVector(this.clothPL.get(i*2)-this.clothPL.get((i-1)*2),this.clothPL.get(i*2+1) - this.clothPL.get((i-1)*2+1));//一つ前の服支点座標とのベクトル
      if(clothXY.cross(flontL).z <25 && flontL.mag() > clothXY.normalize().mult(clothNL).mag()*i){ //めりこみ判定　25は脚の太さでなんとなく　増やすともりあがる
        clothXY = flontL.copy();//服が足を貫通するなら足基準に変更
        clothXY.normalize();
      }else{
        clothXY.normalize();
        if(clothXY.x != 0) clothXY.x  *= 7/(10*gravity);//ｘを０に近づける(重力)  9/10が定数
        if(clothXY.y <= 0 && clothXY.x==0 )clothXY.y  =0.1;//服が上向いてるときは特例で下げる
        else if(clothXY.y < 1) clothXY.y  = ((clothXY.y-1) * 7)/(10*gravity) +1;//ｘを０に近づける(重力) 
      }
      
      clothXY.mult(clothNL);
      this.clothPL.set(i*2,this.clothPL.get((i-1)*2) + clothXY.x);//一つ前にベクトル加算
      this.clothPL.set(i*2+1,this.clothPL.get((i-1)*2+1) + clothXY.y);
    }
    
    this.clothPR.set(0,xHip);
    this.clothPR.set(1,yHip);
    for(int i=1;i<this.clothLength-2;i++){//服の長さ分だけ追従していく
      PVector clothXY = new PVector(this.clothPR.get(i*2)-this.clothPR.get((i-1)*2),this.clothPR.get(i*2+1) - this.clothPR.get((i-1)*2+1));//一つ前の服支点座標とのベクトル
      if(clothXY.cross(backL).z > 10 ){ //めりこみ判定　25は脚の太さでなんとなく　増やすともりあがる
        clothXY = backL.copy();//服が足を貫通するなら足基準に変更
        clothXY.normalize();
      }else{
        clothXY.normalize();
        if(clothXY.x != 0) clothXY.x  *= 7/(10*gravity);//ｘを０に近づける(重力)  9/10が定数
        if(clothXY.y <= 0 && clothXY.x==0 )clothXY.y  =0.1;//服が上向いてるときは特例で下げる
        else if(clothXY.y < 1) clothXY.y  = ((clothXY.y-1) * 7)/(10*gravity) +1;//ｘを０に近づける(重力) 
      }
      clothXY.mult(clothNL);
      this.clothPR.set(i*2,this.clothPR.get((i-1)*2) + clothXY.x);//一つ前にベクトル加算
      this.clothPR.set(i*2+1,this.clothPR.get((i-1)*2+1) + clothXY.y);
    }
    
    beginShape(POLYGON); 
    for(int i=0;i<clothPR.size()/2;i++)vertex(this.clothPR.get(i*2),this.clothPR.get(i*2+1)); 
    for(int i=clothPL.size()/2-1;i>0;i--)vertex(this.clothPL.get(i*2),this.clothPL.get(i*2+1)); 
    endShape();
    
    
  }
}