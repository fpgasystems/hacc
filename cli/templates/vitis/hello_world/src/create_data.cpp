#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <string>
#include <vector>
using namespace std;

#include "../configs/config_000.hpp" // config_000.hpp is overwritten with the configuration you select

using TYPE = string;                   // the type of your data; use string if unknown

int main()
{
   string filename = "./input_data/data_000.txt";
   vector< vector<TYPE> > data;
   
   ifstream in( filename );
   for ( string line; getline( in, line ); )
   {
      stringstream ss( line );
      vector<TYPE> row;
      for ( TYPE d; ss >> d; ) row.push_back( d );
      data.push_back( row );
   }

   cout << "Your data:\n";
   for ( auto &row : data )
   {
      for ( auto &item : row ) cout << setw( 10 ) << item << ' ';
      cout << '\n';
   }

   vector<string> x;
   vector<string> y;
   
   for (int i = 0; i < VECTOR_LENGTH; i++)
   {
      x.push_back(to_string(i));
      y.push_back(to_string(i)); 
   }

   for(int i = 0; i < x.size(); i++)
   {
      cout<<x[i]<<" ";
      cout<<y[i]<<" ";
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
            
            cout << "First line" << '\n';
            //cout << line << '\n';
            int j = 0;
            stringstream ss(line);  
            string word;
            while (ss >> word) { // Extract word from the stream.
               cout << word << endl;
               x[j] = word;
               j++;
            }
            cout << endl;
         } else if (i == 1) { // second vector
            
            cout << "Second line" << '\n';
            //cout << line << '\n';

            int j = 0;
            stringstream ss(line);  
            string word;
            while (ss >> word) { // Extract word from the stream.
               cout << word << endl;
               y[j] = word;
               j++;
            }
            cout << endl;
         }
         i++;
         //cout << line << '\n';
      }
      data_file.close();
   }
   else cout << "Unable to open file";

   for(int i = 0; i < x.size(); i++)
   {
      cout<<x[i]<<" ";
      cout<<y[i]<<" ";
   }


}

