#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <string>
#include <vector>
using namespace std;

#include "../configs/config_000.hpp" // config_000.hpp is overwritten with the configuration you select

using TYPE = string;                   // the type of your data; use string if unknown


vector<TYPE> read_vector(string data_file_name, int idx)
{
   // initialize x
   vector<TYPE> x;
   for (int i = 0; i < VECTOR_LENGTH; i++)
   {
      x.push_back(to_string(i));
   } 

   // fill x
   ifstream data_file(data_file_name);
   string line;
   if (data_file.is_open())
   {
      //int i = 0;
      
      while (getline(data_file, line))
      {
         if (idx == 0) // first vector
         {
            int j = 0;
            stringstream ss(line);  
            string word;
            while (ss >> word) {
               //cout << word << endl;
               x[j] = word;
               j++;
            }
            cout << endl;
         } else if (idx == 1) { // second vector
            int j = 0;
            stringstream ss(line);  
            string word;
            while (ss >> word) {
               //cout << word << endl;
               x[j] = word;
               j++;
            }
            cout << endl;
         }
         //i++;
      }
      data_file.close();
   }
   else cout << "Unable to open file";

   return x;
    
}



int main()
{

   vector<TYPE> x;
   vector<TYPE> y;
   
   for (int i = 0; i < VECTOR_LENGTH; i++)
   {
      x.push_back(to_string(i));
      y.push_back(to_string(i)); 
   }

   ifstream data_file("./input_data/data_001.txt");
   string line;
   if (data_file.is_open())
   {
      int i = 0;
      while (getline(data_file, line))
      {
         if (i == 0) // first vector
         {
            int j = 0;
            stringstream ss(line);  
            string word;
            while (ss >> word) {
               //cout << word << endl;
               x[j] = word;
               j++;
            }
            //cout << endl;
         } else if (i == 1) { // second vector
            int j = 0;
            stringstream ss(line);  
            string word;
            while (ss >> word) {
               //cout << word << endl;
               y[j] = word;
               j++;
            }
            //cout << endl;
         }
         i++;
      }
      data_file.close();
   }
   else cout << "Unable to open file";

   for(int i = 0; i < x.size(); i++)
   {
      cout<<x[i]<<" ";
      //cout<<y[i]<<" ";
   }
   cout << endl;

   for(int i = 0; i < x.size(); i++)
   {
      //cout<<x[i]<<" ";
      cout<<y[i]<<" ";
   }
   cout << endl;

}

