int popSize=20;

int group1goal=36;    //Goal of sum group
int group2goal=360;   //Goal of product group

int retrySlowdown=10;  //Slows down the next generations by this modulo
int chromoLength=10; 

float mutationChance=0.05; //Mutates individual genes during crossover

ArrayList<Fly> pops;
Fly bestFly;

boolean found=false;

void setup() {
  size (100, 100);
  pops=new ArrayList<Fly>();
  for (int i=0; i<popSize; i++) {
    pops.add(new Fly(chromoLength));
  }
  bubbleSort(pops);
  info(bestFly);
  showPops();
}

void draw() {
  if (bestFly.fit==0.0) found=true;
  if (found) background(0, 255, 0);
  else background (0);
  if (frameCount%retrySlowdown==0) { nextGen(); }
}

void nextGen() {
  bubbleSort(pops);
 
  /* Saves top half of the population. Works poorly
  for (int i=0; i<popSize/4; i++)
  {
    pops.get(i).evaluate();
    pops.get(i+popSize/4).evaluate();
    Fly child1=new Fly(crossover(pops.get(i), pops.get(popSize/4+i), round(random(chromoLength))));
    Fly child2=new Fly(crossover(pops.get(i), pops.get(popSize/4+i), round(random(chromoLength))));
    pops.set(popSize/2+i, child1);
    pops.set(3*popSize/4+i, child2);
    
    mutationAttempt(child1);
    mutationAttempt(child2);
    
    if (child1.fit<bestFly.fit) bestFly=child1;
    if (child2.fit<bestFly.fit) bestFly=child2;
  }*/
  
  ArrayList<Fly> newPops=pops;
  for (int i=1; i<pops.size(); i++){
    newPops.set(i,new Fly(crossover(pops.get(i-1),pops.get(i), round(random(chromoLength)))));
    mutationAttempt(newPops.get(i));
  }
  pops=newPops;

  showPops();
  info(bestFly);
}

void bubbleSort(ArrayList<Fly> flies) {
  for (int i=0; i<flies.size(); i++) {
    boolean sorting=false;
    for (int j=0; j<flies.size()-i-1; j++)
    {
      if (flies.get(j).fit>flies.get(j+1).fit) {
        Fly temp=flies.get(j);
        flies.set(j, flies.get(j+1));
        flies.set(j+1, temp);
        sorting=true;
      }
    }
    if (!sorting) break;
  }
  bestFly=pops.get(0);
}

int[] crossover (Fly first, Fly second, int divider) {
  int [] spawn= new int[chromoLength];
  for (int i=0; i<divider; i++) { 
    spawn[i]=first.chromos[i];
  }
  for (int i=divider; i<spawn.length; i++) {
    spawn[i]=second.chromos[i];
  }
  return spawn;
}

void info(Fly f)
{
  print("[");
  for (int j=0; j<f.chromos.length; j++)
  { 
    print (f.chromos[j]+" ");
  }
  int products=1;
  int sums=0;
  for (int i=0; i<chromoLength; i++) {
    if (f.chromos[i]==1) products*=i+1;
    else sums+=i+1;
  }
  println("] "+sums+" "+products+" "+f.fitness.x+" "+f.fitness.y+" "+f.fit);
  println();
}

void showPops() {
  for (int i=pops.size()-1; i>=0; i--) {
    Fly f= pops.get(i);
    print("[");
    for (int j=0; j<f.chromos.length; j++)
    { 
      print (f.chromos[j]+" ");
    }
    int products=1;
    int sums=0;
    for (int j=0; j<chromoLength; j++) {
      if (f.chromos[j]==1) products*=(j+1);
      else sums+=j+1;
    }
    println("] "+sums+" "+products+" "+f.fitness.x+" "+f.fitness.y+" "+f.fit);
  }
  println(pops.size());
  println();
}

boolean mutationAttempt(Fly f) {
  boolean mutated=false;
  for (int i=0; i<f.chromos.length; i++) {
    if (random(1)<mutationChance) {
      mutated=true;
      if (f.chromos[i]==0) f.chromos[i]=1; 
      else f.chromos[i]=0;
    }
  }
  f.evaluate();
  return mutated;
}