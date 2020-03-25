#include <iostream>

using namespace std;

int main(int argc, char **argv)
{
    unsigned int Array[] = {24,17,71,98,3,45,76,8,11,9};
    unsigned int summ1=0, summ2=0;
    cout<<"Исходный массив:\tПреобразованный массив:"<<endl;
    for(unsigned int i=0;i<10;i++)
    {
        summ1+=Array[i];
        cout<<Array[i];
        Array[i] |= 1<<4;
        cout<<"\t\t\t"<<Array[i]<<endl;
        summ2+=Array[i];
    }
    cout<<"\n\nСуммы:\n"<<summ1<<"\t\t\t"<<summ2<<endl;
}
