// https://github.com/AlexMFV/Predator-and-Prey/blob/master/Predator_Prey/Predator_Prey.pde

class Predator{ //Classe referente ao predador
  int x;
  int y;
  int health;
  int nbs;
  int isDead;
  
  Predator(){ // Iniciar célula de predador
    x = (int)random(width);
    y = (int)random(height);
    health = (int)random(500, 1000);
  }
  
  Predator(int nx, int ny){ // Nasce um predador
    x = nx;
    y = ny;
    health = (int)random(500, 1000);
  }
  
  void move(){ // Movimento Aleatório da célula em 4 direções
    switch((int)random(0,4)){
      case 0: y++; if(y > height) y=0; break; //Baixo
      case 1: y--; if(y < 0) y=height; break; //Cima
      case 2: x++; if(x > width) x=0; break;  //Direita
      case 3: x--; if(x < 0) x=width; break;  //Esquerda
    }
  }
  
  void health(){ //Diminuindo a vida do predador até ele morrer
    health--;
    if(health <= 0)
      isDead = 1;
  }
  
  void eat(int boost, int x, int y, int idx){ //Consumir uma presa... Aumento de vida e geração de um novo predador
    health += boost;
    prey.remove(idx);
    preds.add(new Predator(x, y));
  }
}

class Prey{ // Classe referente a presa
  int x;
  int y;
  int health;
  int nbs;
  int hpAux;
  int isPregnant;
  int PregCont;
  int isDead;
  
  Prey(){ //Iniciar célula Presa
    x = (int)random(width);
    y = (int)random(height);
    health = (int)random(350, 500);
    hpAux = 0;
    PregCont = 0;
    isDead = 0;
  }
  
  Prey(int nx, int ny){ // Nasce uma nova Presa
    x = nx;
    y = ny;
    health = (int)random(350, 500);
    hpAux = 0;
    PregCont = 0;
    isDead = 0;
  }
  
  void health(){ //Aumentar vida constantemente da presa e atualizar nível de reprodução
    hpAux++;
    
    if(hpAux > health){
      hpAux = 0;
      isPregnant = 1;
      PregCont++;
      
      if(PregCont > 2) //Após duas reproduções ela morre
        isDead = 1;
    }
  }
  
  void haveBaby(){ // Geração de nova presa
    isPregnant = 0;
    prey.add(new Prey(x++, y--)); //Random Location to alter
  }
  
  void move(){ // Movimento Aleatório da célula em 4 direções
    switch((int)random(0,4)){
      case 0: y++; if(y > height) y=0; break; //Baixo
      case 1: y--; if(y < 0) y=height; break; //Cima
      case 2: x++; if(x > width) x=0; break;  //Direita
      case 3: x--; if(x < 0) x=width; break;  //Esquerda
    }
  }
}



//*********************************VARIAVEIS**********************************\\
// Montar o grid
int size = 1500;    // Tamanho da célula
int col = 600/size; // Tamanho coluna
int row = 600/size; // Tamanho linha

ArrayList<Predator> preds = new ArrayList<Predator>();
ArrayList<Prey> prey = new ArrayList<Prey>();

color color_prey = color(0, 200, 0); // Cor da Presa = Verde
color color_predator = color(200, 0, 0); // Cor do Predador = Vermelho
color color_ground = color(0); // Cor do Vazio = Preto

int state_ground = 0, state_prey = 1, state_predator = 2; //Constantes de Estado
int prey_count = 0, predator_count = 0; //Contadores do número de criaturas por tipo



//********************************SETUP**************************************\\
// Setup Tela
void setup(){
 size(900,900);
 frameRate(24); 
 noSmooth();
 stroke(48);
 background(0);
 
 drawGrid();
}


//********************************DRAW***************************************\\
// Draw Tela
void draw(){
  background(0);
  for(int idx = 0; idx < 1; idx++){
    MovePredators(); //Move
    MovePreys();
    
    HealthPredator(); //Health Change
    HealthPrey();
    
    PredEat(); //Eat //Life and Death
    BabyPrey();
    
    PredDead();
    PreyDead();
  }
}

void MovePredators(){
  for(Predator pred : preds){
    pred.move();
    set(pred.x, pred.y, color_predator);
  }
}

void MovePreys(){
  for(Prey pr : prey){
    pr.move();
    set(pr.x, pr.y, color_prey);
  }
}

void HealthPredator(){
  for(Predator pred : preds){
    pred.health();
  }
}

void HealthPrey(){
  for(Prey pr : prey){
    pr.health();
  }
}

void PredEat(){
  int cntPred = preds.size();
  int cntPrey = prey.size();
  
  int x;
  int y;
  
  Predator pred;
  Prey pr;
  
  for(int i = 0; i < cntPred; i++){
    pred = preds.get(i);
    x = pred.x;
    y = pred.y;
    
     for(int j = 0; j < cntPrey; j++){
       pr = prey.get(j);
       
       if(CheckAdjacent(pr.x, pr.y, x, y) == 1){
         pred.eat(pr.hpAux, pr.x, pr.y, j);
         cntPrey--;
       }
     }
  }
}

int CheckAdjacent(int prX, int prY, int X, int Y){
  if(prX >= X-1 && prX <= X+1){
    if(prY >= Y-1 && prY <= Y-1)
      return 1;
    else
      return 0;
  }
  else
    return 0;
  
}

void PredDead(){
  int cnt = preds.size();
  
  for(int idx = 0; idx < cnt; idx++){
    if(preds.get(idx).isDead == 1){
      cnt--;
      preds.remove(idx);
    }
  }
}

void PreyDead(){
  int cnt = prey.size();
  
  for(int idx = 0; idx < cnt; idx++){
    if(prey.get(idx).isDead == 1){
      cnt--;
      prey.remove(idx);
    }
  }
}

void BabyPrey(){
  int cnt = prey.size();
  
  for(int idx = 0; idx < cnt; idx++){
    if(prey.get(idx).isPregnant == 1)
      prey.get(idx).haveBaby();
  }
}


// Draw Grid
void drawGrid() {

  for(int idx = 0; idx < (size - 500); idx++){
    preds.add(new Predator());
    set(preds.get(idx).x, preds.get(idx).y, color(255, 0, 0));
  }
  
  for(int idx = 0; idx < size; idx++){
    prey.add(new Prey());
    set(prey.get(idx).x, prey.get(idx).y, color(255, 0, 0));
  }
  
}
