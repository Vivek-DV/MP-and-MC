#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_SIZE 10
#define MAX_LINES 50
#define MAX_SYMBOLS 30

char opcode[MAX_SIZE], operand[MAX_SIZE], label[MAX_SIZE], hexcode[MAX_SIZE], line[MAX_LINES];
int locctr, start, end_locctr, size, sym_count = 0, op_count = 0;
FILE *fp1, *fp2, *fp3, *fp4;

typedef struct {
    char label[MAX_SIZE];
    int addr;
} SYMTAB;

typedef struct {
    char opcode[MAX_SIZE];
    char hexcode[MAX_SIZE];
} OPTAB;

SYMTAB ST[MAX_SYMBOLS];
OPTAB OT[MAX_SYMBOLS];

void read_SYMTAB() {
    int i = 0;
    while (fscanf(fp2, "%s %d", ST[i].label, &ST[i].addr) != EOF) {
        i++;
    }
    sym_count = i;
}

void read_OPTAB() {
    int i = 0;
    while (fscanf(fp1, "%s %s", OT[i].opcode, OT[i].hexcode) != EOF) {
        i++;
    }
    op_count = i;
}

int get_address(char *label) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(ST[i].label, label) == 0) {
            return ST[i].addr;
        }
    }
    return -1; 
}

int main() {
    fp1 = fopen("optab.txt", "r");
    fp2 = fopen("symtab.txt", "r");
    fp3 = fopen("intermediate.txt", "r");
    fp4 = fopen("Output.txt", "w");

    if (!fp1 || !fp2 || !fp3 || !fp4) {
        printf("Error opening files.\n");
        return 1;
    }
    read_OPTAB();
    read_SYMTAB();

    fscanf(fp3, "%s %s %x", label, opcode, &start);
    locctr = start;

    while (fgets(line, sizeof(line), fp3)) {
        sscanf(line, "%x %s %s %s", &locctr, label, opcode, operand);
        if (strcmp(opcode, "END") == 0) {
            end_locctr = locctr;
            break;
        }
    }
    size = end_locctr - start;

    fprintf(fp4, "H^%s^%06x^%06x\n", label, start, size);
    rewind(fp3);
    fscanf(fp3, "%s %s %x", label, opcode, &start);
    while (fgets(line, sizeof(line), fp3)) {
        int instruction_length = 0;
        sscanf(line, "%x %s %s %s", &locctr, label, opcode, operand);
        
        if (strcmp(opcode, "END") == 0) {
            fprintf(fp4, "E^%06x\n", start);
            break;
        }

        int opcode_found = 0;
        for (int i = 0; i < op_count; i++) {
            if (strcmp(opcode, OT[i].opcode) == 0) 
            {
                int address = get_address(operand);
                if (address != -1) {
                    instruction_length = 6;
                    fprintf(fp4, "T^%06x^%02x^%s^%06x\n", locctr, instruction_length, OT[i].hexcode, address);
                } else {
                    printf("Error: Undefined symbol %s at address %x\n", operand, locctr);
                    return 1;
                }
                opcode_found = 1;
                break;
            }
        }

        if (!opcode_found) {
            if (strcmp(opcode, "WORD") == 0) {
                instruction_length = 6;
                fprintf(fp4, "T^%06x^%02x^%s^%06x\n", locctr, instruction_length, "00", atoi(operand));
            } else if (strcmp(opcode, "BYTE") == 0) {
                if (operand[0] == 'C' || operand[0] == 'c') {
                    instruction_length = strlen(operand) - 3;
                    fprintf(fp4, "T^%06x^%02x^%s^%s\n", locctr, instruction_length, "C", operand + 2);
                } else {
                    instruction_length = (strlen(operand) - 3) / 2;
                    fprintf(fp4, "T^%06x^%02x^%s^%s\n", locctr, instruction_length, "H", operand + 2);
                }
            }
        }
    }

    fclose(fp1);
    fclose(fp2);
    fclose(fp3);
    fclose(fp4);

    return 0;
}
