boolean MyServer = true;//サーバー主か？
String transData = "";

int TData[] = new int[16];

void serverWorking(){
  Client c = server.available();
  if(c != null){
    String s = c.readStringUntil('\n');
    if(s != null){
      println(s);
      String[] reserveMD = splitTokens(s);

      for(int i = 0 ; i < reserveMD.length ; i++){
      EM[i+1]= float(reserveMD[i]);//データ受け取り
      }
    }
  }
  
 transData = leftKnee +" "+ rightKnee +" "//////１～１０射撃かっこつける
          + leftFootX +" "+ rightFootX +" "
          + leftFootY +" "+ rightFootY +" "
          + hip +" "+ tall +" "
          + y + " " + sit + " "
          + k + " " + weapon + " "/////１１～１２銃表示　k角度
          + Tshooting + " " +//何の銃を使ってるか
          + TData[0] + " " + TData[1] + " "/////１4～１5通常射撃線
          + TData[2] + " " + TData[3] + " "
          + TData[4] + " " + TData[5] + " "
          + TData[6] + " " + TData[7] + " "
          + TData[8] + " " + TData[9] + " "
          + TData[10] + " " + TData[11] + " "
          + TData[12] + " " + TData[13] + " "
          + TData[14] + " " + TData[15] + " "/////１６～２９散弾射撃戦用変数
          + toStageInfo + " " + block[blockCount-1][2] + " "
          + block[blockCount-1][3] + " " + block[blockCount-1][0] + " "//３０～３３ステージ描写情報
          
          +"\n";
  server.write(transData);
  toStageInfo =0;//ステージ描写の初期化
}