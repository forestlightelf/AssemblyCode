#include <iostream>
#include <fstream>
using namespace std;
int main(void)
{
    fstream readfile;
    readfile.open("template.txt");
    
    fstream writefile;
    writefile.open("result.txt",ios::out);
    writefile<<"\"";

    char ch;
    while ((ch=readfile.get())!=EOF)
    {
        if(ch=='\n')
        {
            writefile<<"\""<<","<<"\n"<<"\"";
        }
        else if(ch=='\t')
        {
            writefile<<"   ";
        }
        else
        writefile<<ch;
    }
    writefile<<"\""<<",";
    return 0;
}