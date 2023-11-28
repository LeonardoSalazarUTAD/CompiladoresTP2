%{
int bateria = 100;
int carga = 0;
int manutencao = 0;
char localizacao[] = "posto de carregamento";


 
void imprimirEstado() {
    printf("Estado Atual:\n");
    printf("Bateria: %d\n", bateria);
    printf("Localizacao: %s\n", localizacao);
    printf("Carga: %d unidades\n", carga);
    printf("Manutencao: %d vezes\n", manutencao);
    printf("\n");
}

void validarESinalizar() {
    if (carga > 80) {
        printf("Alerta: Capacidade de carga excedida! A carga será limitada a 80 unidades.\n");
        carga = 80;
    }

    if (bateria < 0) {
        printf("Alerta: Bateria insuficiente! O veículo não pode realizar a operação.\n");
        bateria = 0;
    }

    if (bateria > 100) {
        printf("Alerta: A bateria já está a 100. O veículo não pode ser carregado.\n");
        bateria = 100;
    }

    if (manutencao > 3) {
        printf("Alerta: O veículo foi chamado à manutenção mais de 3 vezes. Resetando contador.\n");
        manutencao = 0;
    }
}



%}

%x ESTADO

VALOR [0-2]

ALGARISMOA [0-9]

ALGARISMOB [1-9]

LETRA [a-zA-Z]

TUDO [A-Za-z0-9]



%% 
<INITAL>ESTADO {	
	BEGIN(ESTADO);
}





MANUTENCAO({VALOR}) { printf("Instrucao: MANUTENCAO(%s)\n", yytext); }


CARREGA-BATERIA({VALOR}) { printf("Instrucao: CARREGA-BATERIA(%s)\n", yytext); }

ENTREGA\({LETRA}{2}[({ALGARISMOA}|{ALGARISMOB}{ALGARISMOA}|100)],{TUDO}{5},{ALGARISMOB}{ALGARISMOA}*\) { printf("Instrucao: ENTREGA(%s)\n", yytext); }
 
RECOLHE({TUDO}{5},{ALGARISMOB}{ALGARISMOA}*) { printf("Instrucao: RECOLHE(%s)\n", yytext); }

<ESTADO>"(" { printf("\n\nESTADO:\n\nEncoutrou um parenteses aberto.\n"); }
<ESTADO>")" { printf("\n\nESTADO:\n\nEncoutrou um parenteses fechado.\n"); BEGIN(INITIAL); }
<ESTADO>((B|M|T|(B,M)|(M,B)|(B,T)|(T,B)|(M,T)|(T,M)|(B,M,T)|(B,T,M)|(M,T,B)|(M,B,T)|(T,B,M)|(T,M,B))) { imprimirEstado();    }
<ESTADO>. { printf("Caracter nao reconhecido: %s\n", yytext);}





%%

int main() {
    yylex();
    return 0;   
}
