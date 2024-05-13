#include <stdint.h>

static void Magnitude2String(uint8_t magnitude, char *string, unsigned radix){
	static const char table[] = "0123456789ABCDEF";
	int digits[3],index,k;
	
	//8 bits => there are at most 3 radix digits
	//compute digits from least to most significant
	for(k=2; k>=0; k--){
		digits[k] = magnitude%radix;
		magnitude/=radix;
	}
	
	//translate radix digits to characters and build the string, skipping over any leading zeroes and always displaying the least significant digit
	index =0;
	for(k=0;k<3;k++){
		if(digits[k]!=0||index>0||k==2){
			int digit = digits[k];
			string[index++] = table[digit];
		}
	}
	string[index] = '\0'; //terminate the string
} 
		
//radix 8
void Bits2OctalString(uint8_t bits, char string[]){
	Magnitude2String(bits,string,8);
}

//radix 10
void Bits2UnsignedString(uint8_t bits, char string[]){
	Magnitude2String(bits,string,10);
}

//radix 16
void Bits2HexString(uint8_t bits, char string[]){
	Magnitude2String(bits,string,16);
}

void Bits2CompString(uint8_t bits, char string[]){
	int8_t value = (int8_t)bits;
	int i = 0;
	if(value<0){
		value = -value;
		string[i++] = '-';
	}
	else{
		string[i++] = '+';
	}
	Bits2UnsignedString((uint8_t)value, string+i);
	
}
	
void Bits2SignMagString(uint8_t bits, char string[]){
	uint8_t value = bits & 0x7F;
	int i =0;
	if(bits & 0x80){
		string[i++] = '-';
	}
	else{
		string[i++] = '+';
	}
	Bits2UnsignedString(value, string+i);
}

