#include <iostream>
#include <vector>
#include <algorithm>
#include <filesystem>
#include <fstream> 
#include <regex>
#include "../platform_params.hpp"

namespace fs = std::filesystem;
using namespace std;
using std::filesystem::directory_iterator;

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

ofstream create_config_file(int hw)
{
    fs::path p = fs::current_path();
    string project_path = p.relative_path();
    project_path = "/" + project_path + "/configs/";
    int n = 0;
    for (const auto & file : directory_iterator(project_path)){
        n = n + 1;
    }
    string s = std::to_string(n - 1); // we assume config_hw is always present too
    unsigned int number_of_zeros = STRING_LENGTH - s.length();
    s.insert(0, number_of_zeros, '0');
    if (hw == 1) {
        s = "config_hw";
    }
    else {
        s = "config_" + s;    
    }
    string aux = project_path + s + ".hpp";
    std::ofstream o(aux.c_str());
    return o;
}

bool file_exists(const fs::path& p, fs::file_status s = fs::file_status{})
{
    bool exist;
    if (fs::status_known(s) ? fs::exists(s) : fs::exists(p))
        exist = 1;
    else
        exist = 0;

    return exist;
}

int read_parameter(string conf_name, string parameter)
{

  ifstream ifs(conf_name);
  string word = parameter;
  std::regex e{"\\b" + word + "\\b"};

  string line;
  while( getline(ifs, line ))
  {
    if ( regex_search(line, e) ){
      int firstDelPos = line.find("=");
      // Find the position of second delimiter
      int secondDelPos = line.find(";");
      // Get the substring between two delimiters
      line = line.substr(firstDelPos+1, secondDelPos-firstDelPos-1);
      line.erase(std::remove_if(line.begin(), line.end(), ::isspace),
        line.end());
      return stoi(line);
    }
  }
}

int main()
{

    cout << "\n\e[1mcreate_config\e[0m\n";

    const fs::path config_hw{"./configs/config_hw.hpp"};
    bool exist = file_exists(config_hw);
    if (exist == 0) {

        cout << "\n\e[1mApplication (hardware) parameters:\e[0m\n";
        cout << "\n";

        // N_MAX (VECTOR_LENGTH_MAX)
        vector<int> N_MAX_i{ 16, 32, 48, 64, 80, 96, 112, 128 };
        int N_MAX = read_value("N_MAX", N_MAX_i);
        
        // W_MAX
        vector<int> W_MAX_i{ 1, 2, 4, 8, 16, 32, 64, 128, 256 };
        int W_MAX = read_value("W_MAX", W_MAX_i);

        // create hardware configuration
        ofstream c_hw = create_config_file(1);
        c_hw << std::endl;
        // Application (hardware) parameters
        c_hw << "const int N_MAX = " <<  N_MAX << ";" << std::endl;
        c_hw << "const int W_MAX = " <<  W_MAX << ";" << std::endl;
        c_hw << std::endl;

    }
    
    // Specific software parameters (your application) -------------------------------------------------------------------------

    cout << "\n";
    cout << "\e[1mApplication (software) parameters:\e[0m\n";
    cout << "\n";

    //cout << "Simulation parameters: \n";
    //cout << "\n";
    // Tclk
    //vector<int> T_clk_i{ 1, 2, 3, 4, 5, 10, 20, 30, 40, 50 };
    //int T_clk = read_value("T_clk", T_clk_i);
    //cout << "\n";

    cout << "Host parameters:  \n";
    cout << "\n";
    
    // Tclk
    vector<int> T_clk_i{ 1, 2, 3, 4, 5, 10, 20, 30, 40, 50 };
    int T_clk = read_value("T_clk", T_clk_i);
    // N (VECTOR_LENGTH)
    int N_MAX = read_parameter("./configs/config_hw.hpp", "N_MAX");
    vector<int> N_i;
    for (int i = 16; i <= N_MAX; i = i + 16) {
        N_i.push_back(i);
    }
    int N = read_value("N", N_i);
    // W
    int W_MAX = read_parameter("./configs/config_hw.hpp", "W_MAX");
    vector<int> W_i = new_vector(1, W_MAX);
    int W = read_value("W", W_i);
    // F
    vector<int> F_i = new_vector(0, W);
    int F = read_value("F", F_i);
    cout << "\n";

    cout << "Device parameters: \n";
    cout << "\n";
    // FPGA_CLOCK_FREQUENCY
    vector<int> FPGA_CLOCK_FREQUENCY_i{ 100, 200, 300, 400 };
    int FPGA_CLOCK_FREQUENCY = read_value("FPGA_CLOCK_FREQUENCY", FPGA_CLOCK_FREQUENCY_i);

    cout << "Test parameters: \n";
    cout << "\n";
    cout << "RMSE_MAX: 0.01 \n";
    double RMSE_MAX = 0.01;
    cout << "\n";

    // create software configuration
    ofstream c = create_config_file(0);
    c << std::endl;
    c << "const int T_clk = " <<  T_clk << ";" << std::endl;
    c << "const int N = " <<  N << ";" << std::endl;
    c << "const int W = " <<  W << ";" << std::endl;
    c << "const int F = " <<  F << ";" << std::endl;
    c << "const int FPGA_CLOCK_FREQUENCY = " <<  FPGA_CLOCK_FREQUENCY << ";" << std::endl;
    c << "const double RMSE_MAX = " <<  RMSE_MAX << ";" << std::endl;
    c << std::endl;

    return 0;
}