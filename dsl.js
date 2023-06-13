function functor(value) {
    if(typeof value == "number") {
        value = new NumericConstant(value);
    }
    return value;
}

class NumericConstant {
    constructor(value) {
        this.value = value;
    }

    generate() {
        return this.value;
    }
}

class RuleList {

    constructor(list) {
        this.list = list;
    }

    generate() {
        let resp = [];
        for(let r of this.list) {
            let [ condicao, acao ] = r;
            resp.push(`\tif(${condicao.generate()}){${acao.generate()}}`);
        }
        return resp.join("\n");
    }
}

class SetVarStateCommand {
    constructor(varIndex, value) {
        this.varIndex = varIndex;
        this.value = functor(value);
    }

    generate() {
        return `nextState[${this.varIndex}]=${this.value.generate()};`;
    }
}

class BinaryOperator {
    constructor(op, a, b) {
        this.op = op;
        this.a = functor(a);
        this.b = functor(b);
    }

    generate() {
        return `(${this.a.generate()}${this.op}${this.b.generate()})`;
    }
}


class VarState {
    constructor(index) {
        this.index = index;
    }

    setState(value) {
        return new SetVarStateCommand(this.index, value);
    }

    generate() {
        return `currentState[${this.index}]`;
    }
}

class NeighborStatus {
    constructor(index, neighborFunction) {
        this.index = index;
        this.neighborFunction = neighborFunction;
    }

    declaration() {
        return `\tneighborStatus[${this.index}]=${this.neighborFunction}(${this.index});`;
    }

    generate() {
        return `neighborStatus[${this.index}]`; 
    }
}

class DSL {

    constructor() {
        this.stateVars = [];
        this.neighborVars = [];
    }

    stateVar() {
        let index = this.stateVars.length;
        if(index < 4) {
            let sv = new VarState(index)
            this.stateVars.push(sv);
            return sv;
        } else {
            throw new Error("Muita variavel");
        }
    }

    createNeighborFunction(stateVar, functionName) {
        let index = stateVar.index;
        if(this.neighborVars[index]) {
            throw new Error("Vizinho ja usado");
        } else {
            let nv = new NeighborStatus(index, functionName);
            this.neighborVars[index] = nv;
            return nv;
        }
    }

    sumNeighbors(stateVar) {
        return this.createNeighborFunction(stateVar, "sumNeighbors");
    }

    rules(ruleList) {
        this.ruleList = new RuleList(ruleList);
    }

    operators() {
        return {
            AND : ( c1, c2 ) => new BinaryOperator("&&", c1, c2),
            OR  : ( c1, c2 ) => new BinaryOperator("||", c1, c2),
            EQ  : ( o1, o2 ) => new BinaryOperator("==", o1, o2),
            NE  : ( o1, o2 ) => new BinaryOperator("!=", o1, o2),
            GT  : ( o1, o2 ) => new BinaryOperator(">", o1, o2),
            GE  : ( o1, o2 ) => new BinaryOperator(">=", o1, o2),
            LT  : ( o1, o2 ) => new BinaryOperator("<", o1, o2),
            LE  : ( o1, o2 ) => new BinaryOperator("<=", o1, o2)
        }
    }

    generate() {
        let resp = [];
        resp.push("vec4 executeRules(vec4 currentState) {");
        resp.push("\t/** Declarations **/");
        resp.push("\tvec4 nextState = vec4(0.0);");
        resp.push("\tvec4 neighborStatus= vec4(0.0);");
        resp.push("\n\t/** Neighbor Status **/");
        for(let n of this.neighborVars) {
            resp.push(n.declaration());
        }
        resp.push("\n\t/** Rules **/");
        resp.push(this.ruleList.generate());
        resp.push("\n\treturn nextState;");
        resp.push("}");
        return resp.join("\n");
    }
}

/* EXEMPLO: JOGO DA VIDA ABSTRAIDO

const dsl = new DSL();
const { AND, EQ, GT, LT, GE, LE } = dsl.operators();

const vivo = dsl.stateVar();
const neighbors = dsl.sumNeighbors(vivo);

dsl.rules([
    [ AND( GT(vivo,0.0) , AND(LE(neighbors,4.0), GE(neighbors,3.0))), vivo.setState(1.0)],
    [ AND( EQ(vivo,0.0) , AND(LT(neighbors,4.0), GT(neighbors,2.0))), vivo.setState(1.0)]
]);
*/

/*******************************************************************************************/
// Utilizando o exemplo de abstração acima do Jogo da Vida, crie uma abstração de um modelo
// de predador e presa. Instancie a classe, defina as constantes de operadores, estados e 
// vizinhança e declare a lista de regras. 
//
// Para executar: node dsl.js
/*******************************************************************************************/
/* INSERIR CÓDIGO AQUI */






console.log(dsl.generate());

