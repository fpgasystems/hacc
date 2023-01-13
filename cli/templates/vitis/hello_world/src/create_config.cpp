#include <iostream>
#include <vector>
#include <algorithm>
#include <filesystem>
#include <fstream> 
#include "../platform_params.hpp"

namespace fs = std::filesystem;
using namespace std;
using std::filesystem::directory_iterator;

//#define STRING_LENGTH 3 // ha d'anar al config

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
    for( int i = min_; i <= max_; i++ )
        myVec.push_back(i);
    return myVec;
}

ofstream create_config_file()
{
    fs::path p = fs::current_path();
    string project_path = p.relative_path();
    project_path = "/" + project_path + "/configs/";
    int n = 0;
    for (const auto & file : directory_iterator(project_path)){
        n = n + 1;
    }
    string s = std::to_string(n);
    unsigned int number_of_zeros = STRING_LENGTH - s.length();
    s.insert(0, number_of_zeros, '0');
    s = "config_" + s;
    string aux = project_path + s + ".hpp";
    std::ofstream o(aux.c_str());
    return o;
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
    // VECTOR_LENGTH
    vector<int> VECTOR_LENGTH_i{ 1, 2, 3, 4, 5, 10, 20 };
    int VECTOR_LENGTH = read_value("VECTOR_LENGTH", VECTOR_LENGTH_i);
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

    // create configuration
    ofstream c = create_config_file();
    //c << "#if !defined(MYLIB_CONSTANTS_H)\n";
    //c << "#define MYLIB_CONSTANTS_H 1\n";
    // config parameters
    c << std::endl;
    c << "const int T_clk = " <<  T_clk << ";" << std::endl;
    c << "const int W_MAX = " <<  W_MAX << ";" << std::endl;
    c << "const int VECTOR_LENGTH = " <<  VECTOR_LENGTH << ";" << std::endl;
    c << "const int FPGA_CLOCK_FREQUENCY = " <<  FPGA_CLOCK_FREQUENCY << ";" << std::endl;
    c << "const int W = " <<  W << ";" << std::endl;
    c << "const int F = " <<  F << ";" << std::endl;
    c << "const double RMSE_MAX = " <<  RMSE_MAX << ";" << std::endl;
    c << std::endl;
    // endif
    //c << "#endif\n" << std::endl;

    return 0;
}