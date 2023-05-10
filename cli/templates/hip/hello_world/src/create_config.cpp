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
    string s = std::to_string(n);
    unsigned int number_of_zeros = STRING_LENGTH - s.length();
    s.insert(0, number_of_zeros, '0');
    s = "config_" + s;
    return s;
}

ofstream create_config_file()
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
    string s = std::to_string(n);
    unsigned int number_of_zeros = STRING_LENGTH - s.length();
    s.insert(0, number_of_zeros, '0');
    s = "config_" + s;    
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

    cout << "\n\e[1mApplication parameters:\e[0m\n";
    cout << "\n";

    // N (size of vectors, n)
    vector<int> N_i{ 2560, 5120, 10240 };
    int N = read_value("N", N_i);

    // Number of threads in each thread block (blockSize)
    vector<int> N_THREADS_i{ 128, 256 };
    int N_THREADS = read_value("N_THREADS", N_THREADS_i);
    
    // N (number of processes)
    //vector<int> N_i;
    //for (int i = 1; i <= N_MAX; i++) {
    //    N_i.push_back(i);
    //}
    //int N = read_value("N", N_i);
    //cout << "\n";

    // get config string
    string s = get_config_string();

    // create config file
    ofstream c = create_config_file();
    c << "const int N = " << N << ";" << std::endl;
    c << "const int N_THREADS = " << N_THREADS << ";" << std::endl;

    cout << "\n";
    cout << "The configuration " << s << ".hpp has been created!\n";
    cout << "\n";

    return 0;
}