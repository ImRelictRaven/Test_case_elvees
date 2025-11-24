#include "verilated.h"
#include "Valu_tb.h"  // класс генерируется Verilator'ом из модуля alu_tb


vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    Valu_tb* top = new Valu_tb;

    while (!Verilated::gotFinish()) {
        top->eval();
        main_time++;
    }

    delete top;
    return 0;
}


