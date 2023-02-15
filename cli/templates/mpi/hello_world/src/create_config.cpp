#include <iostream>
#include <vector>
#include <algorithm>
#include <filesystem>
#include <fstream> 
#include <regex>
#include "../coyote_params.hpp"

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

ofstream create_config_file(int hw)
{
    fs::path p = fs::current_path();
    string project_path = p.relative_path();
    project_path = "/" + project_path + "/configs/";
    int n = 0;
    for (const auto & file : directory_iterator(project_path)){
        n = n + 1;
    }
    string s = std::to_string(n - 1); // we assume config_shell is always present too
    unsigned int number_of_zeros = STRING_LENGTH - s.length();
    s.insert(0, number_of_zeros, '0');
    if (hw == 1) {
        s = "config_shell";
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

    cout << "\n\e[1mMPI Application parameters:\e[0m\n";
    cout << "\n";

    // N_MAX (PROCESSES_PER_HOST_MAX)
    vector<int> N_MAX_i{ 10, 20, 30, 40, 50 };
    int N_MAX = read_value("N_MAX", N_MAX_i);

    cout << "Host parameters:  \n";
    cout << "\n";
    
    // N (PROCESSES_PER_HOST)
    vector<int> N_i;
    for (int i = 1; i <= N_MAX; i++) {
        N_i.push_back(i);
    }
    int N = read_value("N", N_i);
    

    // create config file
    ofstream c = create_config_file(0);
    c << "const int N_MAX = " <<  N_MAX << ";" << std::endl;
    c << "const int N = " <<  N << ";" << std::endl;

    return 0;
}