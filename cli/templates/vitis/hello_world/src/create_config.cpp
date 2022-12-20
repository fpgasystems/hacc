#include <iostream>
#include <vector> // for vectors
#include <algorithm> // for find

using namespace std;

void print_vector(std::string input, vector<int> v)
{
    cout << input + "[ "; // << endl;
    //cout << "T_clk[ ";
    for (int x : v)
        cout << x << " ";
    cout << "]: "; 
    //return 0;
}

int main()
{
    //cout<<"Hello World";
    cout << "\n\e[1mcreate_config\e[0m\n";
    cout << "\n";

    struct {
        int myNum;
        string myString;
    } config;

    cout << "Simulation parameters: \n";
    // Tclk
    vector<int> T_clk_i{ 1, 2, 3, 4, 5, 10, 20, 30, 40, 50 };
    print_vector("T_clk", T_clk_i);
    int found = 0;
    int element = 0;
    vector<int>::iterator it;
    while (found != 1) {
        cin >> element; // << "\n";
        it = find(T_clk_i.begin(), T_clk_i.end(), element);
        if (it != T_clk_i.end()) {
            found = 1;
        }
        else {
            print_vector("T_clk", T_clk_i);
        }
    }

    cout << "Host parameters:  \n";
    int W_MAX;

    cout << "Device parameters: \n";
    int FPGA_CLOCK_FREQUENCY;
    int W;
    int F;

    cout << "Test parameters: \n";



    return 0;
}