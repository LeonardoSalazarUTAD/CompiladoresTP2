%{
int bateria = 100;
int carga = 0;
int manutencao = 0;
char localizacao[] = "posto de carregamento";

void imprimirEstado() {
    printf("Estado Atual:\n");
    printf("Bateria: %d%%\n", bateria);
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
        printf("Alerta: A bateria já está a 100%. O veículo não pode ser carregado.\n");
        bateria = 100;
    }

    if (manutencao > 3) {
        printf("Alerta: O veículo foi chamado à manutenção mais de 3 vezes. Resetando contador.\n");
        manutencao = 0;
    }
}

%}

%%

<MANUTENCAO>MANUTENCAO([0-2]) { printf("Instrucao: MANUTENCAO(%s)\n", yytext); }
<MANUTENCAO, INITIAL>MANUTECAO([0-2]) { 			if}

<CARREGABATERIA>CARREGA-BATERIA([0-2]) { printf("Instrucao: CARREGA-BATERIA(%s)\n", yytext); }

<ENTREGA>ENTREGA\([A-Z]{2}[([1-9]|[1-9][0-9]|100),[A-Za-z0-9]{5},[1-9][0-9]*\) { printf("Instrucao: ENTREGA(%s)\n", yytext); }
 
<RECOLHE>RECOLHE([[A-Za-z0-9]{5},[1-9][0-9]*)]) { printf("Instrucao: RECOLHE(%s)\n", yytext); }

<ESTADO>ESTADO((B|M|T|(B,M)|(M,B)|(B,T)|(T,B)|(M,T)|(T,M)|(B,M,T)|(B,T,M)|(M,T,B)|(M,B,T)|(T,B,M)|(T,M,B))) { printf("Instrucao: ESTADO(%s)\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
