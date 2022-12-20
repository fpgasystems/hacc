#include <iostream>
#include <vector> // for vectors
#include <algorithm> // for find
//#include <math.h>

using namespace std;

void print_vector(std::string name, vector<int> v)
{
    cout << name + " [ ";
    if (v.size() <= 10) {
        for (int x : v)
            cout << x << " ";
    }
    else {
        int n = v.size() - 1;
        std::string s0 = std::to_string(v[0]);
        std::string s1 = std::to_string(v[n]);
        cout << s0 + " .. " + s1;     
    }
    cout << "]: "; 
}

int read_value(std::string name, vector<int> v)
{
    print_vector(name, v);
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

vector<int> new_vector(int min_, int max_)
{
    vector<int> myVec;
    //int i = 0;
    //double j;
    for( int i = min_; i <= max_; i++ )
        //j = pow(2, i);
        myVec.push_back(i);
    return myVec;
}

int main()
{

    cout << "\n\e[1mcreate_config\e[0m\n";
    cout << "\n";

    struct {
        int myNum;
        string myString;
    } config;

    cout << "Simulation parameters: \n";
    // Tclk
    vector<int> T_clk_i{ 1, 2, 3, 4, 5, 10, 20, 30, 40, 50 };
    int T_clk = read_value("T_clk", T_clk_i);
    cout << "\n";

    cout << "Host parameters:  \n";
    // W_MAX
    vector<int> W_MAX_i{ 1, 2, 4, 8, 16, 32, 64, 128, 256 };
    int W_MAX = read_value("W_MAX", W_MAX_i);
    cout << "\n";

    cout << "Device parameters: \n";
    // FPGA_CLOCK_FREQUENCY
    vector<int> FPGA_CLOCK_FREQUENCY_i{ 100, 200, 300, 400 };
    int FPGA_CLOCK_FREQUENCY = read_value("FPGA_CLOCK_FREQUENCY", FPGA_CLOCK_FREQUENCY_i);
    // W
    vector<int> W_i = new_vector(1, W_MAX);
    int W = read_value("W", W_i);
    // F
    vector<int> F_i = new_vector(0, W);
    int F = read_value("F", F_i);
    cout << "\n";

    cout << "Test parameters: \n";
    cout << "RMSE_MAX: 0.01 \n";
    double RMSE_MAX = 0.01;
    cout << "\n";

    return 0;
}