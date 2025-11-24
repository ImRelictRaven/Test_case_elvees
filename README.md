## Test_case_elvees
## Как запустить симуляцию

- **Сборка и запуск одним шагом**:

```bash
make run
```

- **Явные команды (то же самое вручную)**:

```bash
verilator -Wall -sv --cc \
  rtl/top_alu_16.v rtl/74181.v rtl/74182_CLA.v \
  tb/alu_if.sv tb/alu_tb.sv \
  --top-module alu_tb \
  --exe sim_main.cpp

make -C obj_dir -f Valu_tb.mk -j"$(nproc)"

./obj_dir/Valu_tb
```

