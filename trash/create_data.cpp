#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <string>
#include <vector>
#include "../configs/config_000.hpp" // config_000.hpp is overwritten with the configuration you select

using namespace std;
using TYPE = string;                   // the type of your data; use string if unknown

/* struct greaterSmaller {
    int greater, smaller;
};


Struct read_data(string data_file_name)
{
   
   //TYPE array[2];
   struct data;
   
   // initialize x
   vector<TYPE> x;
   vector<TYPE> y;
   for (int i = 0; i < N; i++)
   {
      x.push_back(to_string(i));
      y.push_back(to_string(i));
   } 

   // fill x
   ifstream data_file(data_file_name);
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
   
   data.x = x;
   data.y = y;
   //array[0] = x;
   //array[1] = y;

   //return array;
    
} */



int main()
{

   vector<TYPE> x;
   vector<TYPE> y;
   
   for (int i = 0; i < N; i++)
   {
      x.push_back(to_string(i));
      y.push_back(to_string(i)); 
   }

   ifstream data_file("./input_data/data_000.txt");
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
               x[j] = word;
               j++;
            }
         } else if (i == 1) { // second vector
            int j = 0;
            stringstream ss(line);  
            string word;
            while (ss >> word) {
               y[j] = word;
               j++;
            }
         }
         i++;
      }
      data_file.close();
   }
   else cout << "Unable to open file";

   for(int i = 0; i < x.size(); i++)
   {
      cout<<x[i]<<" ";
   }
   cout << endl;

   for(int i = 0; i < x.size(); i++)
   {
      cout<<y[i]<<" ";
   }
   cout << endl;

   //struct data = read_data("./input_data/data_000.txt");

}

