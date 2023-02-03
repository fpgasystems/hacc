#include <iostream>
#include <vector>
#include <algorithm>
#include <filesystem>
#include <fstream> 
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
    std::cout << p;
    bool exist;
    if (fs::status_known(s) ? fs::exists(s) : fs::exists(p))
        //std::cout << " exists\n";
        exist = 1;
    else
        //std::cout << " does not exist\n";
        exist = 0;
        
    return exist;
}

int main()
{

    const fs::path config_hw{"./configs/config_hw.hpp"};
    bool exist = file_exists(config_hw);
    if (exist) {
        std::cout << " exists\n";
    }    
    else {
        std::cout << " does not exist\n";
    }    

    // Parameters according Coyote documentation (bitstream) -------------------------------------------------------------------------
    
    cout << "\n\e[1mBitstream (hardware) parameters:\e[0m\n";
    cout << "\n";

    struct {
        int myNum;
        string myString;
    } config;

    cout << "Global parameters: \n";
    cout << "\n";

    // N_REGIONS
    vector<int> N_REGIONS_i{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 };
    int N_REGIONS = read_value("N_REGIONS", N_REGIONS_i);
    // EN_PR
    vector<int> EN_PR_i{ 0, 1 };
    int EN_PR = read_value("EN_PR", EN_PR_i);
    // N_CONFIG
    vector<int> N_CONFIG_i{ 1, 2, 3, 4 };
    int N_CONFIG = read_value("N_CONFIG", N_CONFIG_i);
    // EN_HLS
    vector<int> EN_HLS_i{ 0, 1 };
    int EN_HLS = read_value("EN_HLS", EN_HLS_i);
    cout << "\n";

    cout << "Memory parameters: \n";
    cout << "\n";

    // EN_DDR
    vector<int> EN_DDR_i{ 0, 1 };
    int EN_DDR = read_value("EN_DDR", EN_DDR_i);
    // N_DDR_CHAN
    vector<int> N_DDR_CHAN_i{ 0, 1, 2, 3, 4 };
    int N_DDR_CHAN = read_value("N_DDR_CHAN", N_DDR_CHAN_i);
    // EN_STRM
    vector<int> EN_STRM_i{ 0, 1 };
    int EN_STRM = read_value("EN_STRM", EN_STRM_i);    
    // EN_HBM
    vector<int> EN_HBM_i{ 0, 1 };
    int EN_HBM = read_value("EN_HBM", EN_HBM_i);
    cout << "\n";

    cout << "Networking parameters: \n";
    cout << "\n";

    // EN_TCP_0
    vector<int> EN_TCP_0_i{ 0, 1 };
    int EN_TCP_0 = read_value("EN_TCP_0", EN_TCP_0_i);
    // EN_TCP_1
    vector<int> EN_TCP_1_i{ 0, 1 };
    int EN_TCP_1 = read_value("EN_TCP_1", EN_TCP_1_i);
    // EN_RDMA_0
    vector<int> EN_RDMA_0_i{ 0, 1 };
    int EN_RDMA_0 = read_value("EN_RDMA_0", EN_RDMA_0_i);
    // EN_RDMA_1
    vector<int> EN_RDMA_1_i{ 0, 1 };
    int EN_RDMA_1 = read_value("EN_RDMA_1", EN_RDMA_1_i);
    // EN_RPC
    vector<int> EN_RPC_i{ 0, 1 };
    int EN_RPC = read_value("EN_RPC", EN_RPC_i);
    cout << "\n";

    cout << "Clocking parameters: \n";
    cout << "\n";

    // EN_ACLK
    vector<int> EN_ACLK_i{ 0, 1 };
    int EN_ACLK = read_value("EN_ACLK", EN_ACLK_i);
    int ACLK_F = 250;
    if (EN_ACLK == 1) {
        // ACLK_F
        vector<int> ACLK_F_i{ 250, 300, 350, 400 };
        ACLK_F = read_value("ACLK_F", ACLK_F_i);
    }
    // EN_NCLK
    vector<int> EN_NCLK_i{ 0, 1 };
    int EN_NCLK = read_value("EN_NCLK", EN_NCLK_i);
    int NCLK_F = 250;
    if (EN_NCLK == 1) {
        // NCLK_F
        vector<int> NCLK_F_i{ 250, 300, 350, 400 };
        NCLK_F = read_value("NCLK_F", NCLK_F_i);
    }
    // EN_UCLK
    vector<int> EN_UCLK_i{ 0, 1 };
    int EN_UCLK = read_value("EN_UCLK", EN_UCLK_i);
    int UCLK_F = 300;
    if (EN_UCLK == 1) {
        // UCLK_F
        vector<int> UCLK_F_i{ 300, 350, 400 };
        UCLK_F = read_value("UCLK_F", UCLK_F_i);
    }

    // create hardware configuration
    ofstream c_hw = create_config_file(1);
    c_hw << std::endl;
    // Global parameters
    c_hw << "const int N_REGIONS = " <<  N_REGIONS << ";" << std::endl;
    c_hw << "const int EN_PR = " <<  EN_PR << ";" << std::endl;
    c_hw << "const int N_CONFIG = " <<  N_CONFIG << ";" << std::endl;
    c_hw << "const int EN_HLS = " <<  EN_HLS << ";" << std::endl;
    // Memory parameters
    c_hw << "const int EN_DDR = " <<  EN_DDR << ";" << std::endl;
    c_hw << "const int N_DDR_CHAN = " <<  N_DDR_CHAN << ";" << std::endl;
    c_hw << "const int EN_STRM = " <<  EN_STRM << ";" << std::endl;
    c_hw << "const int EN_HBM = " <<  EN_HBM << ";" << std::endl;
    // Networking parameters
    c_hw << "const int EN_TCP_0 = " <<  EN_TCP_0 << ";" << std::endl;
    c_hw << "const int EN_TCP_1 = " <<  EN_TCP_1 << ";" << std::endl;
    c_hw << "const int EN_RDMA_0 = " <<  EN_RDMA_0 << ";" << std::endl;
    c_hw << "const int EN_RDMA_1 = " <<  EN_RDMA_1 << ";" << std::endl;
    c_hw << "const int EN_RPC = " <<  EN_RPC << ";" << std::endl;
    // Cloking parameters
    c_hw << "const int EN_ACLK = " <<  EN_ACLK << ";" << std::endl;
    //if (EN_ACLK == 1) {
        c_hw << "const int ACLK_F = " <<  ACLK_F << ";" << std::endl;
    //}
    c_hw << "const int EN_NCLK = " <<  EN_NCLK << ";" << std::endl;
    //if (EN_NCLK == 1) {
        c_hw << "const int NCLK_F = " <<  NCLK_F << ";" << std::endl;
    //}
    c_hw << "const int EN_UCLK = " <<  EN_UCLK << ";" << std::endl;
    //if (EN_UCLK == 1) {
        c_hw << "const int UCLK_F = " <<  UCLK_F << ";" << std::endl;
    //}
    c_hw << std::endl;

    // Specific software parameters (your application) -------------------------------------------------------------------------

    cout << "\n";
    cout << "\e[1mApplication (software) parameters:\e[0m\n";
    cout << "\n";

    cout << "Host parameters:  \n";
    cout << "\n";
    // W_MAX
    vector<int> W_MAX_i{ 1, 2, 4, 8, 16, 32, 64, 128, 256 };
    int W_MAX = read_value("W_MAX", W_MAX_i);
    // VECTOR_LENGTH
    vector<int> VECTOR_LENGTH_i{ 16, 32, 48, 64, 80, 96, 112, 128 };
    int VECTOR_LENGTH = read_value("VECTOR_LENGTH", VECTOR_LENGTH_i);
    cout << "\n";

    cout << "Device parameters: \n";
    cout << "\n";
    // W
    vector<int> W_i = new_vector(1, W_MAX);
    int W = read_value("W", W_i);
    // F
    vector<int> F_i = new_vector(0, W);
    int F = read_value("F", F_i);
    cout << "\n";

    cout << "Test parameters: \n";
    cout << "\n";
    cout << "RMSE_MAX: 0.01 \n";
    double RMSE_MAX = 0.01;
    cout << "\n";

    // create software configuration
    ofstream c_sw = create_config_file(0);
    c_sw << std::endl;
    c_sw << "const int N_REGIONS = " <<  N_REGIONS << ";" << std::endl;
    c_sw << "const int W_MAX = " <<  W_MAX << ";" << std::endl;
    c_sw << "const int VECTOR_LENGTH = " <<  VECTOR_LENGTH << ";" << std::endl;
    c_sw << "const int W = " <<  W << ";" << std::endl;
    c_sw << "const int F = " <<  F << ";" << std::endl;
    c_sw << "const double RMSE_MAX = " <<  RMSE_MAX << ";" << std::endl;
    c_sw << std::endl;

    return 0;
}