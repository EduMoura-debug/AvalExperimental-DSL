// Montar o grid

int size = 5;       // Tamanho da célula
int col = 600/size; // Tamanho coluna
int row = 600/size; // Tamanho linha

int [][] grid = new int[col][row]; 

// Estado Inicial
{ 
  for (int y = 0; y <row; y++) {
    for ( int x = 0; x < col; x++) {
      grid[x][y] = int(random(2));
      
    }
  }
}

// Setup Tela
void setup(){
 size(600,600);
 frameRate(24); 
}

// Draw Tela
void draw(){
 background(0);  

// Próxima Geração
 int [][] next_grid = new int[col][row]; 
 
 for (int y = 1; y < row - 1 ; y++) {
   for ( int x = 1; x < col - 1; x++) {
     int vizinhos = contaVizinhos(x,y);
     next_grid[x][y] = gameOfLife(grid[x][y],vizinhos);
    }
  }
  grid = next_grid;
  drawGrid();
}

// Contar Vizinhos
int contaVizinhos(int x, int y){
  
  int vizinhos = 0;
  
  for (int i = -1; i <= 1; i++){
    for (int j=-1; j <= 1 ; j++){
      vizinhos += grid[x+j][y+i];
    }
  }
  
  vizinhos -= grid[x][y];
  return(vizinhos);

}

// Aplicar Regras
int gameOfLife(int status, int vizinhos) {
  
  //Qualquer célula viva com mais de três vizinhos vivos morre 
  if (status == 1 && vizinhos > 3) return(0); //superpopulação
  
  // Qualquer célula viva com menos de dois vizinhos vivos morre
  else if (status == 1 && vizinhos < 2) return(0); // subpopulação
  
  //Qualquer célula morta com três vizinhos vivos se torna viva 
  else if ( status == 0 && vizinhos == 3) return(1); // reprodução 

  else return(status);

}

// Draw Grid
void drawGrid() {

 for (int y = 0; y <row; y++) {
   for ( int x = 0; x < col; x++) {
   
     if(grid[x][y] == 1) {
         fill(192);
     }else {
         fill(70);  
       }
     rect(x*size,y*size,size,size);
    
    }
  }
}

// Eventos
/*
void mousePressed() { 
   int cellX = mouseX / size;
   int cellY = mouseY / size;
   
   grid[cellX][cellY] = 1 - grid[cellX][cellY];
}
*/
