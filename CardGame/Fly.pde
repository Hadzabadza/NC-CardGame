class Fly {
  int[] chromos;
  PVector fitness=new PVector();
  float fit;

  Fly(int ind) {
    chromos=new int[ind];
    for (int i=0; i<chromos.length; i++)
    {
      chromos[i]=round(random(1));
    }
    evaluate();
  }

  Fly(int[] input) {
    chromos=input;
    evaluate();
  }

  float evaluate() {
    fit=0;
    fitness=new PVector(0,0);
    PVector groupValue=new PVector(0, 0);
    PVector groupMin=new PVector(0, 0);
    PVector groupMax=new PVector(0, 0);
    int divider=0;
    
    for (int i=0; i<chromos.length; i++) {
      if (chromos[i]==0) {
        groupValue.x+=i+1;
        divider++;
      } else {
        if (groupValue.y==0) {
          groupValue.y=i+1;
        } else
        {
          groupValue.y*=(i+1);
        }
      }
    }
    if (groupValue.x==0||groupValue.y==0) 
    { 
      fitness.x=1;
      fitness.y=1;
      fit=fitness.x+fitness.y;
      return fit;
    }
    groupMin.y=1;
    groupMax.y=1;
    groupMin.x=divider*(1+divider+1)/2;
    groupMax.x=divider*(2*chromos.length+divider+1);//Simplified version of: (chromos.length*(chromos.length+1)-(chromos.length-divider)*(1+chromos.length-divider))/2;
    /*for (int i=0; i<=divider-1; i++) {
     groupMin.x+=i+1;
     groupMax.x+=chromos.length-i;
     }*/
    for (int i=divider; i<chromos.length; i++) {
      groupMax.y*=i+1;
      groupMin.y*=i-divider+1;
    }

    if (groupValue.x>group1goal) {
      fitness.x=(groupValue.x-group1goal)/(groupMax.x-group1goal);
      //println(group1goal+" - "+(int)groupValue.x+" - "+(int)groupMax.x);
    } else {
      fitness.x=(group1goal-groupValue.x)/(group1goal-groupMin.x);
      //println((int)groupMin.x+" - "+(int)groupValue.x+" - "+group1goal);
    }
    /*
    if (groupValue.y>group2goal) {
     fitness.y=(groupValue.y-group2goal)/(groupMax.y-group2goal);    
     //println(group2goal+" - "+(int)groupValue.y+" - "+(int)groupMax.y);
     } else {
     fitness.y=(group2goal-groupValue.y)/(group2goal-groupMin.y);
     //println((int)groupMin.y+" - "+(int)groupValue.y+" - "+group2goal);
     }
     */
    if (groupValue.y>group2goal) { 
      fitness.y=(groupValue.y-group2goal)/(groupMax.y-group2goal);
    } else { 
      fitness.y=(group2goal-groupValue.y)/(group2goal-groupMin.y);
    }
    /*
    print("[");
     for (int i=0; i<chromos.length; i++)
     {
     print (chromos[i]+" ");
     }
     println("] "+fitness.x+" "+fitness.y+" "+(fitness.x*fitness.y));
     println();
     */
    fit=fitness.x+fitness.y;
    return fit;
  }
}