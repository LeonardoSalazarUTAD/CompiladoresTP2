%{
#include <stdio.h>
#include <string.h>

char localizacao[50] = "posto de carregamento";
int bateria = 100;
int carga = 0;
int manutencao = 0;
int num_materiais = 0;
char materiais[1000] = "";
int tarefas = 0;

void atualiza_estado();
void RECENTREGA(char* c);
void ENTREGA(char* l, char* m, int q);
void RECOLHEV1(char* lista);
void RECOLHEV2(char* trupla);
void imprimirEstado(char* es);

void atualiza_estado() {
    printf("\nEstado Atual\n");
    
    printf("Localização: %s\n", localizacao);
    printf("Bateria: %dpor cento\n", bateria);
    printf("Materiais: %s\n", materiais);
    printf("Numero Materiais: %d\n", num_materiais);
    printf("Manutenção: %d vez(es)\n", manutencao);
}

void imprimirEstado(char* es) {
    printf("Estado atual do veículo:\n");

    for(int i=0; i<sizeof(es); i++) {
        if(es[i] == 'B') {
            printf("Bateria: %dpor cento\n", bateria);
        }
        if (es[i]=='M') {
            printf("Materiais: %s\n", materiais);
            printf("Numero Materiais: %d\n", num_materiais);
        }
        if (es[i]=='T') {
            printf("Manutenção: %d vezes\n", manutencao);
        }
    }
}

void EstadoFinal() {
    printf("\nEstado Final\n");
    
    printf("Localização: %s\n", localizacao);
    printf("Bateria: %dpor cento\n", bateria);
    printf("Materiais: %s\n", materiais);
    printf("Numero Materiais: %d\n", num_materiais);
    printf("Manutenção: %d vez(es)\n", manutencao);
}

//Função para alertar o utilizador de erros
void alerta(char* err) {
    printf("\nAVISO:\n %s\n", err);
}

void MANUTENCAO(char* t) {
    int v;
    sscanf(&t[11], "%d", &v);

    if(manutencao%3==0 && manutencao!=0){
        alerta("Este veiculo atingiu as 3 manutenções");
        manutencao=0;
    }
        
    if (v == 0) { 
        bateria=bateria-5;
        strcpy(localizacao, "posto de manutencao");
        manutencao++;
    }
    else if (v == 1) { 
        bateria=bateria-5;
        strcpy(localizacao, "posto de manutencao");
        manutencao++;
        
        if (tarefas!=0) { 
            alerta("Ainda há tarefas pendentes.");
        }
    }
    else if (v == 2) {
        bateria=bateria-5;
        strcpy(localizacao, "posto de manutencao");
        manutencao++;
    }
    atualiza_estado();
}

void CARREGABATERIA(char* t) {
    int v;
    sscanf(&t[16], "%d", &v);

    if (bateria ==100){
        alerta("BATERIA COMPLETA!");
        return;
    }

    if (v == 0) { 
        bateria=bateria-5;  //perde 5% sempre que vai ao posto de carregamento
        strcpy(localizacao, "posto de carregamento");
        bateria = 100;
        tarefas = 0; 
    }
    else if (v == 1) { 
        bateria=bateria-5;
        strcpy(localizacao, "posto de carregamento");
        bateria = 100;
        
        if (tarefas!=0){
            alerta("Ainda há tarefas pendentes. ");
        }
    }
    else if (v == 2) { 
        bateria=bateria-5;  //perde 5% sempre que vai ao posto de carregamento
        strcpy(localizacao, "posto de carregamento");
        bateria = 100;
    }
    atualiza_estado();
}

void RECENTREGA(char* c){
    char c1[6]; 
    char c2[6];
    int num; 

    sscanf(c, "ENTREGA(%5[^,],%5[^,],%d)", c1, c2, &num);

    ENTREGA(c1, c2, num);
}

void ENTREGA(char* LUG, char* MAT, int QUANT) {
    if (bateria <= 5  || bateria -10-num_materiais < 5 || bateria -5 -num_materiais < 5){
        alerta("Bateria Insuficiente! Deve dirigir se ao Posto de Carregamento!");
        return;
    }
    if(strcmp(localizacao,LUG)){
        if (strcmp(localizacao, "armazém") || strcmp(localizacao, "posto de carregamento") || strcmp(localizacao,"posto de manutencao")){
            bateria=bateria -5-num_materiais;
        }
        else{
            bateria=bateria-10-num_materiais;
        }
    }
    if (strstr(materiais, MAT)== NULL){
        alerta("O Veiculo não tem o material mencionado!");
        return;
        
    }

    strcpy(localizacao, LUG);

    char materiaisnew [1000];  
    int matauxint=0;             
    char mataux[5];          
    char *parte = strtok(materiais, " "); 
    char qa[10];            
    while (parte != NULL) {
        
        if (QUANT==0 && strstr(parte, MAT) != NULL){
            strcat(materiaisnew, parte);
            strcat(materiaisnew, " ");
        }
        if (strstr(parte, MAT) == NULL) {
            strcat(materiaisnew, parte);
            strcat(materiaisnew, " ");
        }
        else if(QUANT!=0){

            sscanf(parte, "%d-%s", &matauxint, mataux);
            if (matauxint-QUANT<0){
                QUANT=0;
                num_materiais-=matauxint;
            }
            else{
                matauxint-=QUANT;
                if(matauxint!=0){
                    sprintf(qa, "%d", matauxint);
                    strcat(materiaisnew, qa);
                    strcat(materiaisnew, "-");
                    strcat(materiaisnew, MAT);
                    strcat(materiaisnew, " ");
                    num_materiais-=(matauxint+QUANT);
                }
                else{
                    num_materiais-=(matauxint+QUANT);
                    QUANT=0;
                }
            }
        }
        parte = strtok(NULL, " ");
    }
    strcpy(materiais, materiaisnew);
    tarefas--;    
    materiaisnew[0]='\0';
    atualiza_estado();
}

//Recolhe a lista 
void RECOLHEV1(char* lista){
    lista=lista+9; 
    lista[strlen(lista)-2] = '\0';
    
    if (strcmp(localizacao, "armazém")){
        if (bateria==5 || bateria-10-num_materiais<5){
            alerta("Bateria insuficiente! Deve deslocar-se ao posto de carregamento!");
            return;
        }
    
        bateria=bateria-10-num_materiais;
    }

    char* START = lista;
    char* END;
    char tok[500]; 

    while ((END = strchr(START, ')')) != NULL) {
        if (END != START) {
            strncpy(tok, START, END-START);
            tok[END-START] = '\0'; 
            RECOLHEV2(tok);
        }
    
        START = END + 2; 
    }
    
    atualiza_estado();
}

//Recolhe a Trupla
void RECOLHEV2(char* trupla) {  
    char MAT[5];
    int intM;
    sscanf(trupla, "(%[^,],%d", MAT, &intM);
    
    if (num_materiais+intM>80){
        alerta("Foi adicionado apenas a quantidade permitica");
        intM=80-num_materiais;
    }
    
    char mataux[10]; 
    sprintf(mataux, "%d", intM); //sprintf passa o intm para o mataux, passando assim a ser um carater (char)
    strcat(materiais, mataux);
    strcat(materiais, "-");
    
    if (intM>=10){
        MAT[strlen(MAT)-2]='\0';
    } else{
        MAT[strlen(MAT)-1]='\0';
    }
    
    strcat(materiais, MAT); 
    strcat(materiais, " ");
    num_materiais+=intM;
    strcpy(localizacao, "armazém");
    tarefas++;
}

%}

ESTADO          ESTADO\((B|M|T|(B,M)|(M,B)|(B,T)|(T,B)|(M,T)|(T,M)|(B,M,T)|(B,T,M)|(M,T,B)|(M,B,T)|(T,B,M)|(T,M,B))\)
MANUTENCAO      MANUTENCAO\([0-2]\)
CARREGABATERIA  CARREGA-BATERIA\([0-2]\)
ENTREGA         ENTREGA\([A-Z]{2}([1-9]|[1-9][0-9]|100),[A-Za-z0-9]{5},[1-9][0-9]*\)
RECOLHE         RECOLHE\([A-Za-z0-9]{5},[1-9][0-9]*\)

%%

{ESTADO} { imprimirEstado(yytext);}

{MANUTENCAO} { MANUTENCAO(yytext); }

{CARREGABATERIA} { CARREGABATERIA(yytext); }

{ENTREGA} {; }

{RECOLHE} {RECOLHEV1(yytext); }

\n
.+
%%

int main() {
    yylex();
    return 0;
}