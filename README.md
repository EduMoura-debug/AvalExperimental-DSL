# AvalExperimental-DSL
Avaliação Experimental para o TCC Uma DSL para facilitar o uso de Cellular Automata em GPU de Eduardo Freitas Moura

## EXEMPLO DO USO DA DSL: JOGO DA VIDA ABSTRAIDO
Esse será o input básico de um usuário para abstrair o Autômato Celular do Game of Life.

```
const dsl = new DSL();
const { AND, EQ, GT, LT, GE, LE } = dsl.operators();

const vivo = dsl.stateVar();
const neighbors = dsl.sumNeighbors(vivo);

dsl.rules([
    [ AND( GT(vivo,0.0) , AND(LE(neighbors,4.0), GE(neighbors,3.0))), vivo.setState(1.0)],
    [ AND( EQ(vivo,0.0) , AND(LT(neighbors,4.0), GT(neighbors,2.0))), vivo.setState(1.0)]
]);
```
## Exercício de avaliação
Utilizando o exemplo de abstração acima do Jogo da Vida, crie uma abstração de um modelo
de predador e presa. No código dsl.js instancie a classe, defina as constantes de operadores, estados e 
vizinhança e declare a lista de regras. Use os programas em processing como base se preciso.

(Requerimentos: node instalado) 
Para executar: 
```node dsl.js```

