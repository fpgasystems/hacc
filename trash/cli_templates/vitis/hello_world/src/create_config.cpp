#include <iostream>
#include <vector>
#include <algorithm>
#include <filesystem>
#include <fstream> 
#include <regex>
#include "../global_params.hpp"

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

string get_config_string()
{
    fs::path p = fs::current_path();
    string project_path = p.relative_path();
    project_path = "/" + project_path + "/configs/";
    int n = 0;
    for (const auto & file : directory_iterator(project_path)){
        if (file.path().extension() == ".hpp") {
            n = n + 1;
        }
    }
    string s = std::to_string(n - 1); // we assume config_kernel is always present too
    unsigned int number_of_zeros = STRING_LENGTH - s.length();
    s.insert(0, number_of_zeros, '0');
    s = "config_" + s;    
    return s;
}

ofstream create_config_file(int hw)
{
    fs::path p = fs::current_path();
    string project_path = p.relative_path();
    project_path = "/" + project_path + "/configs/";
    int n = 0;
    for (const auto & file : directory_iterator(project_path)){
        if (file.path().extension() == ".hpp") {
            n = n + 1;
        }
    }
    string s = std::to_string(n - 1); // we assume config_kernel is always present too
    unsigned int number_of_zeros = STRING_LENGTH - s.length();
    s.insert(0, number_of_zeros, '0');
    if (hw == 1) {
        s = "config_kernel";
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

    const fs::path config_kernel{"./configs/config_kernel.hpp"};
    bool exist = file_exists(config_kernel);
    if (exist == 0) {
        
        cout << "\n\e[1mHardware (xclbin) parameters:\e[0m\n";
        cout << "\n";

        // N_MAX (VECTOR_LENGTH_MAX)
        vector<int> N_MAX_i{ 16, 32, 48, 64, 80, 96, 112, 128 };
        int N_MAX = read_value("N_MAX", N_MAX_i);
        
        // W_MAX
        vector<int> W_MAX_i{ 1, 2, 4, 8, 16, 32, 64, 128, 256 };
        int W_MAX = read_value("W_MAX", W_MAX_i);

        // CLK_F_MAX (USER LOGIC CLOCK FREQUENCY)
        vector<int> CLK_F_MAX_i{ 250, 300, 350, 400 };
        int CLK_F_MAX = read_value("CLK_F_MAX", CLK_F_MAX_i);

        // create hardware configuration
        ofstream c_kernel = create_config_file(1);
        c_kernel << "const int N_MAX = " <<  N_MAX << ";" << std::endl;
        c_kernel << "const int W_MAX = " <<  W_MAX << ";" << std::endl;
        c_kernel << "const int CLK_F_MAX = " <<  CLK_F_MAX << ";" << std::endl;
    }    

    cout << "\n";
    cout << "\e[1mSoftware (host) parameters:\e[0m\n";
    cout << "\n";

    cout << "Host parameters:  \n";
    cout << "\n";
    
    // N (VECTOR_LENGTH)
    int N_MAX = read_parameter("./configs/config_kernel.hpp", "N_MAX");
    vector<int> N_i;
    for (int i = 16; i <= N_MAX; i = i + 16) {
        N_i.push_back(i);
    }
    int N = read_value("N", N_i);
    // W
    int W_MAX = read_parameter("./configs/config_kernel.hpp", "W_MAX");
    vector<int> W_i = new_vector(1, W_MAX);
    int W = read_value("W", W_i);
    // F
    vector<int> F_i = new_vector(0, W);
    int F = read_value("F", F_i);
    // T_CLK
    vector<int> TLCK_i{ 1, 2, 3, 4, 5, 10, 20, 30, 40, 50 };
    int T_CLK = read_value("T_CLK", TLCK_i);
    cout << "\n";

    cout << "Device parameters: \n";
    cout << "\n";

    // CLK_F
    int CLK_F_MAX = read_parameter("./configs/config_kernel.hpp", "CLK_F_MAX");
    vector<int> CLK_F_i;
    for (int i = 250; i <= CLK_F_MAX; i = i + 50) {
        CLK_F_i.push_back(i);
    }
    int CLK_F = read_value("CLK_F", CLK_F_i);
    cout << "\n";
    
    cout << "Test parameters: \n";
    cout << "\n";
    cout << "RMSE: 0.01 \n";
    double RMSE = 0.01;
    cout << "\n";

    // get config string
    string s = get_config_string();

    // create config file
    ofstream c = create_config_file(0);
    c << "const int N = " <<  N << ";" << std::endl;
    c << "const int W = " <<  W << ";" << std::endl;
    c << "const int F = " <<  F << ";" << std::endl;
    c << "const int T_CLK = " <<  T_CLK << ";" << std::endl;
    c << "const int CLK_F = " <<  CLK_F << ";" << std::endl;
    c << "const double RMSE = " <<  RMSE << ";" << std::endl;

    cout << "The configuration " << s << ".hpp has been created!\n";
    cout << "\n";

    return 0;
}