#include <nvboard.h>
#include <Vsr.h>

static TOP_NAME dut;

static void single_cycle() {
  dut.eval();
}

void nvboard_bind_all_pins(Vsr* top);

int main() {
  nvboard_bind_all_pins(&dut);
  nvboard_init();


  while(1) {
    nvboard_update();
    single_cycle();
  }
}