float k;

void target(){//ターゲットサイトと銃の表示

  stroke(0,25,0,220);
  fill(255,0);/////////塗りつぶし禁止
  ellipse(mouseX,mouseY,50,50);//ターゲットサイト.ラウンド
  line(mouseX-30,mouseY,mouseX+30,mouseY);//縦
  line(mouseX,mouseY-30,mouseX,mouseY+30);//横
  rect(mouseX,mouseY,10,10);
  fill(255);//元に戻す
  stroke(0);
  
  armTalls = y-tall*4/5 +sit*3;//腕の座標補正値
  
  pushMatrix();
  translate(hip, armTalls);  // 原点を主人公に
  k = atan2(mouseY -armTalls, mouseX-hip);//角度の算出
  rotate(k);          // マウスカーソルの方向へ回転
  if((-1.6 <= k )&&( k <= 1.6)){//左右の判定
    image(arm[weapon],0,0);//右向いてる
  }else{
    scale(1,-1);
    image(arm[weapon],0,0);//左向いてる
    scale(1,-1);
  }
  rotate(-k);//元に戻す
  
  popMatrix();
}