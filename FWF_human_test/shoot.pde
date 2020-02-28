int shootCount = 0;
int weapon = 0;
PVector XYshoot;
int Tshooting = 0;

///////////Rifle---PDW---SniperRifle---Shotgun////////////////
int penetration[] = {45, 25, 200, 15};//貫通力
int peneCal;//貫通力減衰計算

int ammoLeft[] ={30, 35, 5, 15};//残弾管理
int reloadDelay[] ={60, 45, 200, 35};////リロードタイム
int shootDelay[] ={8, 3, 80, 25};//射撃ディレイ
int Baction[][] = new int[25][3];
int BCount = 0;

ArrayList<Integer> BAction = new ArrayList<Integer>();

void shot() {//射撃処理

  viewAmmo();

  if (shootCount == 0 && reload[weapon] != 0) {//射撃ディレイの誤作動対策
    shootCount += 1;
  }

  if (shootCount > 0) {//射撃ディレイのカウント
    shootCount += 1;
    if (ammoLeft[weapon] < 1) {////////////////弾切れ→リロード////////////////
      reload[weapon] +=1;//リロードカウント
      switch(weapon) {
      case 0:
        if (reload[weapon] >= reloadDelay[weapon]) {//Assault Rifle
          reload[weapon] = 0;
          shootCount = 0;
          ammoLeft[weapon] = 30;
        }
        break;

      case 1:
        if (reload[weapon] >= reloadDelay[weapon]) {//PDW
          reload[weapon] = 0;
          shootCount = 0;
          ammoLeft[weapon] = 35;
        }
        break;

      case 2:
        if (reload[weapon] >= reloadDelay[weapon]) {//Sniper
          reload[weapon] = 0;
          shootCount = 0;
          ammoLeft[weapon] = 5;
        }
        break;

      case 3:
        if (reload[weapon] >= reloadDelay[weapon]) {//Shield
          reload[weapon] = 0;
          shootCount = 0;
          ammoLeft[weapon] = 15;
        }
        break;
      }
    } else {
      switch(weapon) {////////////射撃ディレイ///////////////////
      case 0:
        if (shootCount >=shootDelay[weapon]) {//Assault Rifle
          shootCount = 0;
        }
        break;

      case 1:
        if (shootCount >=shootDelay[weapon]) {//PDW
          shootCount = 0;
        }
        break;

      case 2:
        if (shootCount >=shootDelay[weapon]) {//Sniper
          shootCount = 0;
        }
        break;

      case 3:
        if (shootCount >=shootDelay[weapon]) {//Shield
          shootCount = 0;
        }
        break;
      }
    }
  }

  if ((shootCount == 0)&&(stage ==2)&&(mousePressed == true)) {//射撃ディレイ確認
    strokeWeight(3); 
    peneCal = penetration[weapon];
    ammoLeft[weapon] -= 1;//弾薬消費
    shootCount += 1;//発射後ディレイの開始

    BAction.add(1);//経過時間 BulletAction
    BAction.add((int)random(-30, 30));//回転
    BAction.add((int)random(5, 15));//高さ
    BAction.add((int)random(-5, 25));  //横移動

    ///////////////////////////////////アサルトライフル//////////////////////////

    if (weapon != 3) {//アサルトライフル

      XYshoot = new PVector(mouseX-hip, mouseY -armTalls);//ベクトル計算
      for (float lo=1; 200>lo; lo++) {//座標を伸ばしていく
        XYshoot.normalize();//単位ベクトル化
        XYshoot.mult(lo*5.0);//直線状に射撃（スカラー倍）
        for (int m=blockCount-1; m>-1; m--) { //当たり判定
          if (block[m][0] - block[m][2]/2 < hip + XYshoot.x
            && block[m][0] + block[m][2]/2 > hip + XYshoot.x
            && block[m][1] - block[m][3]/2 < armTalls + XYshoot.y
            && block[m][1] + block[m][3]/2 > armTalls + XYshoot.y) {
            peneCal -=1;
            if (peneCal <=0 ) { //貫通力の限界
              line(hip, armTalls, hip + XYshoot.x, armTalls + XYshoot.y);//射撃線描写
              return;
            }
          }
        }
      }
      line(hip, armTalls, hip + XYshoot.x, armTalls + XYshoot.y);//命中しなかった場合の射撃線

      ////////////////////////////ショットガン///////////////////////////////////////////////////////////
    } else if (weapon == 3) {//ショットガン

      int rememberPene = peneCal;
      int dif = (int)dist(hip, armTalls, mouseX, mouseY);
      for (int r=0; r<8; r++) {
        float shotgun_corX = random(-50, 50) * dif/500;
        float shotgun_corY = random(-50, 50) * dif/500;
        XYshoot = new PVector(mouseX-hip + shotgun_corX, mouseY -armTalls + shotgun_corY);//ベクトル計算
        peneCal = rememberPene;
        
        for (float lo=1; lo<200 ; lo++) {//座標を伸ばしていく
          XYshoot.normalize();//単位ベクトル化
          XYshoot.mult(lo*5.0);//直線状に射撃（スカラー倍）
          for (int m=blockCount-1; m>-1; m--) { //当たり判定
            if (block[m][0] - block[m][2]/2 < hip + XYshoot.x
              && block[m][0] + block[m][2]/2 > hip + XYshoot.x
              && block[m][1] - block[m][3]/2 < armTalls + XYshoot.y
              && block[m][1] + block[m][3]/2 > armTalls + XYshoot.y) {
              peneCal -=1;
              if (peneCal <=0 ) { //貫通力の限界
                line(hip, armTalls, hip + XYshoot.x, armTalls + XYshoot.y);//射撃線描写
                println("shotgun"+ r);
                lo += 1000;
                break;
              }
            }
          }
          if (lo == 199) {
            line(hip, armTalls, hip + XYshoot.x, armTalls + XYshoot.y);//命中しなかった場合の射撃線
          }
          
        }
        
      }
    }
  }
}


void viewAmmo() {//////////////////////////////残弾数の表示//////////////////////
  if (ammoLeft[weapon] == 0) {
    float ammolabel =((float)reload[weapon]/reloadDelay[weapon]);//弾切れ時のリロード演出
    fill(50, ammolabel*255);
    noStroke();
    rect(ammolabel*width/2, 520, ammolabel*width, 40);
    stroke(0);
  } else {

    int roadMag = 10;
    if (shootCount != 0)roadMag = (int)( 10* ((float)shootCount/shootDelay[weapon]) );//弾押し込みモーション
    image(ammo[0], 5, 520 - roadMag, 8, 40);//弾表示

    for (int i=1; i<ammoLeft[weapon]; i++ ) {
      image(ammo[0], 5+i*10, 520, 8, 40);//弾表示
    }
  }

  int doCar = ((BAction.size()))/4;//薬莢アクション　時間・回転・高さ・横 の順にpush済み
  // println(doCar +" "+ BAction.size());

  for (int i=doCar; 0<i; i--) { ///iを＋１すればいいのでは？
    if (frameCount %2 == 0)BAction.set( (i-1)*4, BAction.get((i-1)*4)+1);//時間経過

    pushMatrix();
    translate(5 + BAction.get((i-1)*4+3) * BAction.get((i-1)*4), 510 - 2*BAction.get((i-1)*4+2) * BAction.get((i-1)*4) + BAction.get((i-1)*4+2)/4 * BAction.get((i-1)*4)* BAction.get((i-1)*4) );//座標中心を薬莢の位置に
    rotate(radians(BAction.get((i-1)*4+1) * BAction.get((i-1)*4)));//回転
    image(ammo[1], 0, 0, 8, 40);
    popMatrix();
    if (BAction.get((i-1)*4) >15) BAction.subList(((i-1)*4), ((i-1)*4)+4).clear();//処理が終わった薬莢の消去
  }
}