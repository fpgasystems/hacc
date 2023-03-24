#include <iostream>
#include <mpi.h>
#include <stdio.h>
#include "../global_params.hpp"
#include "../configs/config_000.hpp" // config_000.hpp is overwritten with the configuration you select

using namespace std;

int main(int argc, char** argv) {

	// print config values as a test
    std::cout << "N_MAX: ";
    std::cout << std::to_string(N_MAX); 

	MPI_Init(NULL, NULL);      // initialize MPI environment
	int world_size; // number of processes
	MPI_Comm_size(MPI_COMM_WORLD, &world_size);

	int world_rank; // the rank of the process
	MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

	char processor_name[MPI_MAX_PROCESSOR_NAME]; // gets the name of the processor
	int name_len;
	MPI_Get_processor_name(processor_name, &name_len);

	printf("Hello world from processor %s, rank %d out of %d processors\n", processor_name, world_rank, world_size);

	MPI_Finalize(); // finish MPI environment
}