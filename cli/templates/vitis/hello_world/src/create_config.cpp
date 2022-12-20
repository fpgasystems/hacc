#include <iostream>
#include <vector> // for vectors
#include <algorithm> // for find

using namespace std;

void print_vector(std::string name, vector<int> v)
{
    cout << name + "[ ";
    for (int x : v)
        cout << x << " ";
    cout << "]: "; 
}

int read_value(std::string name, vector<int> v)
{
    int found = 0;
    int element;
    vector<int>::iterator it;
    while (found != 1) {
        cin >> element;
        it = find(v.begin(), v.end(), element);
        if (it != v.end()) {
            found = 1;
        }
        else {
            print_vector(name, v);
        }
    }
    return element;
}

int main()
{

    cout << "\n\e[1mcreate_config\e[0m\n";
    cout << "\n";

    struct {
        int myNum;
        string myString;
    } config;

    // vector iterator for finding elements
    vector<int>::iterator it;
    
    cout << "Simulation parameters: \n";
    // Tclk
    vector<int> T_clk_i{ 1, 2, 3, 4, 5, 10, 20, 30, 40, 50 };
    print_vector("T_clk", T_clk_i);
    /* int found = 0;
    int T_clk;
    while (found != 1) {
        cin >> T_clk;
        it = find(T_clk_i.begin(), T_clk_i.end(), T_clk);
        if (it != T_clk_i.end()) {
            found = 1;
        }
        else {
            print_vector("T_clk", T_clk_i);
        }
    } */
    int T_clk = read_value("T_clk", T_clk_i);

    cout << "\n";

    //cout << "Test\n";

    //int Taux = read_value("T_clk", T_clk_i);

    //cout << TaT_clk;

    cout << "Host parameters:  \n";
    // W_MAX
    vector<int> W_MAX_i{ 1, 2, 4, 8, 16, 32, 64, 128, 256 };
    print_vector("W_MAX", W_MAX_i);
    int found = 0;
    int W_MAX;
    

    cout << "Device parameters: \n";
    int FPGA_CLOCK_FREQUENCY;
    int W;
    int F;

    cout << "Test parameters: \n";



    return 0;
}