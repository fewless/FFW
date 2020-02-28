int blockCount = 1;//ブロックの数
int step = 0;//工程
int toStageInfo =0;//ステージ情報を送信したか？

void stageDraw() {//クラス化しろってんだよっぉぉぉぉっぉぉ

  strokeWeight(2);

if(MyServer == true){ 
  if (frameCount % 30 ==0 && blockCount<HowManyBlocks ) {//5秒おき
    block[blockCount][2] = (int)random(30, 150);//横幅決定 
    block[blockCount][3] = (int)random(30, 100); //高さ決定
    block[blockCount][0] = (int)random(block[blockCount][2], 960 -block[blockCount][2]);//X座標決定
    blockCount +=1;
    toStageInfo =1;//ブロック規定したよ！
  }
}
  if(EM[30] == 1){
    block[blockCount][2] = (int)EM[31];//横幅決定 
    block[blockCount][3] = (int)EM[32]; //高さ決定
    block[blockCount][0] = (int)EM[33];//X座標決定
    blockCount +=1;
  }


  for (int i = 0; blockCount>i; i++) {

    if (block[i][5] != 2) {
      block[i][4] += 1;
      block[i][1] = block[i][4]*block[i][4]/2;//ブロック落下

      if (blockCount != 0) {
        for (int r = i-1; 0<r; r--) {
           if(abs(block[i][0] - block[r][0]) < block[r][2]/2){ //半分以上重なってる？
             block[i][5] =1;
             if (block[i][1] > block[r][1] - block[r][3]/2 - block[i][3]/2 ) {//重なってるぜ
                block[i][1] = block[r][1] - block[r][3]/2 - block[i][3]/2;//落下限界
                block[i][5] =2;
                break;
             } 
           }
        }
        if (block[i][1] > 500- block[i][3]/2 && block[i][5] !=1) {//下に何もない
          block[i][1] = 500- block[i][3]/2;//落下限界
          block[i][5] =2;
      }
      }
      
      
    }
fill(130 + i);
    rect(block[i][0], block[i][1], block[i][2], block[i][3]);
  }
}